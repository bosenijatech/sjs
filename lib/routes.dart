import 'package:flutter/material.dart';
import 'package:sjs/routenames.dart';
import 'package:sjs/views/assetrequest/assetapply.dart';
import 'package:sjs/views/assetrequest/viewassets.dart';
import 'package:sjs/views/attendance/attendance_history.dart';
import 'package:sjs/views/attendance/view_attendance.dart';
import 'package:sjs/views/changepassword/changepassword.dart';
import 'package:sjs/views/dutytravel/dutytravelapply.dart';
import 'package:sjs/views/dutytravel/dutytraveldetail.dart';
import 'package:sjs/views/forgotpassword/forgotpassword.dart';
import 'package:sjs/views/grievances/applygrievance.dart';
import 'package:sjs/views/landingpage/teammets.dart';
import 'package:sjs/views/leave/applycompoffpage.dart';
import 'package:sjs/views/leave/homepage.dart';
import 'package:sjs/views/leave/leaveapplypage.dart';
import 'package:sjs/views/leave/viewcompoffdetails.dart';
import 'package:sjs/views/leave/viewleavedetails.dart';
import 'package:sjs/views/letterpage/letterapply.dart';
import 'package:sjs/views/letterpage/viewletterdetails.dart';
import 'package:sjs/views/login/loginpage.dart';
import 'package:sjs/views/payslip/viewpayslip.dart';
import 'package:sjs/views/profilepage/profilepage.dart';
import 'package:sjs/views/reimbursement/reimburesementapply.dart';
import 'package:sjs/views/reimbursement/reimbursementdetails.dart';
import 'package:sjs/views/rejoin/rejointab.dart';
import 'package:sjs/views/splash.dart/splash.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case (RouteNames.splashscreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case (RouteNames.loginscreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      // case (RouteNames.landingpage):
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const LandingPage());

      case (RouteNames.attendancehistory):
        return MaterialPageRoute(
            builder: (BuildContext context) => const Attendancehistory());

      //LEAVE
      case (RouteNames.applyleave):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LeaveApplyPage());
      case (RouteNames.viewleave):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewLeavePage());

      //LEAVE
      case (RouteNames.applycompoffleave):
        return MaterialPageRoute(
            builder: (BuildContext context) => const CompOffApplyPage());
      case (RouteNames.viewcompoffleave):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewCompOffPage());

      //ASSET
      case (RouteNames.viewasset):
        return MaterialPageRoute(
            builder: (BuildContext context) => const AssetDetailPage());

      case (RouteNames.applyasset):
        return MaterialPageRoute(
            builder: (BuildContext context) => const AssetApplyPage());
      //LETTER REQUEST

      // case (RouteNames.rejoin):
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const DutyResumption());
      case (RouteNames.viewrejoin):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReJoinTab());
      //ASSET
      case (RouteNames.viewletter):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewLetterDetailsPage());
      case (RouteNames.addletter):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LetterApplyPage());
      //Duty Travel
      case (RouteNames.dutytravelview):
        return MaterialPageRoute(
            builder: (BuildContext context) => const DutyTravelDetailsPage());
      case (RouteNames.dutytravelapply):
        return MaterialPageRoute(
            builder: (BuildContext context) => const DutyTravelApplyPage());
      //REIM APPLY
      case (RouteNames.reimview):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReimbursementDetails());
      case (RouteNames.reimapply):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReimbursementApplyPage());

      //GRIEVANCE
      case (RouteNames.viewgrievance):
      case (RouteNames.addgrievance):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ApplyGrievancePage());

      case (RouteNames.changepassword):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ChangePassword());
      case (RouteNames.payslip):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewPaySlipPage());
      case (RouteNames.viewattendance):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewAttendance());

      case (RouteNames.viewprofile):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfilePage());

      case (RouteNames.homepage):
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());

      case (RouteNames.myteam):
        return MaterialPageRoute(
            builder: (BuildContext context) => const MyTeamScreen());
       case (RouteNames.forgotpassword):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgoPasswordPage());      
      default:
        _errorRoute();
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text("No route is configured"),
        ),
      ),
    );
  }
}
