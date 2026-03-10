import 'package:buraq_enterprise_admin/core/config/app_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RouterRefreshStream extends ChangeNotifier {
  RouterRefreshStream() {
    notifyListeners(); 

    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    });

    appSession.addListener(() {
      notifyListeners();
    });
  }
}
