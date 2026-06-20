// =========================================================
// LIKE / UNLIKE API RESULT MODEL
// =========================================================

class LikeModel {
  final int postId;
  final bool isLiked;
  final int likeCount;
  final String message;

  const LikeModel({
    required this.postId,
    required this.isLiked,
    required this.likeCount,
    required this.message,
  });

  factory LikeModel.fromResponse(
      Map<String, dynamic> response, {
        required int fallbackPostId,
      }) {
    final dynamic rawData = response['data'];

    final Map<String, dynamic> data = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{};

    return LikeModel(
      postId: _parseInt(
        data['postId'] ?? response['postId'],
      ) ??
          fallbackPostId,
      isLiked: _parseBool(
        data['isLiked'] ?? response['isLiked'],
      ),
      likeCount: _parseInt(
        data['likeCount'] ?? response['likeCount'],
      ) ??
          0,
      message:
      response['message']?.toString().trim().isNotEmpty == true
          ? response['message'].toString().trim()
          : 'Post like updated successfully.',
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final String parsedValue =
    value.toString().trim().toLowerCase();

    return parsedValue == 'true' ||
        parsedValue == '1' ||
        parsedValue == 'yes';
  }
}