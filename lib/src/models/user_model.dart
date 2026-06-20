class UserModel {

  int? id;

  String? userName;

  String? email;

  String? password;

  String? fullName;

  String? phoneNumber;

  String? bio;

  String? profileImage;

  String? token;

  bool? isProfileCompleted;

  DateTime? createdAt;

  UserModel({

    this.id,
    this.userName,
    this.email,
    this.password,
    this.fullName,
    this.phoneNumber,
    this.bio,
    this.profileImage,
    this.token,
    this.isProfileCompleted,
    this.createdAt,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json) {

    return UserModel(

      id: json['id'],

      userName: json['userName'],

      email: json['email'],

      password: json['password'],

      fullName: json['fullName'],

      phoneNumber: json['phoneNumber'],

      bio: json['bio'],

      profileImage: json['profileImage'],

      token: json['token'],

      isProfileCompleted:
      json['isProfileCompleted'],

      createdAt: json['createdAt'] != null
          ? DateTime.parse(
          json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "userName": userName,

      "email": email,

      "password": password,

      "fullName": fullName,

      "phoneNumber": phoneNumber,

      "bio": bio,

      "profileImage": profileImage,

      "token": token,

      "isProfileCompleted":
      isProfileCompleted,

      "createdAt":
      createdAt?.toIso8601String(),
    };
  }
}