import 'package:ditonton/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseMonitoring {
  const FirebaseMonitoring._();

  static FirebaseAnalytics? analytics;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      analytics = FirebaseAnalytics.instance;
      await analytics?.logAppOpen();

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (error, stack) {
      debugPrint('Firebase monitoring is disabled: $error');
      debugPrintStack(stackTrace: stack);
    }
  }

  static Future<void> logScreenView(String screenName) async {
    await analytics?.logScreenView(screenName: screenName);
  }
}
