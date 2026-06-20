import 'package:social_stream/src/screens/nav_bar_screens/chat_screen/chat_detail_screen.dart';

class ChatMessageModel {
  final String id;
  final ChatMessageType type;
  final bool isSentByMe;
  final DateTime createdAt;

  final String? text;
  final String? audioPath;
  final Duration? audioDuration;
  final String? imagePath;

  const ChatMessageModel({
    required this.id,
    required this.type,
    required this.isSentByMe,
    required this.createdAt,
    this.text,
    this.audioPath,
    this.audioDuration,
    this.imagePath,
  });

  factory ChatMessageModel.text({
    required String text,
    required bool isSentByMe,
  }) {
    return ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: ChatMessageType.text,
      isSentByMe: isSentByMe,
      createdAt: DateTime.now(),
      text: text,
    );
  }

  factory ChatMessageModel.audio({
    required String audioPath,
    required Duration duration,
    required bool isSentByMe,
  }) {
    return ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: ChatMessageType.audio,
      isSentByMe: isSentByMe,
      createdAt: DateTime.now(),
      audioPath: audioPath,
      audioDuration: duration,
    );
  }

  factory ChatMessageModel.image({
    required String imagePath,
    required bool isSentByMe,
  }) {
    return ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: ChatMessageType.image,
      isSentByMe: isSentByMe,
      createdAt: DateTime.now(),
      imagePath: imagePath,
    );
  }
}
