import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserDetailProvider extends ChangeNotifier {

  // =========================
  // USER MODEL
  // =========================

  UserModel? _user;

  UserModel? get user => _user;

  // =========================
  // SET USER DATA
  // =========================

  Future<void> setUser(
      UserModel userModel) async {

    _user = userModel;

    SharedPreferences preferences =
    await SharedPreferences.getInstance();

    preferences.setString(
      "userData",
      jsonEncode(userModel.toJson()),
    );

    notifyListeners();
  }

  // =========================
  // GET USER DATA
  // =========================

  Future<void> getUser() async {

    SharedPreferences preferences =
    await SharedPreferences.getInstance();

    String? userData =
    preferences.getString("userData");

    if (userData != null) {

      _user = UserModel.fromJson(
        jsonDecode(userData),
      );

      notifyListeners();
    }
  }

  // =========================
  // REMOVE USER DATA
  // =========================

  Future<void> clearUser() async {

    SharedPreferences preferences =
    await SharedPreferences.getInstance();

    await preferences.remove("userData");

    _user = null;

    notifyListeners();
  }

  // =========================
  // CHECK LOGIN
  // =========================

  bool isLoggedIn() {
    return _user != null;
  }
}