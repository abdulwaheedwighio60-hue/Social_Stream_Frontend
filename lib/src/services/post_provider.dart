import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart'
as http;

import '../models/post_model.dart';

class PostProvider
    extends ChangeNotifier {

  // =====================================
  // BASE URL
  // =====================================

  static const String _baseUrl =
      "http://10.20.1.205:5033";

  // =====================================
  // LOADING
  // =====================================

  bool _isLoading = false;

  bool get isLoading =>
      _isLoading;

  // =====================================
  // MESSAGE
  // =====================================

  String? _errorMessage;

  String? get errorMessage =>
      _errorMessage;

  String? _successMessage;

  String? get successMessage =>
      _successMessage;

  // =====================================
  // POSTS LIST
  // =====================================

  List<PostModel> _posts = [];

  List<PostModel> get posts =>
      _posts;

  // =====================================
  // UPLOAD POST
  // =====================================

  Future<bool> uploadPost({

    required String token,

    required String caption,

    required String addLocation,

    required List<File> images,

    required List<int> tagPeople,

  }) async {

    try {

      _setLoading(true);

      final Uri url = Uri.parse(
        "$_baseUrl/api/Post/upload-post",
      );

      final request =
      http.MultipartRequest(
        "POST",
        url,
      );

      // HEADERS

      request.headers.addAll({

        "Authorization":
        "Bearer $token",

        "Accept":
        "application/json",
      });

      // FIELDS

      request.fields['Caption'] =
          caption;

      request.fields['AddLocation'] =
          addLocation;

      // TAG PEOPLE

      for (int i = 0;
      i < tagPeople.length;
      i++) {

        request.fields[
        'TagPeople[$i]'
        ] =
            tagPeople[i].toString();
      }

      // IMAGES

      for (File image
      in images) {

        request.files.add(

          await http.MultipartFile
              .fromPath(

            "Images",

            image.path,
          ),
        );
      }

      // SEND

      final streamedResponse =
      await request.send();

      final response =
      await http.Response
          .fromStream(
        streamedResponse,
      );

      debugPrint(response.body);

      if (response.statusCode ==
          200) {

        final data =
        jsonDecode(
          response.body,
        );

        _successMessage =
        data['message'];

        notifyListeners();

        return true;
      }

      else {

        final data =
        jsonDecode(
          response.body,
        );

        _errorMessage =
        data['message'];

        notifyListeners();

        return false;
      }
    }

    catch (e) {

      _errorMessage =
          e.toString();

      notifyListeners();

      return false;
    }

    finally {

      _setLoading(false);
    }
  }

  // =====================================
  // FETCH POSTS
  // =====================================

  Future<void> fetchPosts()
  async {

    try {

      _setLoading(true);

      final Uri url = Uri.parse(
        "$_baseUrl/api/Post/get-all-posts",
      );

      final response =
      await http.get(url);

      debugPrint(response.body);

      if (response.statusCode ==
          200) {

        final data =
        jsonDecode(
          response.body,
        );

        final List<dynamic>
        postList =
        data['data'];

        _posts =
            postList.map((post) {

              return PostModel
                  .fromJson(post);

            }).toList();

        notifyListeners();
      }
    }

    catch (e) {

      _errorMessage =
          e.toString();

      notifyListeners();
    }

    finally {

      _setLoading(false);
    }
  }

  // =====================================
  // LOADING
  // =====================================

  void _setLoading(bool value) {

    _isLoading = value;

    notifyListeners();
  }
}