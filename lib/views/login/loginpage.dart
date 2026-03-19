import 'dart:convert';

import 'package:sjs/models/loginmodel.dart';
import 'package:sjs/routenames.dart';
import 'package:sjs/domain/ApiService.dart';
import 'package:sjs/services/pref.dart';
import 'package:sjs/utils/app_utils.dart';
import 'package:sjs/utils/appcolor.dart';
import 'package:sjs/utils/sharedprefconstants.dart';
import 'package:sjs/views/widgets/assets_image_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  LoginModel loginModel = LoginModel();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Appcolor.whiteShade1, Appcolor.whiteShade2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            width: size.width < 600 ? size.width * 0.9 : 420,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Appcolor.primarycolor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              backgroundBlendMode: BlendMode.overlay,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Appcolor.primarycolor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/nijatechlogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E),
                  ),
                ),
                Text(
                  "Sign in to your ESS account",
                  style: TextStyle(color: Colors.brown.shade400),
                ),
                const SizedBox(height: 35),

                // Username / Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email / Username",
                    prefixIcon: Icon(Icons.email_outlined,
                        color: Appcolor.primarycolor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon:
                        Icon(Icons.lock_outline, color: Appcolor.primarycolor),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.brown.shade400,
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.forgotpassword);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.brown.shade700),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_emailController.text.isEmpty) {
                              AppUtils.showSingleDialogPopup(
                                  context,
                                  "Enter username or email",
                                  "Ok",
                                  onexitpopup,
                                  null);
                            } else if (_passwordController.text.isEmpty) {
                              AppUtils.showSingleDialogPopup(context,
                                  "Enter password", "Ok", onexitpopup, null);
                            } else {
                              getlogin();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolor.primarycolor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 25),

                // Footer
                Text(
                  "© ${DateTime.now().year} Nija Ess. All rights reserved.",
                  style: TextStyle(
                      fontSize: 12, color: Colors.brown.shade300, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getlogin() async {
    setState(() {
      if (!mounted) return;
      _isLoading = true;
    });
    ApiService.getlogin(
            _emailController.text.trim(), _passwordController.text.trim())
        .then((response) {
      setState(() {
        if (!mounted) return;
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          loginModel = LoginModel.fromJson(jsonDecode(response.body));
          if (loginModel.data!.mobileaccess.toString() == "false") {
            AppUtils.showSingleDialogPopup(
                context,
                "You Are Not Authorised Mobile User. Please Contact Your Administrator!.",
                "Ok",
                onexitpopup,
                null);
          } else {
            addsharedpref(loginModel);
          }
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.errorimage);
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        if (!mounted) return;
        _isLoading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  Future addsharedpref(LoginModel model) async {
    await Prefs.setLoggedIn(SharefprefConstants.sharefloggedin, true);
    await Prefs.setFullName(
        SharefprefConstants.shareFullName,
        '${model.data!.firstName.toString()} '
        ' ${model.data!.middleName ?? ""} '
        ' ${model.data!.lastName.toString()}');
    await Prefs.setFirstName(
        SharefprefConstants.shareFirstName, model.data!.firstName.toString());
    await Prefs.setMiddleName(
        SharefprefConstants.shareMiddleName, model.data!.middleName.toString());

    await Prefs.setLastName(
        SharefprefConstants.sharedLastName, model.data!.lastName.toString());
    await Prefs.setTitle(
        SharefprefConstants.sharedLastName, model.data!.title.toString());

    await Prefs.setGender(
        SharefprefConstants.sharedgender, model.data!.gender.toString());

    await Prefs.setEmpID(
        SharefprefConstants.sharedempId, model.data!.employeeCode!.toString());
    await Prefs.setUniqId(
        SharefprefConstants.shareduniqId, model.data!.sId.toString());
    await Prefs.setUserName(SharefprefConstants.shareduserName,
        model.data!.mobileusername.toString());
    await Prefs.setToken(SharefprefConstants.sharedToken, "");
    await Prefs.setDesignation(SharefprefConstants.shareddesignation, "");
    await Prefs.setDept(
        SharefprefConstants.shareddept, model.data!.department.toString());

    await Prefs.setNsID(
        SharefprefConstants.sharednsid, model.data!.nsId!.toString());

    await Prefs.setLinemanager(SharefprefConstants.sharedLineManager,
        model.data!.linemanager!.toString());

    await Prefs.setSupervisor(SharefprefConstants.sharedsupervisor,
        model.data!.supervisor!.toString());

    await Prefs.sethod(
        SharefprefConstants.sharedhod, model.data!.hod!.toString());

    await Prefs.setShiftName(SharefprefConstants.sharedshiftName,
        "GENERAL SHIFT (08:00 AM - 05:30 PM)");
    await Prefs.setShiftFromTime(
        SharefprefConstants.sharedShiftFromTime, "08:00 AM");
    await Prefs.setShiftToTime(
        SharefprefConstants.sharedShiftToTime, "05:30 PM");

    await Prefs.setImageURL(
        (model.data!.imageurl.toString() == "null" ||
                model.data!.imageurl.toString().isEmpty)
            ? ""
            : SharefprefConstants.sharedImgUrl,
        model.data!.imageurl.toString());

    await Prefs.setMobileNo(
        SharefprefConstants.sharedMobNo, model.data!.mobileNo.toString());

    await Prefs.setWorkRegion(SharefprefConstants.sharedWorkregion,
        model.data!.workRegion.toString());

    await Prefs.setLinemanager(
        SharefprefConstants.sharedLineManager,
        model.data!.linemanager.toString() == "null"
            ? "-"
            : model.data!.linemanager.toString());

    await Prefs.setSupervisor(
        SharefprefConstants.sharedsupervisor,
        model.data!.supervisor.toString() == "null"
            ? "-"
            : model.data!.supervisor.toString());

    await Prefs.sethod(
        SharefprefConstants.sharedhod,
        model.data!.hod.toString() == "null"
            ? "-"
            : model.data!.hod.toString());

    await Prefs.setDeviceIdnetifier(SharefprefConstants.sharedDeviceID, "");
    await Prefs.setPayGroupID(SharefprefConstants.sharedpaygroupid,
        model.data!.paygroupId.toString());
    await Prefs.setPayGroupName(SharefprefConstants.sharedpaygroupname,
        model.data!.paygroupName.toString());

    await Prefs.setEmail(
        SharefprefConstants.sharedemailid, model.data!.mobileemail.toString());

    await Prefs.setImei(SharefprefConstants.sharedimei, "");

    await Prefs.setSubsidiaryId(
        SharefprefConstants.subsidiaryId, model.data!.subsidiaryId.toString());

    await Prefs.setSubsidiarName(
        SharefprefConstants.subsidiaryName, model.data!.subsidiary.toString());

    await Prefs.setnetsuiteConsumerKey(
        "netsuiteConsumerKey", model.secretkey![0].cONSUMERKEY.toString());
    await Prefs.setnetsuiteConsumerSecret("netsuiteConsumerSecret",
        model.secretkey![0].cONSUMERSECRET.toString());
    await Prefs.setnetsuiteToken(
        "netsuiteToken", model.secretkey![0].aCCESSTOKEN.toString());
    await Prefs.setnetsuiteTokenSecret(
        "netsuiteTokenSecret", model.secretkey![0].tOKENSECRET.toString());
    await Prefs.setRealm("netSuiteRealm", model.secretkey![0].rEALM.toString());

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.homepage, (Route<dynamic> route) => false);
    }
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }
}
