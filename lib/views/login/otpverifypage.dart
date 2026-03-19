import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: AppUtils.buildNormalText(
            text: "Verification",
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              CupertinoIcons.back,
            )),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Email verification',
              style: TextStyle(
                color: Appcolor.primarycolor,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 32),
            child: Row(
              children: [
                Text(
                  'OTP Code sent to your email',
                  style: TextStyle(
                      color: Appcolor.primarycolor.withOpacity(0.7),
                      fontSize: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  'youremail@email.com',
                  style: TextStyle(
                      color: Appcolor.primarycolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          PinCodeTextField(
            appContext: (context),
            length: 4,
            onChanged: (value) {},
            obscureText: false,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 70,
              fieldWidth: 70,
              activeColor: Appcolor.primarycolor,
              inactiveColor: Appcolor.border,
              inactiveFillColor: Appcolor.primarySoft,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 32, bottom: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/landingpage');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                backgroundColor: Appcolor.primarycolor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'poppins'),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Appcolor.primarycolor,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              backgroundColor: Appcolor.primarySoft,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              'Resend OTP Code',
              style: TextStyle(
                color: Appcolor.primarycolor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
