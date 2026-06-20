import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:social_stream/src/helpers/image_helper.dart';
import 'package:social_stream/src/models/user_model.dart';
import 'package:social_stream/src/provider/user_detail_provider.dart';
import 'dart:async';

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

      final http.MultipartRequest request =
      http.MultipartRequest(
        'POST',
        Uri.parse(registrationUrl),
      );

      request.fields.addAll(
        <String, String>{
          'UserName': userName.trim(),
          'Email': email.trim(),
          'Password': password.trim(),
          'FullName': (fullName ?? '').trim(),
          'PhoneNumber': (phoneNumber ?? '').trim(),
          'Bio': (bio ?? '').trim(),
        },
      );

      // =========================================================
      // PROFILE IMAGE
      // =========================================================

      if (profileImage != null &&
          await profileImage.exists()) {
        final String filePath = profileImage.path;

        final String resolvedMimeType =
            lookupMimeType(filePath) ??
                ImageHelper.getImageMimeType(
                  filePath,
                );

        final List<String> mimeParts =
        resolvedMimeType.split('/');

        final MediaType mediaType = MediaType(
          mimeParts.first,
          mimeParts.length > 1
              ? mimeParts[1]
              : 'jpeg',
        );

        final String fileName =
        profileImage.uri.pathSegments.isNotEmpty
            ? profileImage
            .uri
            .pathSegments
            .last
            : 'profile_image.jpg';

        final http.MultipartFile imageFile =
        await http.MultipartFile.fromPath(
          'profileImage',
          filePath,
          filename: fileName,
          contentType: mediaType,
        );

        request.files.add(imageFile);

        debugPrint(
          'Profile Image Path: $filePath',
        );

        debugPrint(
          'Profile Image File Name: $fileName',
        );

        debugPrint(
          'Profile Image MIME Type: '
              '$resolvedMimeType',
        );

        debugPrint(
          'Profile Image Size: '
              '${await profileImage.length()} bytes',
        );
      }

      request.headers.addAll(
        <String, String>{
          'Accept': 'application/json',
        },
      );

      debugPrint(
        '================================',
      );

      debugPrint(
        'REGISTRATION API URL: '
            '${request.url}',
      );

      debugPrint(
        'FIELDS: ${request.fields}',
      );

      debugPrint(
        'FILES COUNT: '
            '${request.files.length}',
      );

      debugPrint(
        '================================',
      );

      final http.StreamedResponse streamedResponse =
      await request.send().timeout(
        const Duration(seconds: 60),
      );

      final http.Response response =
      await http.Response.fromStream(
        streamedResponse,
      );

      debugPrint(
        'STATUS CODE: '
            '${response.statusCode}',
      );

      debugPrint(
        'RESPONSE BODY: '
            '${response.body}',
      );

      if (response.body.trim().isEmpty) {
        return <String, dynamic>{
          'success': false,
          'message':
          'Empty response from server.',
        };
      }

      Map<String, dynamic> responseData;

      try {
        final dynamic decodedData =
        jsonDecode(response.body);

        if (decodedData
        is Map<String, dynamic>) {
          responseData = decodedData;
        } else if (decodedData is Map) {
          responseData =
          Map<String, dynamic>.from(
            decodedData,
          );
        } else {
          return <String, dynamic>{
            'success': false,
            'message':
            'Invalid response from server.',
          };
        }
      } on FormatException {
        return <String, dynamic>{
          'success': false,
          'message': response.body,
        };
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return <String, dynamic>{
          'success': true,
          'message':
          responseData['message']
              ?.toString() ??
              'Registration successful.',
          'data': responseData,
        };
      }

      return <String, dynamic>{
        'success': false,
        'message':
        responseData['message']
            ?.toString() ??
            'Registration failed.',
        'data': responseData,
      };
    } on SocketException {
      return <String, dynamic>{
        'success': false,
        'message':
        'No internet connection. '
            'Please check your network.',
      };
    } on TimeoutException {
      return <String, dynamic>{
        'success': false,
        'message':
        'Request timed out. '
            'Please try again.',
      };
    } on FormatException {
      return <String, dynamic>{
        'success': false,
        'message':
        'Invalid response received '
            'from server.',
      };
    } catch (error, stackTrace) {
      debugPrint(
        'Registration Error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return <String, dynamic>{
        'success': false,
        'message': error.toString(),
      };
    } finally {
      _setLoading(false);
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