class PostModel {
  int? id;
  int? userId;

  String? caption;
  String? addLocation;

  String? userName;
  String? fullName;
  String? profileImage;

  DateTime? createdAt;

  List<String> images;
  List<int> tagPeople;

  int likeCount;
  bool isLiked;

  PostModel({
    this.id,
    this.userId,
    this.caption,
    this.addLocation,
    this.userName,
    this.fullName,
    this.profileImage,
    this.createdAt,
    this.images = const [],
    this.tagPeople = const [],
    this.likeCount = 0,
    this.isLiked = false,
  });

  factory PostModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PostModel(
      id: _toInt(json['id']),
      userId: _toInt(json['userId']),
      caption: json['caption']?.toString(),
      addLocation: json['addLocation']?.toString(),
      userName: json['userName']?.toString(),
      fullName: json['fullName']?.toString(),
      profileImage:
      json['profileImage']?.toString(),
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      tagPeople:
      (json['tagPeople'] as List<dynamic>? ?? [])
          .map(_toInt)
          .toList(),
      likeCount: _toInt(
        json['likeCount'],
      ),
      isLiked: _toBool(
        json['isLiked'],
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    return value?.toString().toLowerCase() ==
        'true';
  }
}