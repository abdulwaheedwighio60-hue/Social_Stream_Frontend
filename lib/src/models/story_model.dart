// =========================================================
// STORY MODEL
// =========================================================

class StoryModel {
  final int id;
  final String userName;
  final String profileImage;
  final String storyImage;
  final String timeAgo;
  final bool isVerified;

  const StoryModel({
    required this.id,
    required this.userName,
    required this.profileImage,
    required this.storyImage,
    required this.timeAgo,
    this.isVerified = false,
  });
}

// =========================================================
// DUMMY STORY DATA
// =========================================================

