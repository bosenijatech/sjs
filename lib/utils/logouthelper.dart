import 'package:winstar/services/pref.dart';
import 'package:winstar/views/login/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutHelper {
  /// 🔐 Force logout with a message dialog
  static Future<void> forceLogout(BuildContext context,
      {String message =
          "Your account has been locked/removed the access from NetSuite. Please contact your administrator!"}) async {
    // Prevent showing multiple dialogs
    if (Navigator.of(context).canPop()) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }

    // Show a blocking alert dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Disable back button
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              "Account Locked",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  fontSize: 16),
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  await _clearUserData();
                  // Navigate to login page and clear navigation stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🧹 Clears all saved user data (Prefs + SharedPreferences)
  static Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Optional extra cleanup if you use Prefs helper
    Prefs.clear();
    Prefs.remove("remove");
    Prefs.setLoggedIn("IsLoggedIn", false);
  }
}
