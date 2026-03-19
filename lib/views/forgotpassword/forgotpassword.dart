import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_button.dart';

class ForgoPasswordPage extends StatefulWidget {
  const ForgoPasswordPage({super.key});

  @override
  _ForgoPasswordPageState createState() => _ForgoPasswordPageState();
}

class _ForgoPasswordPageState extends State<ForgoPasswordPage> {
  TextEditingController emailcontroller = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: !loading
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Image.asset("assets/images/forgotimage.png"),
                      ),
                      const SizedBox(height: 10),
                      const Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "We will send you an ",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            TextSpan(
                              text: "Password in respective Mail id",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: emailcontroller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.grey,
                            ),
                            hintText: "Enter your email id",
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) => input!.isValidEmail()
                              ? null
                              : "Enter your email id",
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                          onPressed: () {
                            if (emailcontroller.text.isEmpty) {
                              AppUtils.showSingleDialogPopup(
                                  context,
                                  "Please Enter Mail id",
                                  "Ok",
                                  exitpopup,
                                  AssetsImageWidget.warningimage);
                            } else {
                              postmail();
                            }
                          },
                          name: "Submit",
                          circularvalue: 30)
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CustomIndicator(),
            ),
    );
  }

  void postmail() async {
    setState(() {
      loading = true;
    });
    ApiService.sendforgeotpassword(emailcontroller.text).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'].toString(),
              "Ok",
              refresh,
              AssetsImageWidget.warningimage);
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'].toString(),
              "Ok",
              exitpopup,
              AssetsImageWidget.warningimage);
        }
        //return response;
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

  void exitpopup() {
    AppUtils.pop(context);
  }

  void refresh() {
    AppUtils.pop(context);
    AppUtils.pop(context);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
