import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/login/loginpage.dart';
import 'package:winstar/views/widgets/custom_scaffold.dart';
import 'package:winstar/views/widgets/menuwidget.dart';
import 'package:winstar/views/widgets/notificationtitle.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // List<UserNotification> listNotification =
  //     NotificationService.listNotification;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(child: settingsList(context));
  }

  Widget settingsList(context) {
    return SettingsList(
      sections: [
        // SettingsSection(
        //   title: const Text('Common'),
        //   tiles: <SettingsTile>[
        //     SettingsTile.navigation(
        //       leading: const Icon(Icons.language),
        //       title: const Text('Language'),
        //       value: const Text('English'),
        //     ),
        //     SettingsTile.switchTile(
        //       activeSwitchColor: Appcolor.primarycolor,
        //       onToggle: (value) {},
        //       initialValue: true,
        //       leading: const Icon(
        //         Icons.notifications,
        //       ),
        //       title: const Text('Notification'),
        //     ),
        //   ],
        // ),
        SettingsSection(
          title: const Text('Security'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              onPressed: (context) =>
                  {Navigator.pushNamed(context, RouteNames.changepassword)},
              leading: const Icon(Icons.password),
              title: const Text('Change Password'),
              value: const Text('change your password'),
            ),
            SettingsTile.navigation(
              onPressed: (context) => {
                AppUtils.showconfirmDialog(
                    context, "Are you  sure want to logout?", "Yes", "No", () {
                  Prefs.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false);
                }, () {
                  AppUtils.pop(context);
                })
              },
              leading: SvgPicture.asset(
                'assets/icons/logout.svg',
                color: Colors.red,
              ),
              title: const Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }

  Widget settingsPage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                        color: Appcolor.black.withOpacity(0.5),
                        letterSpacing: 6 / 100,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                MenuTileWidget(
                  onTap: () {},
                  margin: const EdgeInsets.only(top: 10),
                  icon: SvgPicture.asset(
                    'assets/icons/Filter.svg',
                    color: Appcolor.black.withOpacity(0.5),
                  ),
                  title: 'Languages',
                  subtitle: 'Change Your Prefer Language',
                ),
                MenuTileWidget(
                  onTap: () {
                    Prefs.clear();
                    Prefs.remove("remove");
                    Prefs.setLoggedIn(
                        SharefprefConstants.sharefloggedin, false);
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.loginscreen,
                        (Route<dynamic> route) => false);
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/logout.svg',
                    color: Colors.red,
                  ),
                  iconBackground: Colors.red.shade100,
                  title: 'Log Out',
                  titleColor: Colors.red,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget notificationdetails() {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  'NOTIFICATION DETAILS',
                  style: TextStyle(
                      color: Appcolor.black.withOpacity(0.5),
                      letterSpacing: 6 / 100,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return NotificationTile(
                    data: "Notification",
                    onTap: () {},
                  );
                },
                itemCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
