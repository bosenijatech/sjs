



import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/models/offline/offlineattendance.dart';
import 'package:winstar/models/offline/punchmodel.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';

import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/attendance/clock_widgets.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';
import '../../offlinedata/databasehelper.dart';

import '../../offlinedata/synserviceget.dart';
import '../widgets/offline_address_resolver.dart';

class AttendanceEntryPage extends StatefulWidget {
  final String sid;
  final String name;
  final bool checkin;
  final bool checkout;

  const AttendanceEntryPage({
    super.key,
    required this.sid,
    required this.name,
    required this.checkin,
    required this.checkout,
  });

  @override
  State<AttendanceEntryPage> createState() => _AttendanceEntryPageState();
}

class _AttendanceEntryPageState extends State<AttendanceEntryPage>
    with WidgetsBindingObserver {

  // Map
  LatLng latlong = const LatLng(0.0, 0.0);
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  String _remark = "";
  final TextEditingController _remarkController = TextEditingController();
  
  // Address
  String _rawAddress = "";        
  String _displayAddress = "";     
  AddressSource _addressSource = AddressSource.coordinates;
  bool _locationLoading = true;

  // UI state
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.enabled) _initLocation();
    });
    _initLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _initLocation();
  }

  // ─────────────────────────────────────────
  // LOCATION INIT
  // ─────────────────────────────────────────

  Future<void> _initLocation() async {
    // GPS service check
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        AppUtils.showSnackbar(context: context, message: "Please enable GPS");
      }
      await Geolocator.openLocationSettings();
      await Future.delayed(const Duration(seconds: 2));
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
    }

    // Permission check
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        AppUtils.showSnackbar(
            context: context, message: "Location permission required");
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
      return;
    }

    await _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    if (mounted) setState(() => _locationLoading = true);

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        latlong = LatLng(position.latitude, position.longitude);
        _markers
          ..clear()
          ..add(Marker(
            markerId: const MarkerId("current"),
            position: latlong,
            draggable: true,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
            onDragEnd: (newPos) {
              latlong = newPos;
              _resolveAddress(newPos.latitude, newPos.longitude);
            },
          ));
        _locationLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latlong, zoom: 17),
        ),
      );

      await _resolveAddress(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("❌ fetchLocation: $e");
      if (mounted) setState(() => _locationLoading = false);
    }
  }

  // ─────────────────────────────────────────
  // ADDRESS RESOLVE — offline/online
  // ─────────────────────────────────────────

  Future<void> _resolveAddress(double lat, double lng) async {
    final result = await OfflineAddressResolver.resolve(lat, lng);

    if (!mounted) return;

    setState(() {
      _rawAddress = result.address;         // DB save
      _addressSource = result.source;

      if (result.isCoordinates) {
        // Coordinates format — human readable display
        _displayAddress = OfflineAddressResolver.displayAddress(result.address);
      } else {
        _displayAddress = result.address;
      }
    });

    debugPrint("📍 Address [${result.source.name}]: $_rawAddress");
  }

  bool get _isOfflineAddress => _addressSource == AddressSource.coordinates;

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool mapReady = latlong.latitude > 0.0 && latlong.longitude > 0.0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
          text: widget.name,
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          // Retry location button
          if (mapReady)
            IconButton(
              icon: const Icon(Icons.my_location, color: Colors.black87),
              tooltip: "Refresh location",
              onPressed: _fetchLocation,
            ),
        ],
      ),
      body: Stack(
        children: [
          // ── MAP ──
          mapReady
              ? GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: latlong, zoom: 17),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: latlong, zoom: 17),
                      ),
                    );
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoActivityIndicator(
                        radius: 20, color: Appcolor.primarycolor),
                      const SizedBox(height: 12),
                      const Text("Getting your location...",
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),

          // ── BOTTOM PANEL ──
          if (mapReady)
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: _buildBottomPanel(),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // BOTTOM PANEL
  // ─────────────────────────────────────────

  Widget _buildBottomPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Offline Banner — only for coordinates ──
          if (_isOfflineAddress) _buildOfflineBanner(),

          // ── Address Row ──
          _buildAddressRow(),
          _buildRemarkField(),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // ── Clock + Buttons ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Date & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ClockWidget(),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMMEEEEd().format(DateTime.now()),
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Action Button
              _buildActionButton(),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // OFFLINE BANNER — only for real offline (coordinates)
  // Don't show for nominatimFallback (already has proper address)
  // ─────────────────────────────────────────

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off_rounded,
              size: 14, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Offline mode — GPS location saved.\nAddress will update when online.",
              style: TextStyle(
                fontSize: 11,
                color: Colors.orange.shade800,
                height: 1.4,
              ),
            ),
          ),
          // Retry
          GestureDetector(
            onTap: _fetchLocation,
            child: Icon(Icons.refresh_rounded,
                size: 16, color: Colors.orange.shade700),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // ADDRESS ROW
  // ─────────────────────────────────────────

  Widget _buildAddressRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          _isOfflineAddress ? Icons.location_searching : Icons.location_pin,
          color: _isOfflineAddress ? Colors.orange : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _displayAddress.isNotEmpty
                    ? _displayAddress
                    : "Fetching address...",
                style: TextStyle(
                  fontSize: 13,
                  color: _isOfflineAddress
                      ? Colors.orange.shade800
                      : Colors.black87,
                  fontStyle: _isOfflineAddress
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (_isOfflineAddress)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "Tap refresh to retry",
                    style: TextStyle(
                        fontSize: 10, color: Colors.orange.shade600),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // REMARK FIELD
  // ─────────────────────────────────────────

  Widget _buildRemarkField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          "Remark",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _remarkController,
          maxLines: 2,
          onChanged: (val) => _remark = val,
          decoration: InputDecoration(
            hintText: "Enter remark (optional)",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // ACTION BUTTON — Clock In / Clock Out
  // ─────────────────────────────────────────

  Widget _buildActionButton() {
    final isClockIn = widget.checkin;
    final label = isClockIn ? "Clock In" : "Clock Out";
    final color = isClockIn ? Colors.blue : Colors.redAccent;

    return SizedBox(
      width: 130,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _actionLoading ? Colors.grey : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: _actionLoading
            ? null
            : () {
                final type = isClockIn ? "IN" : "OUT";
                _addAttendance(type);
              },
        child: _actionLoading
            ? const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // MAIN ACTION — DB FIRST → POPUP → BACKGROUND SYNC
  // ═══════════════════════════════════════════════════════════

  Future<void> _addAttendance(String type) async {
    if (_actionLoading) return;

    final DateTime now = DateTime.now();
    final String cdate = DateFormat("dd/MM/yyyy").format(now);
    final String cdatetime = DateFormat("hh:mm a").format(now);
    final String empId =
        Prefs.getNsID(SharefprefConstants.sharednsid)?.toString() ?? "";
    final String empName =
        Prefs.getFullName(SharefprefConstants.shareFullName)?.toString() ?? "";

    setState(() => _actionLoading = true);

    // ── STEP 1: DB save ──
    String attendanceId = "";
    Punch? newPunch;

    try {
      final result = await _saveToDb(
        type: type,
        empId: empId,
        cdate: cdate,
        cdatetime: cdatetime,
      );
      attendanceId = result.$1;
      newPunch = result.$2;
    } catch (e) {
      debugPrint("❌ DB save: $e");
      setState(() => _actionLoading = false);
      if (mounted) {
        AppUtils.showSingleDialogPopup(
          context,
          "Failed to save. Please try again.",
          "Ok",
          () => Navigator.of(context).pop(),
          AssetsImageWidget.errorimage,
        );
      }
      return;
    }

    setState(() => _actionLoading = false);
    // ✅ CLEAR REMARK
    _remarkController.clear();
    _remark = "";

    // ── STEP 2: Success popup ──
    if (mounted) {
      AppUtils.showSingleDialogPopup(
        context,
        type == "IN"
            ? "Clock In recorded successfully."
            : "Clock Out recorded successfully.",
        "Ok",
        _onRefreshScreen,
        AssetsImageWidget.successimage,
      );
    }

    // ── STEP 3: Background API sync ──
    if (newPunch != null) {
      _syncInBackground(
        attendanceId: attendanceId,
        empId: empId,
        empName: empName,
        date: cdate,
        punch: newPunch,
      );
    }
  }

  // ─────────────────────────────────────────
  // BACKGROUND SYNC — fire & forget
  // ─────────────────────────────────────────

  void _syncInBackground({
    required String attendanceId,
    required String empId,
    required String empName,
    required String date,
    required Punch punch,
  }) {
    Future.microtask(() async {
      final synced = await SyncService().syncSinglePunch(
        attendanceId: attendanceId,
        empId: empId,
        empName: empName,
        date: date,
        punch: punch,
      );
      debugPrint(synced
          ? "🟢 Background sync OK: ${punch.type} @ ${punch.time}"
          : "🟡 Will retry: ${punch.type} @ ${punch.time}");
    });
  }

  // ─────────────────────────────────────────
  // DB SAVE — returns (attendanceId, newPunch?)
  // ─────────────────────────────────────────

  Future<(String, Punch?)> _saveToDb({
    required String type,
    required String empId,
    required String cdate,
    required String cdatetime,
  }) async {
    final db = DatabaseHelper.instance;
    final nowStr = DateTime.now().toIso8601String();

    final String attendanceId = widget.sid.isNotEmpty
        ? widget.sid
        : DateTime.now().millisecondsSinceEpoch.toString();

    final existing = await db.getAttendance(attendanceId);
    final existingPunches = await db.getPunchesForAttendance(attendanceId);

    // Duplicate check
    final alreadyExists = existingPunches.any(
      (p) => p.type == type && p.time == cdatetime,
    );

    if (alreadyExists) {
      debugPrint("⚠ Duplicate punch ignored: $type @ $cdatetime");
      final attendance = _buildAttendance(
        attendanceId: attendanceId,
        empId: empId,
        cdate: cdate,
        cdatetime: cdatetime,
        type: type,
        existing: existing,
        isSynced: existing?.isSynced ?? false,
        nowStr: nowStr,
      );
      await db.insertAttendance(attendance, existingPunches);
      return (attendanceId, null);
    }

    // ✅ New punch — _rawAddress use
    // Offline: can be "lat,lng" or proper address from Nominatim fallback
    // Online:  proper address
    final newPunch = Punch(
      attendanceId: attendanceId,
      type: type,
      time: cdatetime,
      latitude: latlong.latitude.toString(),
      longitude: latlong.longitude.toString(),
      address: _rawAddress,
      remark: _remarkController.text.trim(),
      isSynced: false,
    );

    final attendance = _buildAttendance(
      attendanceId: attendanceId,
      empId: empId,
      cdate: cdate,
      cdatetime: cdatetime,
      type: type,
      existing: existing,
      isSynced: false,
      nowStr: nowStr,
    );

    await db.insertAttendance(attendance, [...existingPunches, newPunch]);

    debugPrint(
        "💾 Saved [$type @ $cdatetime] address: $_rawAddress "
        "(source: ${_addressSource.name})");

    return (attendanceId, newPunch);
  }

  Attendance _buildAttendance({
    required String attendanceId,
    required String empId,
    required String cdate,
    required String cdatetime,
    required String type,
    required Attendance? existing,
    required bool isSynced,
    required String nowStr,
  }) {
    return Attendance(
      id: attendanceId,
      internalId: existing?.internalId ?? 0,
      empId: empId,
      date: cdate,
      checkIn: type == "IN"
          ? (existing?.checkIn?.isNotEmpty == true
              ? existing!.checkIn
              : cdatetime)
          : (existing?.checkIn ?? ""),
      checkOut: type == "OUT" ? cdatetime : existing?.checkOut,
      status: "present",
      isRegularized: false,
      isSynced: isSynced,
      shiftId: null,
      projectId: null,
      createdAt: existing?.createdAt ?? nowStr,
      updatedAt: nowStr,
    );
  }

  void _onRefreshScreen() {
    Navigator.of(context).pop(); // popup close
    Navigator.of(context).pop(); // page close
  }
}