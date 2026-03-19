


import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/attendanceModel.dart';
import 'package:winstar/models/offline/offlineattendance.dart';
import 'package:winstar/models/offline/punchmodel.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/views/attendance/attendanceentrypage.dart';
import 'package:winstar/views/attendance/googlemaps.dart';
import '../../offlinedata/databasehelper.dart';

import '../../offlinedata/synserviceget.dart';

class Attendancehistory extends StatefulWidget {
  const Attendancehistory({super.key});

  @override
  State<Attendancehistory> createState() => _AttendancehistoryState();
}

class _AttendancehistoryState extends State<Attendancehistory>
    with WidgetsBindingObserver {
  List<AttendanceModel> attendanceModel = [];
  bool loading = false;
  bool isOffline = false;
  bool isSyncing = false;

  String? _todayAttendanceId;
  StreamSubscription? _connectivitySub;

  bool get hasAttendanceToday => attendanceModel.isNotEmpty;

  List<PunchModel> get _sortedPunches {
    if (!hasAttendanceToday) return [];
    final punches = List<PunchModel>.from(
        attendanceModel.first.punches ?? []);

    punches.sort((a, b) => _parseTime(a.time).compareTo(_parseTime(b.time)));
    return punches;
  }


  String? get firstCheckIn {
    final inPunches =
        _sortedPunches.where((p) => p.type == "IN").toList();
    return inPunches.isNotEmpty ? inPunches.first.time : null;
  }


  String? get lastCheckOut {
    final outPunches =
        _sortedPunches.where((p) => p.type == "OUT").toList();
    return outPunches.isNotEmpty ? outPunches.last.time : null;
  }

  // ✅ Last punch type — button decide
  String? get lastPunchType {
    return _sortedPunches.isNotEmpty ? _sortedPunches.last.type : null;
  }

  // "hh:mm a" → DateTime for comparison
  DateTime _parseTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return DateTime(2000);
    try {
      final now = DateTime.now();
      // "01:19 PM" → parse
      final parts = timeStr.trim().split(' ');
      if (parts.length != 2) return DateTime(2000);
      final timeParts = parts[0].split(':');
      if (timeParts.length != 2) return DateTime(2000);
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final bool isPm = parts[1].toUpperCase() == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (_) {
      return DateTime(2000);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getattendancecheckdata();

    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((results) async {
      final online = results.isNotEmpty &&
          !results.every((r) => r == ConnectivityResult.none);
      if (online && mounted) {
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) getattendancecheckdata();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      getattendancecheckdata();
    }
  }

  Future<bool> _isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.isNotEmpty &&
        !results.every((r) => r == ConnectivityResult.none);
  }

  bool _isToday(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return false;
    final now = DateTime.now();
    final iso =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final slash =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    final dash =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    return dateStr.startsWith(iso) ||
        dateStr == slash ||
        dateStr == dash ||
        dateStr.contains(iso);
  }

  Future<void> _manualSync() async {
    if (isSyncing) return;
    setState(() => isSyncing = true);
    try {
      await SyncService().syncAll();
      await Future.delayed(const Duration(seconds: 1));
      getattendancecheckdata();
    } finally {
      if (mounted) setState(() => isSyncing = false);
    }
  }

  // ─────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
          text: "Attendance - Today",
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          isSyncing
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.sync, color: Colors.black),
                  tooltip: "Sync now",
                  onPressed: _manualSync,
                ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == "1") {
                Navigator.pushNamed(context, RouteNames.viewattendance);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: "1", child: Text("Add Regularization")),
            ],
          ),
        ],
      ),
      body: loading
          ? const Center(child: CustomIndicator())
          : RefreshIndicator(
              onRefresh: () async => getattendancecheckdata(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (isOffline) _offlineBanner(),
                    _headerCard(),
                    const SizedBox(height: 10),
                    _punchLogList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _offlineBanner() {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, size: 15, color: Colors.orange),
          const SizedBox(width: 8),
          const Expanded(
            child: Text("You're offline. Showing saved data.",
                style: TextStyle(fontSize: 12, color: Colors.orange)),
          ),
          GestureDetector(
            onTap: getattendancecheckdata,
            child: const Icon(Icons.refresh, size: 15, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // HEADER CARD
  // ─────────────────────────────────────────

  Widget _headerCard() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _clockInfoCard(
                  title: "FIRST CLOCK IN",
                  // ✅ sorted punches-ல் first IN time
                  value: firstCheckIn ?? "MISSING",
                  icon: Icons.call_received_outlined,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _clockInfoCard(
                  title: "LAST CLOCK OUT",
                  // ✅ sorted punches-ல் last OUT time
                  value: lastCheckOut ?? "MISSING",
                  icon: Icons.arrow_outward,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          if (hasAttendanceToday && _sortedPunches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.touch_app, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Total punches: ${_sortedPunches.length}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          _attendanceButton(),
        ],
      ),
    );
  }

  Widget _clockInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: value == "MISSING" ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // CLOCK BUTTON
  // ─────────────────────────────────────────

  Widget _attendanceButton() {
    String title = "Clock In";
    bool checkin = true;
    bool checkout = false;
    Color color = Colors.blue;
    final String sid = _todayAttendanceId ?? "";

    if (lastPunchType == "IN") {
      title = "Clock Out";
      checkin = false;
      checkout = true;
      color = Colors.redAccent;
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AttendanceEntryPage(
                sid: sid,
                name: title,
                checkin: checkin,
                checkout: checkout,
              ),
            ),
          ).then((_) => getattendancecheckdata());
        },
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white)),
      ),
    );
  }

  // ─────────────────────────────────────────
  // PUNCH LOG LIST — TIME ORDER
  // ─────────────────────────────────────────

  Widget _punchLogList() {
    if (!hasAttendanceToday || _sortedPunches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text("No logs found for today")),
      );
    }

    // ✅ Already sorted by time
    final punches = _sortedPunches;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            "Punch History (${punches.length})",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54),
          ),
        ),
        ListView.builder(
          itemCount: punches.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          itemBuilder: (context, index) {
            final punch = punches[index];
            final isIn = punch.type == "IN";
            final label = isIn ? "Clock In" : "Clock Out";

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isIn ? Colors.green.shade100 : Colors.red.shade100,
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isIn ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isIn ? Icons.call_received_outlined : Icons.arrow_outward,
                    color: isIn ? Colors.green : Colors.red,
                    size: 18,
                  ),
                ),
                title: Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isIn
                            ? Colors.green.shade700
                            : Colors.red.shade700)),
                subtitle: Text(punch.address ?? "-",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11)),
                trailing: Text(punch.time ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                onTap: () {
                  if ((punch.latitude ?? "").isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GoogleMapsPage(
                          latlang: "${punch.latitude},${punch.longitude}",
                          address: punch.address ?? "",
                          time: punch.time ?? "",
                          type: punch.type ?? "",
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // MAIN FETCH
  // ─────────────────────────────────────────

  void getattendancecheckdata() async {
    setState(() { loading = true; isOffline = false; });

    final online = await _isOnline();

    if (!online) {
      await _loadFromLocal();
      if (mounted) setState(() { loading = false; isOffline = true; });
      return;
    }

    ApiService.viewbioattendance().then((response) async {
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == true) {
          final model = AttendanceModel.fromJson(decoded['message']);
          await _saveToLocalNoDuplicate(model);
          await _loadFromLocal();
          if (mounted) setState(() { loading = false; isOffline = false; });
        } else {
          await _loadFromLocal();
          if (mounted) setState(() => loading = false);
        }
      } else {
        await _loadFromLocal();
        if (mounted) setState(() { loading = false; isOffline = true; });
      }
    }).catchError((e) async {
      await _loadFromLocal();
      if (mounted) setState(() { loading = false; isOffline = true; });
    });
  }

  // ─────────────────────────────────────────
  // SAVE API DATA → DB (NO DUPLICATE)
  // ─────────────────────────────────────────

  Future<void> _saveToLocalNoDuplicate(AttendanceModel model) async {
    try {
      final db = DatabaseHelper.instance;

      final attendanceId = model.id?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final attendance = Attendance(
        id: attendanceId,
        internalId: model.internalId ?? 0,
        empId: model.empId ?? "",
        date: model.date ?? "",
        checkIn: model.checkIn ?? "",
        checkOut: model.checkOut,
        status: "present",
        isRegularized: model.isRegularized ?? false,
        isSynced: true,
        shiftId: null,
        projectId: null,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Server punches
      final serverPunches = (model.punches ?? []).map((p) => Punch(
            attendanceId: attendanceId,
            type: p.type ?? "",
            time: p.time ?? "",
            latitude: p.latitude ?? "",
            longitude: p.longitude ?? "",
            address: p.address ?? "",
          )).toList();

 
      final localPunches = await db.getPunchesForAttendance(attendanceId);
      final unsyncedLocal = localPunches.where((lp) {
        return !serverPunches
            .any((sp) => sp.type == lp.type && sp.time == lp.time);
      }).toList();

      // Merge + deduplicate by type+time
      final merged = <Punch>[];
      final seen = <String>{};
      for (final p in [...serverPunches, ...unsyncedLocal]) {
        if (seen.add("${p.type}_${p.time}")) merged.add(p);
      }

      // Time sort
      merged.sort((a, b) =>
          _parseTime(a.time).compareTo(_parseTime(b.time)));

      await db.insertAttendance(attendance, merged);
    } catch (e) {
      debugPrint("❌ _saveToLocalNoDuplicate: $e");
    }
  }

  // ─────────────────────────────────────────
  // LOAD FROM DB
  // ─────────────────────────────────────────

  Future<void> _loadFromLocal() async {
    try {
      final db = DatabaseHelper.instance;
      final rows = await db.getAttendanceWithDetails();

      final todayRows =
          rows.where((r) => _isToday(r['date']?.toString())).toList();

      if (todayRows.isEmpty) {
        if (mounted) setState(() {
          attendanceModel.clear();
          _todayAttendanceId = null;
        });
        return;
      }

      final row = todayRows.first;
      final attendanceId = row['id'] as String;
      _todayAttendanceId = attendanceId;

      final localPunches = await db.getPunchesForAttendance(attendanceId);

      // Deduplicate
      final seen = <String>{};
      final uniquePunches = localPunches
          .where((p) => seen.add("${p.type}_${p.time}"))
          .toList();

      final punchModels = uniquePunches
          .map((p) => PunchModel(
                type: p.type,
                time: p.time,
                latitude: p.latitude,
                longitude: p.longitude,
                address: p.address,
              ))
          .toList();

      final model = AttendanceModel(
        id: attendanceId,
        internalId: row['internalId'] as int?,
        empId: row['empId'] as String?,
        date: row['date'] as String?,
        checkIn: row['checkIn'] as String?,
        checkOut: row['checkOut'] as String?,
        isRegularized: (row['isRegularized'] as int? ?? 0) == 1,
        punches: punchModels,
      );

      if (mounted) {
        setState(() {
          attendanceModel..clear()..add(model);
        });
      }
    } catch (e) {
      debugPrint("❌ _loadFromLocal: $e");
      if (mounted) setState(() => attendanceModel.clear());
    }
  }
}