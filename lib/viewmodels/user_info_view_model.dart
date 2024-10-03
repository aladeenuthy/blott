import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserInfoViewModel extends ChangeNotifier {
    bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool _buttonEnabled = false;
  bool get buttonEnabled => _buttonEnabled;
  set buttonEnabled(bool value) {
    _buttonEnabled = value;
    notifyListeners();
  }
  void onchange(String firstName, String lastName) {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      buttonEnabled = true;
    } else {
      buttonEnabled = false;
    }
  }


  Future<void> saveUserInfo(String firstName, String lastName) async {
    isLoading = true;
    // mock api call
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userData", jsonEncode({
      "firstName": firstName,
      "lastName": lastName
    }));
    isLoading = false;
  }

  Future<User?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("userData");
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }
  
}