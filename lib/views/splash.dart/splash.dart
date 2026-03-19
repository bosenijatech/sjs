import 'dart:async';

import 'package:flutter/material.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/leave/homepage.dart';
import 'package:winstar/views/login/loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getcheckedLoggin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.kwhite,
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Appcolor.kwhite,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/nijatechlogo.png"),
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
            Align(
              alignment: Alignment(0.0, 1.0),
              child: Text(
                "Winstar ESS",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  color: Color(0xffffffff),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getcheckedLoggin() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => (Prefs.getLoggedIn(
                                SharefprefConstants.sharefloggedin) ==
                            null ||
                        Prefs.getLoggedIn(SharefprefConstants.sharefloggedin) ==
                            false)
                    ? const LoginPage()
                    : const HomePage())));
  }
}
