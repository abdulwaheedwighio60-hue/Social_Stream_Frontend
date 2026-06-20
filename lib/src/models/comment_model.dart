class CommentModel {
  final int id;
  final String userName;
  final String comment;
  final String time;
  final String userImage;
  final bool isVerified;

  int likeCount;
  int replyCount;
  bool isLiked;

  CommentModel({
    required this.id,
    required this.userName,
    required this.comment,
    required this.time,
    required this.userImage,
    required this.likeCount,
    required this.replyCount,
    this.isVerified = false,
    this.isLiked = false,
  });
}