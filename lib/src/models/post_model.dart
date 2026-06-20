class PostModel {

  int? id;
  int? userId;

  String? caption;
  String? addLocation;

  String? userName;
  String? fullName;
  String? profileImage;

  DateTime? createdAt;

  List<String>? images;

  List<int>? tagPeople;

  PostModel({
    this.id,
    this.userId,
    this.caption,
    this.addLocation,
    this.userName,
    this.fullName,
    this.profileImage,
    this.createdAt,
    this.images,
    this.tagPeople,
  });

  factory PostModel.fromJson(
      Map<String, dynamic> json) {

    return PostModel(

      id: json['id'],

      userId: json['userId'],

      caption: json['caption'],

      addLocation:
      json['addLocation'],

      userName:
      json['userName'],

      fullName:
      json['fullName'],

      profileImage:
      json['profileImage'],

      createdAt:
      DateTime.parse(
        json['createdAt'],
      ),

      images:
      List<String>.from(
        json['images'] ?? [],
      ),

      tagPeople:
      List<int>.from(
        json['tagPeople'] ?? [],
      ),
    );
  }
}