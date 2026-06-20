import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LikeProvider extends ChangeNotifier {
  // =========================================================
  // BASE URL
  // =========================================================

  static const String _baseUrl = 'http://10.20.1.205:5033';

  // =========================================================
  // LOADING STATE
  // =========================================================

  final Set<int> _loadingPostIds = <int>{};

  bool isPostLikeLoading(int postId) {
    return _loadingPostIds.contains(postId);
  }

  bool get isLoading => _loadingPostIds.isNotEmpty;

  // =========================================================
  // MESSAGES
  // =========================================================

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _successMessage;

  String? get successMessage => _successMessage;

  // =========================================================
  // LIKE POST
  // =========================================================

  Future<bool> likePost({
    required int postId,
    required String token,
  }) async {
    final String cleanToken = token.trim();

    // Prevent duplicate API calls for the same post.
    if (_loadingPostIds.contains(postId)) {
      return false;
    }

    // =======================================================
    // LOCAL VALIDATION
    // =======================================================

    if (postId <= 0) {
      _setErrorMessage('Invalid post selected.');
      return false;
    }

    if (cleanToken.isEmpty) {
      _setErrorMessage(
        'Your session has expired. Please log in again.',
      );
      return false;
    }

    _clearMessages();
    _setPostLoading(postId, true);

    try {
      final Uri url = Uri.parse(
        '$_baseUrl/api/Post/like-post/$postId',
      );

      debugPrint('Like Post API: $url');

      final http.Response response = await http
          .post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $cleanToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      )
          .timeout(
        const Duration(seconds: 30),
      );

      debugPrint(
        'Like Post Status Code: ${response.statusCode}',
      );

      debugPrint(
        'Like Post Response: ${response.body}',
      );

      final Map<String, dynamic>? responseData =
      _decodeResponse(response.body);

      // =====================================================
      // SUCCESS
      // =====================================================

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        _successMessage = _extractMessage(
          responseData,
          fallback: 'Post liked successfully.',
        );

        _errorMessage = null;

        notifyListeners();

        return true;
      }

      // =====================================================
      // API ERROR
      // =====================================================

      _errorMessage = _extractMessage(
        responseData,
        fallback: _getStatusCodeMessage(
          response.statusCode,
        ),
      );

      _successMessage = null;

      notifyListeners();

      return false;
    } on SocketException {
      _setErrorMessage(
        'No internet connection. Please check your network.',
      );

      return false;
    } on TimeoutException {
      _setErrorMessage(
        'The request timed out. Please try again.',
      );

      return false;
    } on FormatException {
      _setErrorMessage(
        'Invalid response received from the server.',
      );

      return false;
    } catch (error, stackTrace) {
      debugPrint('Like Post Error: $error');

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _setErrorMessage(
        'Something went wrong while liking the post.',
      );

      return false;
    } finally {
      _setPostLoading(postId, false);
    }
  }

  // =========================================================
  // RESPONSE DECODER
  // =========================================================

  Map<String, dynamic>? _decodeResponse(
      String responseBody,
      ) {
    if (responseBody.trim().isEmpty) {
      return null;
    }

    final dynamic decodedData = jsonDecode(
      responseBody,
    );

    if (decodedData is Map<String, dynamic>) {
      return decodedData;
    }

    if (decodedData is Map) {
      return Map<String, dynamic>.from(
        decodedData,
      );
    }

    return null;
  }

  // =========================================================
  // MESSAGE EXTRACTOR
  // =========================================================

  String _extractMessage(
      Map<String, dynamic>? data, {
        required String fallback,
      }) {
    if (data == null) {
      return fallback;
    }

    final String directMessage =
        data['message']?.toString().trim() ?? '';

    if (directMessage.isNotEmpty) {
      return directMessage;
    }

    final dynamic responseData = data['data'];

    if (responseData is Map) {
      final String nestedMessage =
          responseData['message']?.toString().trim() ?? '';

      if (nestedMessage.isNotEmpty) {
        return nestedMessage;
      }
    }

    return fallback;
  }

  // =========================================================
  // STATUS CODE MESSAGES
  // =========================================================

  String _getStatusCodeMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Unable to like this post. Please try again.';

      case 401:
        return 'Your session has expired. Please log in again.';

      case 403:
        return 'You are not authorized to like this post.';

      case 404:
        return 'This post could not be found.';

      case 409:
        return 'This post has already been liked.';

      case 500:
      case 501:
      case 502:
      case 503:
        return 'Server is currently unavailable. Please try again later.';

      default:
        return 'Failed to like the post. Please try again.';
    }
  }

  // =========================================================
  // STATE HELPERS
  // =========================================================

  void _setPostLoading(
      int postId,
      bool value,
      ) {
    if (value) {
      _loadingPostIds.add(postId);
    } else {
      _loadingPostIds.remove(postId);
    }

    notifyListeners();
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
    _successMessage = null;

    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;

    notifyListeners();
  }

  void clearMessages() {
    _clearMessages();
  }
}