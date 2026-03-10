// core/config/app_session.dart
import 'package:flutter/material.dart';

class AppSession extends ChangeNotifier {
  // We start as 'initializing'
  bool _isReady = false;
  bool get isReady => _isReady;

  void setReady() {
    _isReady = true;
    notifyListeners();
  }
}

// Global instance to be used by Router and Splash
final appSession = AppSession();
