import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:social_stream/src/models/user_model.dart';
import 'package:social_stream/src/provider/user_detail_provider.dart';

class UserAuthentication extends ChangeNotifier {

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {

    _isLoading = value;

    notifyListeners();
  }

  // =====================================================
  // API URLS
  // =====================================================

  static const String registrationUrl =
      "http://10.20.1.205:5033/api/Registration/registration";

  static const String loginUrl =
      "http://10.20.1.205:5033/api/Registration/login";

  // =====================================================
  // REGISTER USER
  // =====================================================

  Future<Map<String, dynamic>> registerUser({

    required String userName,

    required String email,

    required String password,

    String? fullName,

    String? phoneNumber,

    String? bio,

    File? profileImage,

  }) async {

    try {

      _setLoading(true);

      // =====================================
      // MULTIPART REQUEST
      // =====================================

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(registrationUrl),
      );

      // =====================================
      // TEXT FIELDS
      // =====================================

      request.fields['UserName'] =
          userName.trim();

      request.fields['Email'] =
          email.trim();

      request.fields['Password'] =
          password.trim();

      request.fields['FullName'] =
          (fullName ?? '').trim();

      request.fields['PhoneNumber'] =
          (phoneNumber ?? '').trim();

      request.fields['Bio'] =
          (bio ?? '').trim();

      // =====================================
      // PROFILE IMAGE
      // =====================================

      if (profileImage != null) {

        request.files.add(

          await http.MultipartFile.fromPath(

            'profileImage',

            profileImage.path,
          ),
        );
      }

      // =====================================
      // HEADERS
      // =====================================

      request.headers.addAll({

        "Accept": "application/json",
      });

      print("================================");

      print("REGISTRATION API URL: ${request.url}");

      print("FIELDS: ${request.fields}");

      print("================================");

      // =====================================
      // API CALL
      // =====================================

      final streamedResponse =
      await request.send();

      final response =
      await http.Response.fromStream(
          streamedResponse);

      _setLoading(false);

      print("STATUS CODE: ${response.statusCode}");

      print("RESPONSE BODY: ${response.body}");

      // =====================================
      // EMPTY RESPONSE
      // =====================================

      if (response.body.isEmpty) {

        return {

          "success": false,

          "message":
          "Empty response from server",
        };
      }

      dynamic responseData;

      // =====================================
      // JSON DECODE
      // =====================================

      try {

        responseData =
            jsonDecode(response.body);

      } catch (e) {

        return {

          "success": false,

          "message": response.body,
        };
      }

      // =====================================
      // SUCCESS
      // =====================================

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        return {

          "success": true,

          "data": responseData,
        };
      }

      // =====================================
      // FAILED
      // =====================================

      return {

        "success": false,

        "message":
        responseData["message"] ??
            "Registration Failed",
      };

    } catch (e) {

      _setLoading(false);

      return {

        "success": false,

        "message": e.toString(),
      };
    }
  }

  // =====================================================
  // LOGIN USER
  // =====================================================

  Future<Map<String, dynamic>> loginUser({

    required BuildContext context,

    required String email,

    required String password,

  }) async {

    try {

      _setLoading(true);

      final response = await http.post(

        Uri.parse(loginUrl),

        headers: {

          "Content-Type": "application/json",

          "Accept": "application/json",
        },

        body: jsonEncode({

          "email": email.trim(),

          "password": password.trim(),
        }),
      );

      _setLoading(false);

      print("================================");

      print("LOGIN API URL: $loginUrl");

      print("STATUS CODE: ${response.statusCode}");

      print("RESPONSE BODY: ${response.body}");

      print("================================");

      if (response.body.isEmpty) {

        return {

          "success": false,

          "message":
          "Empty response from server",
        };
      }

      dynamic responseData;

      try {

        responseData =
            jsonDecode(response.body);

      } catch (e) {

        return {

          "success": false,

          "message": "Invalid JSON Response",
        };
      }

      // =====================================
      // SUCCESS
      // =====================================

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        // ===============================
        // USER DATA
        // ===============================

        final userJson =
        responseData["user"];

        // ADD TOKEN
        userJson["token"] =
        responseData["token"];

        // ===============================
        // USER MODEL
        // ===============================

        UserModel userModel =
        UserModel.fromJson(userJson);

        // ===============================
        // SAVE USER LOCALLY
        // ===============================

        await Provider.of<UserDetailProvider>(
          context,
          listen: false,
        ).setUser(userModel);

        return {

          "success": true,

          "data": responseData,
        };
      }

      return {

        "success": false,

        "message":
        responseData["message"] ??
            "Login Failed",
      };

    } catch (e) {

      _setLoading(false);

      return {

        "success": false,

        "message": e.toString(),
      };
    }
  }
}