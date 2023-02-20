import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthManager {
  User? _user;

  final Map<UniqueKey, Function> _loginObservers = {};
  final Map<UniqueKey, Function> _logoutObservers = {};

  StreamSubscription? _authListener;

  static final AuthManager instance = AuthManager._privateConstructor();

  AuthManager._privateConstructor();

  String get email => _user?.email ?? "";
  String get uid => _user?.uid ?? "";
  bool get isSignedIn => _user != null;

  void starListening() {
    if (_authListener != null) {
      return;
    }

    _authListener =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      bool isLoginEvent = user != null && _user == null;
      bool isLogoutEvent = user == null && _user != null;
      _user = user;

      if (isLoginEvent) {
        for (Function observer in _loginObservers.values) {
          observer();
        }
      }
      if (isLogoutEvent) {
        for (Function observer in _logoutObservers.values) {
          observer();
        }
      }

      if (user == null) {
        print("User is currently signed out!");
      } else {
        print("User is signed in!");
      }
    });
  }

  void stopListening() {
    _authListener?.cancel();
    _authListener = null;
  }

  UniqueKey addLoginObserver(Function observer) {
    starListening();
    UniqueKey key = UniqueKey();
    _loginObservers[key] = observer;
    return key;
  }

  UniqueKey addLogoutObserver(Function observer) {
    starListening();
    UniqueKey key = UniqueKey();
    _logoutObservers[key] = observer;
    return key;
  }

  void removeObserver(UniqueKey key) {
    _loginObservers.remove(key);
    _logoutObservers.remove(key);
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //  ---  specific auth methods  ---

  void createNewUserEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("AuthManager: Created a user ${credential.user?.email}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showAuthSnackbar(
            authErrorMessage: 'The password provided is too weak.',
            context: context);
      } else if (e.code == 'email-already-in-use') {
        _showAuthSnackbar(
            authErrorMessage: 'The account already exists for that email.',
            context: context);
      }
    } catch (e) {
      _showAuthSnackbar(authErrorMessage: e.toString(), context: context);
    }
  }

  void _showAuthSnackbar(
      {required String authErrorMessage, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authErrorMessage),
      ),
    );
  }

  void loginExistingUserEmailPassword(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("AuthManager: Logged in existing User ${credential.user?.email}");
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        // print('No user found for that email.');
        _showAuthSnackbar(
            context: context,
            authErrorMessage: "No user found for that email.");
      } else if (e.code == "wrong-password") {
        // print('Wrong password provided for that user.');
        _showAuthSnackbar(
            context: context,
            authErrorMessage: "Wrong password provided for that user.");
      }
    } catch (e) {
      _showAuthSnackbar(context: context, authErrorMessage: e.toString());
    }
  }
}
