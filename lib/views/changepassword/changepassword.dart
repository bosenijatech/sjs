import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/appcolor.dart';
import 'package:sjs/views/login/loginpage.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:sjs/views/widgets/custom_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldpasswordcontroller = TextEditingController();
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;
  bool loading = false;
  @override
  void dispose() {
    oldpasswordcontroller.dispose();
    newpasswordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppUtils.buildNormalText(
            text: 'Change Password',
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/changpwdimage.png',
                          height: 300,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: oldpasswordcontroller,
                          obscureText: _obscureText1,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "Enter Old Password",
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.black26, width: 1),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText1 = !_obscureText1;
                                });
                              },
                              child: Icon(
                                _obscureText1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Appcolor.black,
                                semanticLabel: _obscureText1
                                    ? 'show password'
                                    : 'hide password',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: newpasswordcontroller,
                          obscureText: _obscureText2,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "Enter New Password",
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.black26, width: 1),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText2 = !_obscureText2;
                                });
                              },
                              child: Icon(
                                _obscureText2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Appcolor.black,
                                semanticLabel: _obscureText2
                                    ? 'show password'
                                    : 'hide password',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: confirmpasswordcontroller,
                          obscureText: _obscureText3,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.black26, width: 1),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText3 = !_obscureText3;
                                });
                              },
                              child: Icon(
                                _obscureText3
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Appcolor.black,
                                semanticLabel: _obscureText3
                                    ? 'show password'
                                    : 'hide password',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    CustomButton(
                        onPressed: () {
                          if (oldpasswordcontroller.text.isEmpty) {
                            AppUtils.showSingleDialogPopup(
                                context,
                                "Old password Should not left empty!",
                                "Ok",
                                exitpopup,
                                null);
                          } else if (newpasswordcontroller.text.isEmpty) {
                            AppUtils.showSingleDialogPopup(
                                context,
                                "New password Should not left empty!",
                                "Ok",
                                exitpopup,
                                null);
                          } else if (confirmpasswordcontroller.text.isEmpty) {
                            AppUtils.showSingleDialogPopup(
                                context,
                                "Confirm password Should not left empty!",
                                "Ok",
                                exitpopup,
                                null);
                          } else if (newpasswordcontroller.text.toString() !=
                              confirmpasswordcontroller.text.toString()) {
                            AppUtils.showSingleDialogPopup(
                                context,
                                "New and Confirm password Mismatch!",
                                "Ok",
                                exitpopup,
                                null);
                          } else {
                            updateloginpassword();
                          }
                        },
                        name: "Change Password",
                        circularvalue: 30),
                  ],
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }

  void exitpopup() {
    Navigator.of(context).pop();
  }

  void updateloginpassword() async {
    setState(() {
      loading = true;
    });
    ApiService.updatepassword(oldpasswordcontroller.text.toString(),
            confirmpasswordcontroller.text.toString())
        .then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              oncloseapp,
              AssetsImageWidget.successimage);
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              exitpopup,
              AssetsImageWidget.errorimage);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(
          context, e.toString(), "Ok", exitpopup, AssetsImageWidget.errorimage);
    });
  }

  void oncloseapp() {
    Navigator.of(context).pop();
    Prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }
}
