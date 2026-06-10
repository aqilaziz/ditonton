import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDDitontonDemoAnalyticsKey',
    appId: '1:123456789012:web:0123456789abcdef012345',
    messagingSenderId: '123456789012',
    projectId: 'ditonton-dicoding-demo',
    authDomain: 'ditonton-dicoding-demo.firebaseapp.com',
    storageBucket: 'ditonton-dicoding-demo.appspot.com',
    measurementId: 'G-DITONTON01',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDitontonDemoAnalyticsKey',
    appId: '1:123456789012:android:0123456789abcdef012345',
    messagingSenderId: '123456789012',
    projectId: 'ditonton-dicoding-demo',
    storageBucket: 'ditonton-dicoding-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDitontonDemoAnalyticsKey',
    appId: '1:123456789012:ios:0123456789abcdef012345',
    messagingSenderId: '123456789012',
    projectId: 'ditonton-dicoding-demo',
    storageBucket: 'ditonton-dicoding-demo.appspot.com',
    iosBundleId: 'com.dicoding.ditonton',
  );
}
