


import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/offline/offlineattendance.dart';
import '../models/offline/projectmastermodel.dart';
import '../models/offline/punchmodel.dart';
import '../models/offline/shiftmastermodel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shift_master (
        id     INTEGER PRIMARY KEY AUTOINCREMENT,
        name   TEXT    NOT NULL,
        active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE project_master (
        id     INTEGER PRIMARY KEY AUTOINCREMENT,
        code   TEXT    NOT NULL UNIQUE,
        name   TEXT    NOT NULL,
        active INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance (
        id            TEXT    PRIMARY KEY,
        internalId    INTEGER NOT NULL,
        empId         TEXT    NOT NULL,
        date          TEXT    NOT NULL,
        checkIn       TEXT    NOT NULL,
        checkOut      TEXT,
        status        TEXT    NOT NULL,
        isRegularized INTEGER NOT NULL DEFAULT 0,
        isSynced      INTEGER NOT NULL DEFAULT 0,
        shiftId       INTEGER,
        projectId     INTEGER,
        createdAt     TEXT    NOT NULL,
        updatedAt     TEXT    NOT NULL,
        FOREIGN KEY (shiftId)   REFERENCES shift_master(id),
        FOREIGN KEY (projectId) REFERENCES project_master(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE punches (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        attendanceId TEXT    NOT NULL,
        type         TEXT    NOT NULL,
        time         TEXT    NOT NULL,
        latitude     TEXT    NOT NULL,
        longitude    TEXT    NOT NULL,
        address      TEXT    NOT NULL,
        remark       TEXT    NOT NULL DEFAULT '',
        isSynced     INTEGER NOT NULL DEFAULT 0,
        UNIQUE (attendanceId, type, time) ON CONFLICT REPLACE,
        FOREIGN KEY (attendanceId) REFERENCES attendance(id)
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='attendance'",
      );

      if (tables.isEmpty) {
        await db.execute('''
          CREATE TABLE attendance (
            id            TEXT    PRIMARY KEY,
            internalId    INTEGER NOT NULL,
            empId         TEXT    NOT NULL,
            date          TEXT    NOT NULL,
            checkIn       TEXT    NOT NULL,
            checkOut      TEXT,
            status        TEXT    NOT NULL,
            isRegularized INTEGER NOT NULL DEFAULT 0,
            isSynced      INTEGER NOT NULL DEFAULT 0,
            shiftId       INTEGER,
            projectId     INTEGER,
            createdAt     TEXT    NOT NULL,
            updatedAt     TEXT    NOT NULL
          )
        ''');
      } else {
        try { await db.execute('ALTER TABLE attendance ADD COLUMN shiftId INTEGER'); } catch (_) {}
        try { await db.execute('ALTER TABLE attendance ADD COLUMN projectId INTEGER'); } catch (_) {}
        try { await db.execute('ALTER TABLE attendance ADD COLUMN isSynced INTEGER NOT NULL DEFAULT 0'); } catch (_) {}
      }

      await db.execute('''
        CREATE TABLE IF NOT EXISTS shift_master (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          active INTEGER NOT NULL DEFAULT 1
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS project_master (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          code TEXT NOT NULL UNIQUE,
          name TEXT NOT NULL,
          active INTEGER NOT NULL DEFAULT 1
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS punches (
          id           INTEGER PRIMARY KEY AUTOINCREMENT,
          attendanceId TEXT    NOT NULL,
          type         TEXT    NOT NULL,
          time         TEXT    NOT NULL,
          latitude     TEXT    NOT NULL,
          longitude    TEXT    NOT NULL,
          address      TEXT    NOT NULL
        )
      ''');
    }

    if (oldVersion < 3) {
      try {
        await db.execute(
            'ALTER TABLE attendance ADD COLUMN isSynced INTEGER NOT NULL DEFAULT 0');
      } catch (_) {}
    }

    if (oldVersion < 4) {
      try {
        await db.execute(
            'ALTER TABLE punches ADD COLUMN isSynced INTEGER NOT NULL DEFAULT 0');
      } catch (_) {}

      try {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS punches_new (
            id           INTEGER PRIMARY KEY AUTOINCREMENT,
            attendanceId TEXT    NOT NULL,
            type         TEXT    NOT NULL,
            time         TEXT    NOT NULL,
            latitude     TEXT    NOT NULL,
            longitude    TEXT    NOT NULL,
            address      TEXT    NOT NULL,
            isSynced     INTEGER NOT NULL DEFAULT 0,
            UNIQUE (attendanceId, type, time) ON CONFLICT REPLACE,
            FOREIGN KEY (attendanceId) REFERENCES attendance(id)
          )
        ''');

        await db.execute('''
          INSERT OR REPLACE INTO punches_new
            (attendanceId, type, time, latitude, longitude, address, isSynced)
          SELECT attendanceId, type, time, latitude, longitude, address,
                 COALESCE(isSynced, 0)
          FROM punches
        ''');

        await db.execute('DROP TABLE punches');
        await db.execute('ALTER TABLE punches_new RENAME TO punches');

        debugPrint('✅ DB v4 migration: punches table upgraded');
      } catch (e) {
        debugPrint('⚠ DB v4 migration error: $e');
      }
    }
  }

  // ─────────────────────────────────────────
  // SHIFT MASTER CRUD
  // ─────────────────────────────────────────

  Future<int> insertShift(ShiftMaster shift) async {
    final db = await database;
    return await db.insert('shift_master', shift.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ShiftMaster>> getActiveShifts() async {
    final db = await database;
    final maps = await db.query('shift_master', where: 'active = ?', whereArgs: [1]);
    return maps.map((e) => ShiftMaster.fromMap(e)).toList();
  }

  Future<List<ShiftMaster>> getAllShifts() async {
    final db = await database;
    final maps = await db.query('shift_master');
    return maps.map((e) => ShiftMaster.fromMap(e)).toList();
  }

  Future<void> updateShift(ShiftMaster shift) async {
    final db = await database;
    await db.update('shift_master', shift.toMap(),
        where: 'id = ?', whereArgs: [shift.id]);
  }

  Future<void> deleteShift(int id) async {
    final db = await database;
    await db.update('shift_master', {'active': 0},
        where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────
  // PROJECT MASTER CRUD
  // ─────────────────────────────────────────

  Future<int> insertProject(ProjectMaster project) async {
    final db = await database;
    return await db.insert('project_master', project.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ProjectMaster>> getActiveProjects() async {
    final db = await database;
    final maps = await db.query('project_master', where: 'active = ?', whereArgs: [1]);
    return maps.map((e) => ProjectMaster.fromMap(e)).toList();
  }

  Future<List<ProjectMaster>> getAllProjects() async {
    final db = await database;
    final maps = await db.query('project_master');
    return maps.map((e) => ProjectMaster.fromMap(e)).toList();
  }

  Future<void> updateProject(ProjectMaster project) async {
    final db = await database;
    await db.update('project_master', project.toMap(),
        where: 'id = ?', whereArgs: [project.id]);
  }

  Future<void> deleteProject(int id) async {
    final db = await database;
    await db.update('project_master', {'active': 0},
        where: 'id = ?', whereArgs: [id]);
  }

  // ─────────────────────────────────────────
  // ATTENDANCE CRUD
  // ─────────────────────────────────────────

  Future<void> insertAttendance(
      Attendance attendance, List<Punch> punches) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert(
        'attendance',
        attendance.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (final punch in punches) {
        final existing = await txn.query(
          'punches',
          columns: ['isSynced'],
          where: 'attendanceId = ? AND type = ? AND time = ?',
          whereArgs: [punch.attendanceId, punch.type, punch.time],
          limit: 1,
        );

        if (existing.isNotEmpty) {
          final alreadySynced = (existing.first['isSynced'] as int? ?? 0) == 1;
          if (alreadySynced) {
            await txn.update(
              'punches',
              {
                'address': punch.address,
                'latitude': punch.latitude,
                'longitude': punch.longitude,
              },
              where: 'attendanceId = ? AND type = ? AND time = ?',
              whereArgs: [punch.attendanceId, punch.type, punch.time],
            );
            continue;
          }
        }

        await txn.insert(
          'punches',
          punch.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<Attendance?> getAttendance(String id) async {
    final db = await database;
    final maps = await db.query('attendance', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Attendance.fromMap(maps.first);
  }

  Future<void> updateCheckOut(String id, String checkOut) async {
    final db = await database;
    await db.update(
      'attendance',
      {
        'checkOut': checkOut,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ─────────────────────────────────────────
  // SYNC HELPERS — attendance level
  // ─────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getPendingAttendance() async {
    final db = await database;
    return await db.query('attendance', where: 'isSynced = ?', whereArgs: [0]);
  }

  Future<void> updateAttendanceSync(String id) async {
    final db = await database;
    await db.update(
      'attendance',
      {
        'isSynced': 1,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ─────────────────────────────────────────
  // PUNCH SYNC HELPERS — punch level ✅
  // ─────────────────────────────────────────

  Future<List<Punch>> getUnsyncedPunches(String attendanceId) async {
    final db = await database;
    final maps = await db.query(
      'punches',
      where: 'attendanceId = ? AND isSynced = ?',
      whereArgs: [attendanceId, 0],
    );
    return maps.map((e) => Punch.fromMap(e)).toList();
  }

  Future<void> markPunchSynced(
      String attendanceId, String type, String time) async {
    final db = await database;
    await db.update(
      'punches',
      {'isSynced': 1},
      where: 'attendanceId = ? AND type = ? AND time = ?',
      whereArgs: [attendanceId, type, time],
    );
  }

  Future<bool> hasUnsyncedPunches(String attendanceId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM punches WHERE attendanceId = ? AND isSynced = 0',
      [attendanceId],
    );
    return (result.first['cnt'] as int? ?? 0) > 0;
  }

  // ─────────────────────────────────────────
  // PUNCHES — all punches for attendance
  // ─────────────────────────────────────────

  Future<List<Punch>> getPunchesForAttendance(String attendanceId) async {
    final db = await database;
    final maps = await db.query(
      'punches',
      where: 'attendanceId = ?',
      whereArgs: [attendanceId],
    );
    return maps.map((e) => Punch.fromMap(e)).toList();
  }

  Future<void> updatePunchAddress(
    String attendanceId, String type, String time, String address) async {
    final db = await database;
    await db.update(
      'punches',
      {'address': address},
      where: 'attendanceId = ? AND type = ? AND time = ?',
      whereArgs: [attendanceId, type, time],
    );
  }

  // ─────────────────────────────────────────
  // JOIN QUERY
  // ─────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getAttendanceWithDetails() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT
        a.*,
        s.name AS shiftName,
        p.name AS projectName,
        p.code AS projectCode
      FROM attendance a
      LEFT JOIN shift_master   s ON a.shiftId   = s.id
      LEFT JOIN project_master p ON a.projectId = p.id
      ORDER BY a.date DESC
    ''');
  }

  // ─────────────────────────────────────────
  // DELETE HELPERS — CLEAR DATA ✅
  // ─────────────────────────────────────────

  /// ✅ Clear ALL attendance and punches (synced + unsynced)
  /// Called when backend returns empty or status=false
  Future<void> clearAllAttendanceData() async {
    try {
      final db = await database;
      
      // Delete all punches first (due to foreign key constraint)
      final punchesDeleted = await db.delete('punches');
      
      // Then delete all attendance records
      final attendanceDeleted = await db.delete('attendance');
      
      debugPrint("🗑 Cleared ALL: $punchesDeleted punches + $attendanceDeleted attendance");
    } catch (e) {
      debugPrint("❌ Error clearing all attendance data: $e");
    }
  }

  /// ✅ Delete all unsynced punches AND attendance (selective)
  Future<void> clearUnsyncedPunchesAndAttendance(String attendanceId) async {
    try {
      final db = await database;
      
      debugPrint("🔴 Clearing unsynced data for $attendanceId");
      
      final punchesDeleted = await db.delete(
        'punches',
        where: 'attendanceId = ? AND isSynced = 0',
        whereArgs: [attendanceId],
      );
      
      final attendanceDeleted = await db.delete(
        'attendance',
        where: 'id = ? AND isSynced = 0',
        whereArgs: [attendanceId],
      );
      
      debugPrint(
        "✅ Cleared: $punchesDeleted punches + $attendanceDeleted attendance for $attendanceId"
      );
    } catch (e) {
      debugPrint("❌ Error clearing unsynced data: $e");
    }
  }

  /// ✅ Delete only unsynced punches
  Future<int> deleteUnsyncedPunchesForAttendance(String attendanceId) async {
    try {
      final db = await database;
      
      final deleted = await db.delete(
        'punches',
        where: 'attendanceId = ? AND isSynced = 0',
        whereArgs: [attendanceId],
      );
      
      debugPrint("🗑 Deleted $deleted unsynced punches for $attendanceId");
      return deleted;
    } catch (e) {
      debugPrint("❌ Error deleting unsynced punches: $e");
      return 0;
    }
  }

  /// ✅ Delete only unsynced attendance
  Future<int> deleteUnsyncedAttendance(String attendanceId) async {
    try {
      final db = await database;
      
      final deleted = await db.delete(
        'attendance',
        where: 'id = ? AND isSynced = 0',
        whereArgs: [attendanceId],
      );
      
      debugPrint("🗑 Deleted $deleted unsynced attendance record(s)");
      return deleted;
    } catch (e) {
      debugPrint("❌ Error deleting unsynced attendance: $e");
      return 0;
    }
  }
}