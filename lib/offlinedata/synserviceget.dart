


import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../domain/ApiService.dart';
import '../models/offline/offlineattendance.dart';
import '../models/offline/punchmodel.dart';
import '../services/pref.dart';
import '../utils/sharedprefconstants.dart';
import 'databasehelper.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  Timer? _attendanceTimer;
  Timer? _masterTimer;
  StreamSubscription? _connectivitySub;

  bool _syncInProgress = false;
  bool _masterSyncInProgress = false;

  Future<bool> _isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.isNotEmpty &&
        !results.every((r) => r == ConnectivityResult.none);
  }

  void startConnectivityListener() {
    _connectivitySub?.cancel();
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((results) async {
      final online = results.isNotEmpty &&
          !results.every((r) => r == ConnectivityResult.none);
      debugPrint("📶 Connectivity → online: $online");
      if (online) {
        await Future.delayed(const Duration(seconds: 2));
        await syncAll();
      }
    });
    debugPrint("👂 Connectivity listener started");
  }

  void stopConnectivityListener() => _connectivitySub?.cancel();

  /// 🎯 MAIN SYNC FLOW
  /// 1. Push unsynced punches to server
  /// 2. Refresh from server (source of truth)
  /// 3. Update offline addresses
  Future<void> syncAll() async {
    debugPrint("🚀 syncAll()");
     await _updateOfflineAddresses(); // Post-processing
    await sendToServer();       // Push local changes
    await _refreshTodayFromServer(); // Pull server state (this is source of truth)
   
  }

  Future<void> _updateOfflineAddresses() async {
    try {
      final online = await _isOnline();
      if (!online) {
        debugPrint("📵 Offline — skip address update");
        return;
      }

      final db = DatabaseHelper.instance;
      final allRows = await db.getAttendanceWithDetails();

      for (final row in allRows) {
        final attendanceId = row['id'] as String;
        final punches = await db.getPunchesForAttendance(attendanceId);

        final hasCoordPunches =
            punches.any((p) => _isCoordinateAddress(p.address));
        if (!hasCoordPunches) continue;

        bool anyUpdated = false;

        final updatedPunches = <Punch>[];
        for (final punch in punches) {
          if (!_isCoordinateAddress(punch.address)) {
            updatedPunches.add(punch);
            continue;
          }

          try {
            final parts = punch.address.split(',');
            if (parts.length != 2) {
              updatedPunches.add(punch);
              continue;
            }
            final lat = double.tryParse(parts[0].trim());
            final lng = double.tryParse(parts[1].trim());
            if (lat == null || lng == null) {
              updatedPunches.add(punch);
              continue;
            }

            final properAddress = await _nominatimReverse(lat, lng);
            if (properAddress != null && properAddress.isNotEmpty) {
              anyUpdated = true;
              debugPrint("🏠 ${punch.address} → $properAddress");
              updatedPunches.add(punch.copyWith(address: properAddress));
            } else {
              updatedPunches.add(punch);
            }

            await Future.delayed(const Duration(milliseconds: 1100));
          } catch (e) {
            debugPrint("⚠ Address update: $e");
            updatedPunches.add(punch);
          }
        }

        if (anyUpdated) {
          final attendance = Attendance(
            id: attendanceId,
            internalId: row['internalId'] as int? ?? 0,
            empId: row['empId'] as String? ?? "",
            date: row['date'] as String? ?? "",
            checkIn: row['checkIn'] as String? ?? "",
            checkOut: row['checkOut'] as String?,
            status: row['status'] as String? ?? "present",
            isRegularized: (row['isRegularized'] as int? ?? 0) == 1,
            isSynced: (row['isSynced'] as int? ?? 0) == 1,
            shiftId: row['shiftId'] as int?,
            projectId: row['projectId'] as int?,
            createdAt:
                row['createdAt'] as String? ?? DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          );
          await db.insertAttendance(attendance, updatedPunches);
          debugPrint("✅ Address updated: $attendanceId");
        }
      }
    } catch (e) {
      debugPrint("⚠ _updateOfflineAddresses: $e");
    }
  }

  Future<String?> _nominatimReverse(double lat, double lng) async {
    try {
      final uri = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse"
        "?lat=$lat&lon=$lng&format=json&addressdetails=1",
      );

      final response = await http.get(
        uri,
        headers: {
          "User-Agent": "SJSAttendanceApp/1.0",
          "Accept-Language": "en",
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final addr = data['address'] as Map<String, dynamic>?;
      if (addr == null) return null;

      debugPrint("🗺 Nominatim raw: $addr");

      final parts = <String>[];

      void add(String? val) {
        if (val == null) return;
        final v = val.trim();
        if (v.isEmpty) return;
        if (parts.any((p) => p.toLowerCase() == v.toLowerCase())) return;
        parts.add(v);
      }

      final street = (addr['road'] 
          ?? addr['pedestrian'] 
          ?? addr['path']
          ?? addr['footway']
          ?? addr['residential']) as String?;
      add(street);

      add(addr['neighbourhood'] as String?);
      add(addr['suburb'] as String?);
      add(addr['village'] as String?);
      
      add(addr['town'] as String?);
      
      add(addr['city'] as String?);
      add(addr['municipality'] as String?);

      final county = addr['county'] as String?;
      if (county != null && !parts.any((p) => p.toLowerCase() == county.toLowerCase())) {
        add(county);
      }

      add(addr['state_district'] as String?);
      add(addr['state'] as String?);
      add(addr['postcode'] as String?);
      add(addr['country'] as String?);

      if (parts.isEmpty) return null;

      debugPrint("🏠 Nominatim built: ${parts.join(', ')}");
      return parts.join(', ');

    } catch (e) {
      debugPrint("⚠ Nominatim: $e");
      return null;
    }
  }

  bool _isCoordinateAddress(String? address) {
    if (address == null || address.isEmpty) return false;
    final parts = address.split(',');
    if (parts.length != 2) return false;
    return double.tryParse(parts[0].trim()) != null &&
        double.tryParse(parts[1].trim()) != null;
  }

  /// 📤 SEND TO SERVER
  /// Push only unsynced punches to backend
  /// Does NOT clear local data on failure
  Future<void> sendToServer() async {
    if (_syncInProgress) return;
    _syncInProgress = true;

    debugPrint("🔁 sendToServer()");

    try {
      final online = await _isOnline();
      if (!online) {
        debugPrint("📵 Offline — skip sync");
        return;
      }

      final empId =
          Prefs.getNsID(SharefprefConstants.sharednsid)?.toString() ?? "";
      final empName =
          Prefs.getFullName(SharefprefConstants.shareFullName)?.toString() ??
              "";

      final db = DatabaseHelper.instance;
      final pendingList = await db.getPendingAttendance();

      debugPrint("📤 Pending attendance: ${pendingList.length}");

      if (pendingList.isEmpty) {
        debugPrint("✅ Nothing to sync");
        return;
      }

      for (final record in pendingList) {
        final attendanceId = record['id'] as String;

        final unsyncedPunches = await db.getUnsyncedPunches(attendanceId);

        debugPrint(
            "🔄 $attendanceId | unsynced punches: ${unsyncedPunches.length}");

        if (unsyncedPunches.isEmpty) {
          debugPrint("✅ All punches already synced for $attendanceId");
          await db.updateAttendanceSync(attendanceId);
          continue;
        }

        bool allPunchesSynced = true;

        for (final punch in unsyncedPunches) {
          try {
            final Map<String, dynamic> body = {
              "empId": record['empId']?.toString() ?? empId,
              "empName": empName,
              "date": record['date'] ?? "",
              "time": punch.time,
              "type": punch.type,
              "latitude": punch.latitude,
              "longitude": punch.longitude,
              "remark": punch.remark,
              "address": punch.address,
              "mobileid": "",
            };

            debugPrint("📡 POST: ${punch.type} @ ${punch.time}");

            final response = await ApiService.postBioAttendance(body);
            final respBody =
                jsonDecode(response.body) as Map<String, dynamic>;

            if (response.statusCode == 200 &&
                respBody['status'].toString() == "true") {
              await db.markPunchSynced(
                  attendanceId, punch.type, punch.time);
              debugPrint(
                  "✅ Punch synced: ${punch.type} @ ${punch.time}");
            } else {
              debugPrint(
                  "❌ API error: ${respBody['message']} — will retry");
              allPunchesSynced = false;
            }
          } catch (e) {
            debugPrint("❌ Punch POST failed: $e — will retry");
            allPunchesSynced = false;
          }
        }

        final stillHasUnsynced = await db.hasUnsyncedPunches(attendanceId);
        if (!stillHasUnsynced) {
          await db.updateAttendanceSync(attendanceId);
          debugPrint("✅ Attendance fully synced: $attendanceId");
        } else {
          debugPrint("⚠ Some punches pending retry: $attendanceId");
        }
      }
    } catch (e) {
      debugPrint("❌ sendToServer: $e");
    } finally {
      _syncInProgress = false;
    }
  }

  /// 📡 SYNC SINGLE PUNCH
  /// Immediately push one punch to server
  Future<bool> syncSinglePunch({
    required String attendanceId,
    required String empId,
    required String empName,
    required String date,
    required Punch punch,
  }) async {
    try {
      final online = await _isOnline();
      if (!online) {
        debugPrint("📵 Offline — will retry via periodic sync");
        return false;
      }

      String resolvedAddress = punch.address;

      if (_isCoordinateAddress(punch.address)) {
        final parts = punch.address.split(',');
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());

        if (lat != null && lng != null) {
          final properAddress = await _nominatimReverse(lat, lng);
          if (properAddress != null && properAddress.isNotEmpty) {
            resolvedAddress = properAddress;

            await DatabaseHelper.instance.updatePunchAddress(
              attendanceId,
              punch.type,
              punch.time,
              resolvedAddress,
            );
            debugPrint("📍 Address resolved: $resolvedAddress");
          }
        }
      }

      final Map<String, dynamic> body = {
        "empId": empId,
        "empName": empName,
        "date": date,
        "time": punch.time,
        "type": punch.type,
        "latitude": punch.latitude,
        "longitude": punch.longitude,
        "remark": punch.remark,
        "address": resolvedAddress,
        "mobileid": "",
      };

      debugPrint("📡 syncSinglePunch: ${punch.type} @ ${punch.time}");

      final response = await ApiService.postBioAttendance(body);
      final respBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 &&
          respBody['status'].toString() == "true") {
        final db = DatabaseHelper.instance;
        await db.markPunchSynced(attendanceId, punch.type, punch.time);

        final stillHasUnsynced = await db.hasUnsyncedPunches(attendanceId);
        if (!stillHasUnsynced) {
          await db.updateAttendanceSync(attendanceId);
        }

        debugPrint("✅ syncSinglePunch done: ${punch.type} @ ${punch.time}");
        return true;
      } else {
        debugPrint("❌ API rejected: ${respBody['message']}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ syncSinglePunch error: $e");
      return false;
    }
  }

  /// 🔄 REFRESH TODAY FROM SERVER - FIXED ✅
  /// 
  /// This is the **SOURCE OF TRUTH** refresh.
  /// Called AFTER sendToServer() completes.
  /// 
  /// Flow:
  /// ├─ Fetch today's data from backend
  /// ├─ If backend EMPTY or status=false:
  /// │  └─ Clear ALL data (synced + unsynced)
  /// │     → UI will show EMPTY
  /// └─ If backend HAS DATA:
  ///    ├─ Merge server punches with local unsynced punches
  ///    ├─ Update DB with merged data
  ///    └─ Mark attendance as synced/unsynced based on pending
  ///
  Future<void> _refreshTodayFromServer() async {
    try {
      debugPrint("🔄 _refreshTodayFromServer()");
      final online = await _isOnline();
      if (!online) {
        debugPrint("📵 Offline — skip refresh");
        return;
      }

      final response = await ApiService.viewbioattendance();

      if (response.statusCode != 200) {
        debugPrint("❌ Backend error: ${response.statusCode}");
        return;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      
      // ✅ CRITICAL FIX: If backend returns status=false, clear ALL data
      if (decoded['status'] != true) {
        debugPrint("⚠️ Backend status false → treating as empty");
        
        final db = DatabaseHelper.instance;
        
        // Delete ALL attendance and punches (synced + unsynced)
        await db.clearAllAttendanceData();
        
        debugPrint("✅ Database completely cleared - UI will be EMPTY");
        return;
      }

      if (decoded['message'] == null) {
        debugPrint("❌ Invalid response: message is null");
        return;
      }

      final message = decoded['message'] as Map<String, dynamic>;
      final serverId = message['_id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final List serverPunchList = message['punches'] ?? [];
      final db = DatabaseHelper.instance;

      debugPrint("📊 Backend has ${serverPunchList.length} punches");

      // 🔴 CRITICAL: Backend is EMPTY → Clear ALL data
      if (serverPunchList.isEmpty) {
        debugPrint("🔴 Backend EMPTY — clearing ALL data");
        
        await db.clearAllAttendanceData();

        debugPrint("✅ Local cleared — UI will be EMPTY");
        return;
      }

      // ✅ Backend HAS DATA → Merge with local unsynced
      final serverPunches = serverPunchList
          .map((p) => Punch(
                attendanceId: serverId,
                type: p['type'] ?? "",
                time: p['time'] ?? "",
                latitude: p['latitude'] ?? "",
                longitude: p['longitude'] ?? "",
                address: p['address'] ?? "",
                remark: p['remark'] ?? "",
                isSynced: true,
              ))
          .toList();

      final localPunches = await db.getPunchesForAttendance(serverId);
      final unsyncedLocal = localPunches.where((lp) {
        return !serverPunches
            .any((sp) => sp.type == lp.type && sp.time == lp.time);
      }).toList();

      debugPrint(
          "📊 Server: ${serverPunches.length} | Local unsynced: ${unsyncedLocal.length}");

      // Merge: server synced + local unsynced
      final mergedPunches = <Punch>[];
      final seen = <String>{};
      for (final p in [...serverPunches, ...unsyncedLocal]) {
        if (seen.add("${p.type}_${p.time}")) {
          mergedPunches.add(p);
        }
      }

      mergedPunches.sort((a, b) => a.time.compareTo(b.time));

      final hasPendingLocal = unsyncedLocal.isNotEmpty;

      // Create attendance record
      final attendance = Attendance(
        id: serverId,
        internalId: message['internalId'] ?? 0,
        empId: message['empId']?.toString() ?? "",
        date: message['date'] ?? "",
        checkIn: message['checkIn'] ?? "",
        checkOut: message['checkOut'],
        status: "present",
        isRegularized: message['isRegularized'] ?? false,
        isSynced: !hasPendingLocal,  // Synced only if no pending local
        shiftId: null,
        projectId: null,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Upsert
      await db.insertAttendance(attendance, mergedPunches);
      debugPrint(
          "✅ Refreshed | total: ${mergedPunches.length} | pending: $hasPendingLocal");
    } catch (e) {
      debugPrint("⚠ _refreshTodayFromServer: $e");
    }
  }

  Future<void> syncMaster() async {
    if (_masterSyncInProgress) return;
    _masterSyncInProgress = true;
    try {
      final online = await _isOnline();
      if (!online) return;
    } catch (e) {
      debugPrint("❌ syncMaster: $e");
    } finally {
      _masterSyncInProgress = false;
    }
  }

  void startPeriodicSync({
    Duration interval = const Duration(seconds: 30),
  }) {
    _attendanceTimer?.cancel();
    _attendanceTimer = Timer.periodic(interval, (_) => syncAll());
    debugPrint("⏱ Periodic sync every ${interval.inSeconds}s");
  }

  void startMasterSync({
    Duration interval = const Duration(minutes: 10),
  }) {
    _masterTimer?.cancel();
    _masterTimer = Timer.periodic(interval, (_) => syncMaster());
  }

  void stopAllTimers() {
    _attendanceTimer?.cancel();
    _masterTimer?.cancel();
    debugPrint("🛑 Timers stopped");
  }
}