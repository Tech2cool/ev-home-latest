import 'dart:async';
import 'package:ev_homes/core/providers/geolocation_provider.dart';
import 'package:ev_homes/core/providers/setting_provider.dart';
import 'package:ev_homes/core/routes/app_router.dart';
import 'package:ev_homes/core/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kReleaseMode) {
      // _sendErrorToBackend(details.exceptionAsString(), details.stack);
      // Helper.showCustomSnackBar(details.exceptionAsString());
    } else {
      FlutterError.presentError(details);
    }
  };
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    OneSignal.initialize("d4ba7e76-e911-4cbd-a99a-592df2da7984");
    await ApiService().initServer();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => SettingProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => GeolocationProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  }, (error, stackTrace) {
    // _sendErrorToBackend(error.toString(), stackTrace);
    // Helper.showCustomSnackBar(error.toString());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EV Home Main',
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      routerConfig: AppRoutes.router,
    );
  }
}
