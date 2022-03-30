// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCUGfxH9yGxo0zDWaW3yZudU2XRNwemVYI',
    appId: '1:1025166525753:web:14d817d277994919d154e8',
    messagingSenderId: '1025166525753',
    projectId: 'chatapp-3e4f3',
    authDomain: 'chatapp-3e4f3.firebaseapp.com',
    storageBucket: 'chatapp-3e4f3.appspot.com',
    measurementId: 'G-LTS0SQE41L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwIBV6W-te-UlZN9Glo1LTfYy9otrB0XM',
    appId: '1:1025166525753:android:932e267ce12a2fc9d154e8',
    messagingSenderId: '1025166525753',
    projectId: 'chatapp-3e4f3',
    storageBucket: 'chatapp-3e4f3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-p4fvzEIcpB7UHibOCsP2uXwOXdmq7x8',
    appId: '1:1025166525753:ios:9e90d14c0af956a2d154e8',
    messagingSenderId: '1025166525753',
    projectId: 'chatapp-3e4f3',
    storageBucket: 'chatapp-3e4f3.appspot.com',
    androidClientId: '1025166525753-fprv9k4j25g9dt1h6lu66p1i3onvdfut.apps.googleusercontent.com',
    iosClientId: '1025166525753-ds9vtdu8dr70k9jldp56mbhrr0gr1rsa.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );
}
