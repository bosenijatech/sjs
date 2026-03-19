
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/routes.dart';
import 'package:winstar/services/idletimeoutservice.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/views/widgets/custom_widgets.dart';
import 'package:winstar/views/widgets/network_status_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'offlinedata/synserviceget.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final IdleTimeoutService idleService = IdleTimeoutService();
final SyncService syncService = SyncService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Prefs.init();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(errorMessage: details.exceptionAsString());
  };

  // ✅ Online வந்தவுடனே auto sync
  syncService.startConnectivityListener();

  // ✅ Every 30 sec background sync
  syncService.startPeriodicSync(interval: const Duration(seconds: 30));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    syncService.stopAllTimers();
    syncService.stopConnectivityListener();
    super.dispose();
  }

  // ✅ App background → foreground வந்தாலும் sync trigger
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("📱 App resumed — triggering sync");
      syncService.syncAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<NetworkStatus>(
          create: (_) =>
              NetworkStatusService().networkStatusController.stream,
          initialData: NetworkStatus.online,
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: RouteNames.splashscreen,
        onGenerateRoute: Routes.generateRoutes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Appcolor.primarycolor,
          textTheme:
              GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          fontFamily: GoogleFonts.poppins().fontFamily,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            actionsIconTheme: IconThemeData(color: Colors.black),
            centerTitle: false,
            elevation: 2,
            backgroundColor: Colors.white,
          ),
          cardTheme: const CardThemeData(
            elevation: 1,
            color: Colors.white,
            surfaceTintColor: Colors.white,
          ),
        ),
      ),
    );
  }
}