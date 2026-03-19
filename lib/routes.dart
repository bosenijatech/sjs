import 'package:flutter/material.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/views/assetrequest/assetapply.dart';
import 'package:winstar/views/assetrequest/viewassets.dart';
import 'package:winstar/views/attendance/attendance_history.dart';
import 'package:winstar/views/attendance/view_attendance.dart';
import 'package:winstar/views/changepassword/changepassword.dart';
import 'package:winstar/views/dutytravel/dutytravelapply.dart';
import 'package:winstar/views/dutytravel/dutytraveldetail.dart';
import 'package:winstar/views/forgotpassword/forgotpassword.dart';
import 'package:winstar/views/grievances/applygrievance.dart';
import 'package:winstar/views/landingpage/teammets.dart';
import 'package:winstar/views/leave/applycompoffpage.dart';
import 'package:winstar/views/leave/homepage.dart';
import 'package:winstar/views/leave/leaveapplypage.dart';
import 'package:winstar/views/leave/viewcompoffdetails.dart';
import 'package:winstar/views/leave/viewleavedetails.dart';
import 'package:winstar/views/letterpage/letterapply.dart';
import 'package:winstar/views/letterpage/viewletterdetails.dart';
import 'package:winstar/views/login/loginpage.dart';
import 'package:winstar/views/payslip/viewpayslip.dart';
import 'package:winstar/views/profilepage/profilepage.dart';
import 'package:winstar/views/reimbursement/reimburesementapply.dart';
import 'package:winstar/views/reimbursement/reimbursementdetails.dart';
import 'package:winstar/views/rejoin/rejointab.dart';
import 'package:winstar/views/splash.dart/splash.dart';

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
