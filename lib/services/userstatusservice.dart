import 'dart:async';
import 'dart:convert';
import 'package:sjs/models/empinfomodel.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/utils/logouthelper.dart';
import 'package:flutter/material.dart';

class UserStatusService {
  // ✅ Singleton setup
  static final UserStatusService _instance = UserStatusService._internal();
  factory UserStatusService() => _instance;
  UserStatusService._internal();

  // ✅ Stream + Subscription
  StreamSubscription? _subscription;
  Stream<int>? _timerStream;

  // ✅ To track if service is running
  bool _isRunning = false;

  // ✅ Start checking every 3 minutes
  void startChecking(BuildContext context) {
    if (_isRunning) return;
    _isRunning = true;

    _timerStream =
        Stream.periodic(const Duration(minutes: 3), (count) => count);
    _subscription = _timerStream!.listen((count) async {
      await _checkUserIsDisabled(context);
    });
  }

  // ✅ Stop checking (e.g., on logout)
  void stopChecking() {
    _subscription?.cancel();
    _subscription = null;
    _isRunning = false;
  }

  // ✅ Main logic to verify user
  Future<void> _checkUserIsDisabled(BuildContext context) async {
    try {
      final response = await ApiService.getemployeedetailsdata();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'].toString() == "true") {
          final empInfo = EmpInfoModel.fromJson(decoded);
          final mobileAccess =
              empInfo.message?.mobileaccess?.toString() ?? "false";

          if (mobileAccess != "true") {
            if (!context.mounted) return;
            _forceLogout(context);
          }
        } else {
          if (!context.mounted) return;
          _forceLogout(context);
        }
      } else {
        throw Exception(
            jsonDecode(response.body)['message'] ?? 'Unknown error');
      }
    } catch (e) {
      debugPrint("❌ Error checking user status: $e");
    }
  }

  // ✅ Handle forced logout
  void _forceLogout(BuildContext context) {
    debugPrint("⚠️ User is disabled. Forcing logout...");
    stopChecking();
    LogoutHelper.forceLogout(context); // your logout logic here
  }
}
