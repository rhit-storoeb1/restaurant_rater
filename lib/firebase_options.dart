// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCMsIoJZBMXoV5Q5TbK4_F4uImsufAGF8c',
    appId: '1:134188092891:web:2d769b71f6292f6fefebfe',
    messagingSenderId: '134188092891',
    projectId: 'roserestaurantrater',
    authDomain: 'roserestaurantrater.firebaseapp.com',
    storageBucket: 'roserestaurantrater.appspot.com',
    measurementId: 'G-NTSVG5T8NN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2Fn7-I_BUG6krgT8gNpXMrM-7laq1cGk',
    appId: '1:134188092891:android:b7d547089dac7264efebfe',
    messagingSenderId: '134188092891',
    projectId: 'roserestaurantrater',
    storageBucket: 'roserestaurantrater.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_MvC5r_-YeU7b4VcFXoYJ8__-jSqgPE0',
    appId: '1:134188092891:ios:b1c9dfb9f2f586eeefebfe',
    messagingSenderId: '134188092891',
    projectId: 'roserestaurantrater',
    storageBucket: 'roserestaurantrater.appspot.com',
    iosClientId: '134188092891-ktio0sfjk2v03pcd3u7tcldc38s0ch7b.apps.googleusercontent.com',
    iosBundleId: 'com.example.restaurantRater',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_MvC5r_-YeU7b4VcFXoYJ8__-jSqgPE0',
    appId: '1:134188092891:ios:b1c9dfb9f2f586eeefebfe',
    messagingSenderId: '134188092891',
    projectId: 'roserestaurantrater',
    storageBucket: 'roserestaurantrater.appspot.com',
    iosClientId: '134188092891-ktio0sfjk2v03pcd3u7tcldc38s0ch7b.apps.googleusercontent.com',
    iosBundleId: 'com.example.restaurantRater',
  );
}