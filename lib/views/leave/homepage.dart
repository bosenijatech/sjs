import 'dart:convert';
import 'package:winstar/models/holidaymastermodel.dart';
import 'package:winstar/models/loginmodel.dart';
import 'package:winstar/services/userstatusservice.dart';
import 'package:winstar/views/payslip/viewallfiles.dart';
import 'package:winstar/views/widgets/wishthempage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:winstar/models/announcementmodel.dart';
import 'package:winstar/models/error_model.dart';
import 'package:winstar/models/pendingmodel.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/domain/ApiService.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AnnouncementData> announcementList = [];

  bool loading = false;
  int leaveCount = 0;
  int letterCount = 0;
  int totalCount = 0;
  ErrorModelNetSuite errorModelNetSuite = ErrorModelNetSuite();
  List<HolidayModel> holidayList = [];

  PendingModel model = PendingModel();
  List<Map<String, String>> wishData = [];
  List<Map<String, String>> leaveData = [];
  List<Map<String, String>> allWishData = [];
  final months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  @override
  void initState() {
    UserStatusService().startChecking(context);
    getAllEvents();
    super.initState();
  }

  @override
  void dispose() {
    UserStatusService().stopChecking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),
      body: !loading
          ? SafeArea(
              child: RefreshIndicator(
                onRefresh: () async => getAllEvents(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerSection(),
                        const SizedBox(height: 10),
                        //otherServicesSection(),
                        gridViewItems(),
                        const SizedBox(height: 10),
                        if (announcementList.isNotEmpty) announcementSection(),
                        const SizedBox(height: 10),
                        wishlistwidgets(),
                        const SizedBox(height: 10),
                        leavewidgets(),
                        const SizedBox(height: 10),
                        upcomingHolidays(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget headerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Profile avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      Prefs.getGender(SharefprefConstants.sharedgender)
                                  .toString() ==
                              "Male"
                          ? const AssetImage('assets/icons/male.jpeg')
                          : const AssetImage('assets/icons/female.jpeg'),
                ),
              ),
              const SizedBox(width: 12),
              // Greeting text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello ${Prefs.getFullName(SharefprefConstants.shareFullName) ?? "User"}!',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Notification icon
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget announcementSection() {
    return Card(
      elevation: 3,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.campaign_rounded,
                      color: Colors.purple, size: 22),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Announcements',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 3,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 List
            if (announcementList.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
              )
            else
              ListView.separated(
                separatorBuilder: (_, __) => Divider(
                  color: Colors.grey.shade300,
                  height: 20,
                ),
                itemCount: announcementList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final ann = announcementList[index];
                  return InkWell(
                    onTap: () async {
                      if (ann.attachmentURL.isNotEmpty) {
                        final mime =
                            await AppConstants.getMimeType(ann.attachmentURL);
                        final ext = AppConstants.getExtensionFromMime(mime);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewFiles(
                              fileUrl: ann.attachmentURL,
                              fileName: 'file.$ext',
                              mimeType: mime,
                            ),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.purple.shade100,
                            child: Text(
                              ann.message.isNotEmpty
                                  ? ann.message[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ann.message,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (ann.attachmentURL.isNotEmpty)
                                  const Row(
                                    children: [
                                      Icon(Icons.attach_file,
                                          color: Colors.purple, size: 18),
                                      SizedBox(width: 4),
                                      Text(
                                        "View Attachment",
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ann.attachmentURL.isNotEmpty
                              ? const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.grey,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // 🌿 Modern Holiday Section
  Widget upcomingHolidays() {
    if (holidayList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
            child: Text('No upcoming holidays 🎉',
                style: TextStyle(color: Colors.grey, fontSize: 15))),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Holiday List',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Container(height: 4, width: 40, color: Colors.blueAccent),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: holidayList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final holiday = holidayList[index];
                return Container(
                  width: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants
                            .colorArray[index % AppConstants.colorArray.length],
                        AppConstants
                            .colorArray[index % AppConstants.colorArray.length]
                            .withOpacity(0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(holiday.name ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Text(holiday.holidayDate ?? '',
                            style: const TextStyle(color: Colors.white)),
                        Text(holiday.holidayDay ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget wishlistwidgets() {
    return wishData.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 5),
            child: Card(
                elevation: 2,
                child: WishThemWidget(
                    type: "UpComing Birthday", wishList: wishData)))
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }

  Widget leavewidgets() {
    return leaveData.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 5),
            child: Card(
              elevation: 2,
              child: WishThemWidget(
                wishList: leaveData,
                type: "Off this Week",
              ),
            ),
          )
        : const SizedBox(
            width: 0,
            height: 0,
          );
  }

  void logout() async {
    Prefs.clear(); // Clears all stored preferences
    Prefs.remove("remove"); // Redundant if clear() already wipes everything
    Prefs.setLoggedIn(
        SharefprefConstants.sharefloggedin, false); // Explicit logout flag

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.loginscreen,
      (Route<dynamic> route) => false,
    );
  }

  void getAllEvents() async {
    if (!mounted) return;

    setState(() => loading = true);

    await Future.wait<void>([
      syncCredentialsFromBackend(),
      fetchHolidayData(),
      getleavelist(),
      getannouncement(),
      getBirthdayList(),
    ]);
    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> syncCredentialsFromBackend() async {
    final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}api/mobileapp/getcredentials'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body['status'].toString() == "true") {
        final loginModel = LoginModel.fromJson(body);

        if (loginModel.secretkey != null && loginModel.secretkey!.isNotEmpty) {
          await updateSharedPrefIfDifferent(loginModel);
        }
      }
    }
  }

  Future<void> updateSharedPrefIfDifferent(LoginModel loginModel) async {
    final newKey = loginModel.secretkey![0];

    // Read existing values
    final currentConsumerKey =
        Prefs.getnetsuiteConsumerKey("netsuiteConsumerKey");
    final currentConsumerSecret =
        Prefs.getnetsuiteConsumerSecret("netsuiteConsumerSecret");
    final currentToken = Prefs.getnetsuiteToken("netsuiteToken");
    final currentTokenSecret =
        Prefs.getnetsuiteTokenSecret("netsuiteTokenSecret");
    final currentRealm = Prefs.getRealm("netSuiteRealm");

    // Update only if different
    if (currentConsumerKey != newKey.cONSUMERKEY) {
      await Prefs.setnetsuiteConsumerKey(
          "netsuiteConsumerKey", newKey.cONSUMERKEY.toString());
    }

    if (currentConsumerSecret != newKey.cONSUMERSECRET) {
      await Prefs.setnetsuiteConsumerSecret(
          "netsuiteConsumerSecret", newKey.cONSUMERSECRET.toString());
    }

    if (currentToken != newKey.aCCESSTOKEN) {
      await Prefs.setnetsuiteToken(
          "netsuiteToken", newKey.aCCESSTOKEN.toString());
    }

    if (currentTokenSecret != newKey.tOKENSECRET) {
      await Prefs.setnetsuiteTokenSecret(
          "netsuiteTokenSecret", newKey.tOKENSECRET.toString());
    }

    if (currentRealm != newKey.rEALM) {
      await Prefs.setRealm("netSuiteRealm", newKey.rEALM.toString());
    }

    print("SharedPreferences updated if any key changed");
  }

  Future<void> getannouncement() async {
    try {
      final response = await ApiService.viewannouncement();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List rootData = decoded['data'];

        // Extract inner "data" arrays and flatten
        announcementList = rootData.expand((announcement) {
          final List dataList = announcement['data'] ?? [];
          return dataList.map((e) => AnnouncementData.fromJson(e));
        }).toList();

        print(jsonEncode(announcementList));
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    } catch (e) {
      if (!mounted) return;
      // AppUtils.showSingleDialogPopup(
      //   context,
      //   e.toString(),
      //   "Ok",
      //   onexitpopup,
      //   AssetsImageWidget.errorimage,
      // );
    }
  }

  Future<void> fetchHolidayData() async {
    try {
      setState(() => loading = true);

      final List<HolidayModel> holidays = await ApiService.getHolidayMaster(
          regionFilter:
              Prefs.getWorkRegion(SharefprefConstants.sharedWorkregion) ?? "");

      setState(() {
        holidayList.clear();
        holidayList.addAll(holidays);
        loading = false;
      });
    } catch (e) {
      print("Error fetching holidays: $e");
      setState(() => loading = false);
    }
  }

  Future<void> getleavelist() async {
    try {
      final response = await ApiService.getPendingleaves();
      if (!mounted) return;
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true) {
          final leaveResponse = decoded['data'];
          if (leaveResponse is List) {
            leaveData = leaveResponse.map<Map<String, String>>((emp) {
              final fullName = emp['toEmpName']?.toString() ?? '';
              final initials = fullName.trim().isNotEmpty
                  ? fullName
                      .trim()
                      .split(" ")
                      .where((e) => e.isNotEmpty)
                      .map((e) => e.characters.first)
                      .take(2)
                      .join()
                  : "??";

              return {
                "name": fullName,
                "date": emp['leaveDate']?.toString() ?? '',
                "type": "LEAVE",
                "initials": initials,
                "photo": ""
              };
            }).toList();

            if (!mounted) return;
            setState(() {
              allWishData = [...wishData, ...leaveData];
            });
          } else {
            if (!mounted) return;
            setState(() {
              leaveData = [];
            });
          }
          print("Leave List: $leaveData");
        } else {
          if (!mounted) return;
          setState(() {
            leaveData = [];
          });
        }
      } else {
        //throw Exception(jsonDecode(response.body)['message'].toString());
      }
    } catch (e) {
      if (!mounted) return;
      // AppUtils.showSingleDialogPopup(
      //   context,
      //   e.toString(),
      //   "Ok",
      //   onexitpopup,
      //   AssetsImageWidget.errorimage,
      // );
    }
  }

  Future<void> getBirthdayList() async {
    try {
      final response = await ApiService.getBirthdayList();
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final data = decoded['message'];
        if (decoded['status'].toString() == "true" && data is List) {
          final List<dynamic> rawList = data;

          final List<Map<String, dynamic>> mapped = rawList.map((emp) {
            final firstName = emp['firstName'] ?? '';
            final lastName = emp['lastName'] ?? '';
            final fullName = "$firstName $lastName".trim();

            final dob = emp['dateOfBirth'] ?? ''; // "19/09/2000"
            String formattedDate = '';
            if (dob.contains("/")) {
              final parts = dob.split("/");
              if (parts.length >= 2) {
                final day = parts[0];
                final month = parts[1];
                formattedDate = "$day ${months[int.parse(month) - 1]}";
              }
            }

            return {
              "name": fullName,
              "date": formattedDate,
              "type": "B'DAY",
              "initials": fullName.isNotEmpty
                  ? fullName
                      .split(" ")
                      .map((e) => e.isNotEmpty ? e[0] : "")
                      .take(2)
                      .join()
                  : "??",
              "photo": "",
            };
          }).toList();

          if (!mounted) return;
          setState(() {
            wishData = mapped.cast<Map<String, String>>();
            allWishData = [...wishData, ...leaveData];
          });
        } else {
          if (!mounted) return;
          setState(() {
            wishData = [];
          });
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    } catch (e) {
      if (!mounted) return;
      // AppUtils.showSingleDialogPopup(
      //   context,
      //   e.toString(),
      //   "Ok",
      //   onexitpopup,
      //   AssetsImageWidget.errorimage,
      // );
    }
  }

  Widget gridViewItems() {
    final categories = AppConstants.categories;
    return GridView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.90,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        return CategoryCard(
          index: index,
          icon: categories[index]["icon"],
          text: categories[index]["text"],
          press: () {
            if (index == 0) {
              Navigator.pushNamed(context, RouteNames.attendancehistory)
                  .then((_) => getAllEvents());
            }
            if (index == 1) {
              Navigator.pushNamed(context, RouteNames.viewattendance)
                  .then((_) => getAllEvents());
            }
            if (index == 2) {
              Navigator.pushNamed(context, RouteNames.viewleave)
                  .then((_) => getAllEvents());
            }
            if (index == 3) {
              Navigator.pushNamed(context, RouteNames.viewcompoffleave)
                  .then((_) => getAllEvents());
            }
            if (index == 4) {
              Navigator.pushNamed(context, RouteNames.viewletter)
                  .then((_) => getAllEvents());
            }
            if (index == 5) {
              Navigator.pushNamed(context, RouteNames.payslip)
                  .then((_) => getAllEvents());
            }
            if (index == 6) {
              Navigator.pushNamed(context, RouteNames.viewasset)
                  .then((_) => getAllEvents());
            }
            if (index == 7) {
              Navigator.pushNamed(context, RouteNames.viewrejoin)
                  .then((_) => getAllEvents());
            }
            if (index == 8) {
              Navigator.pushNamed(context, RouteNames.viewprofile)
                  .then((_) => getAllEvents());
            }
          },
        );
      },
    );
  }

  void onexitpopup() {
    AppUtils.pop(context);
  }

  String formatDate(DateTime date) => DateFormat('d MMMM y').format(date);
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.index,
    required this.icon,
    required this.text,
    required this.press,
  });

  final int index;
  final IconData icon;
  final String text;
  final GestureTapCallback press;

  Color _getBgColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF2563EB); // Attendance - Blue
      case 1:
        return const Color(0xFF16A34A); // Leave - Green
      case 2:
        return const Color(0xFF7C3AED); // Letter - Purple
      case 3:
        return const Color(0xFFEA580C); // Payslip - Orange
      case 4:
        return const Color(0xFFDC2626); // Asset - Red
      case 5:
        return const Color(0xFF0F766E); // Rejoin - Teal
      default:
        return const Color(0xFF334155);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _getBgColor(index);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: press,
        borderRadius: BorderRadius.circular(18),
        splashColor: bg.withOpacity(0.12),
        highlightColor: bg.withOpacity(0.06),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: bg,
                  boxShadow: [
                    BoxShadow(
                      color: bg.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: Colors.white, // ✅ All icons white
                ),
              ),
              const SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
