import 'dart:async';
import 'package:flutter/material.dart';
import 'package:winstar/main.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/login/loginpage.dart';

class IdleTimeoutService with WidgetsBindingObserver {
  static const int timeoutDuration = 15 * 60; // 15 minutes in seconds
  Timer? _timer;

  IdleTimeoutService() {
    WidgetsBinding.instance.addObserver(this);
    resetTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: timeoutDuration), _handleTimeout);
  }

  void _handleTimeout() async {
    Prefs.clear();
    Prefs.remove("remove");
    Prefs.setLoggedIn(SharefprefConstants.sharefloggedin, false);
    idleService.dispose();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resetTimer(); // Reset timer when app is resumed
    }
  }

  void userActivityDetected() {
    resetTimer();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
  }
}
