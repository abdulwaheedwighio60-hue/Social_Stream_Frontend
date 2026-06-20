import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:social_stream/src/models/like_model.dart';



// =========================================================
// LIKE PROVIDER
// =========================================================

class LikeProvider extends ChangeNotifier {
  // =======================================================
  // BASE URL
  // =======================================================

  static const String _baseUrl =
      'http://10.20.1.205:5033';

  // =======================================================
  // LOADING STATE
  // =======================================================

  final Set<int> _loadingPostIds = <int>{};

  bool get isLoading => _loadingPostIds.isNotEmpty;

  bool isPostLikeLoading(int postId) {
    return _loadingPostIds.contains(postId);
  }

  // =======================================================
  // MESSAGES
  // =======================================================

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _successMessage;

  String? get successMessage => _successMessage;

  // =======================================================
  // LIKE / UNLIKE POST
  // =======================================================

  Future<LikeModel?> likePost({
    required int postId,
    required String token,
  }) async {
    final String cleanToken = token.trim();

    // Duplicate request prevention.
    if (_loadingPostIds.contains(postId)) {
      return null;
    }

    // =====================================================
    // VALIDATION
    // =====================================================

    if (postId <= 0) {
      _setErrorMessage(
        'Invalid post selected.',
      );

      return null;
    }

    if (cleanToken.isEmpty) {
      _setErrorMessage(
        'Your session has expired. Please log in again.',
      );

      return null;
    }

    _clearMessages();
    _setPostLoading(postId, true);

    try {
      final Uri url = Uri.parse(
        '$_baseUrl/api/Post/like-post/$postId',
      );

      debugPrint(
        'Like/Unlike API URL: $url',
      );

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
        'Like/Unlike Status: ${response.statusCode}',
      );

      debugPrint(
        'Like/Unlike Response: ${response.body}',
      );

      final Map<String, dynamic> responseData =
      _decodeResponse(response.body);

      // ===================================================
      // SUCCESS
      // ===================================================

      final bool isHttpSuccess =
          response.statusCode >= 200 &&
              response.statusCode < 300;

      final bool isApiSuccess =
          responseData['success'] != false;

      if (isHttpSuccess && isApiSuccess) {
        final LikeModel result =
        LikeModel.fromResponse(
          responseData,
          fallbackPostId: postId,
        );

        _successMessage = result.message;
        _errorMessage = null;

        notifyListeners();

        return result;
      }

      // ===================================================
      // API ERROR
      // ===================================================

      _errorMessage = _extractMessage(
        responseData,
        fallback: _getStatusCodeMessage(
          response.statusCode,
        ),
      );

      _successMessage = null;

      notifyListeners();

      return null;
    } on SocketException {
      _setErrorMessage(
        'No internet connection. Please check your network.',
      );

      return null;
    } on TimeoutException {
      _setErrorMessage(
        'The request timed out. Please try again.',
      );

      return null;
    } on FormatException {
      _setErrorMessage(
        'Invalid response received from the server.',
      );

      return null;
    } catch (error, stackTrace) {
      debugPrint(
        'Like/Unlike Post Error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _setErrorMessage(
        'Something went wrong while updating the post like.',
      );

      return null;
    } finally {
      _setPostLoading(postId, false);
    }
  }

  // =======================================================
  // RESPONSE DECODER
  // =======================================================

  Map<String, dynamic> _decodeResponse(
      String responseBody,
      ) {
    if (responseBody.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final dynamic decodedData =
    jsonDecode(responseBody);

    if (decodedData is Map<String, dynamic>) {
      return decodedData;
    }

    if (decodedData is Map) {
      return Map<String, dynamic>.from(
        decodedData,
      );
    }

    return <String, dynamic>{};
  }

  // =======================================================
  // MESSAGE EXTRACTOR
  // =======================================================

  String _extractMessage(
      Map<String, dynamic> data, {
        required String fallback,
      }) {
    final String directMessage =
        data['message']?.toString().trim() ?? '';

    if (directMessage.isNotEmpty) {
      return directMessage;
    }

    final dynamic responseData = data['data'];

    if (responseData is Map) {
      final String nestedMessage =
          responseData['message']
              ?.toString()
              .trim() ??
              '';

      if (nestedMessage.isNotEmpty) {
        return nestedMessage;
      }
    }

    return fallback;
  }

  // =======================================================
  // STATUS CODE MESSAGES
  // =======================================================

  String _getStatusCodeMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Unable to update this post. Please try again.';

      case 401:
        return 'Your session has expired. Please log in again.';

      case 403:
        return 'You are not authorized to perform this action.';

      case 404:
        return 'This post could not be found.';

      case 409:
        return 'The post like state has already changed.';

      case 500:
      case 501:
      case 502:
      case 503:
        return 'Server is currently unavailable. Please try again later.';

      default:
        return 'Failed to update the post. Please try again.';
    }
  }

  // =======================================================
  // STATE HELPERS
  // =======================================================

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