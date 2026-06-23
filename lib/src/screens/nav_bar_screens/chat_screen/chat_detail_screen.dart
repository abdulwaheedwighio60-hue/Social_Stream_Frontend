import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/models/chat_message_model.dart';
import 'package:social_stream/src/widgets/custom_text_widget.dart';

enum ChatMessageType {
  text,
  audio,
  image,
}

// class ChatMessageModel {
//   final String id;
//   final ChatMessageType type;
//   final bool isSentByMe;
//   final DateTime createdAt;
//
//   final String? text;
//   final String? audioPath;
//   final Duration? audioDuration;
//   final String? imagePath;
//
//   const ChatMessageModel({
//     required this.id,
//     required this.type,
//     required this.isSentByMe,
//     required this.createdAt,
//     this.text,
//     this.audioPath,
//     this.audioDuration,
//     this.imagePath,
//   });
//
//   factory ChatMessageModel.text({
//     required String text,
//     required bool isSentByMe,
//   }) {
//     return ChatMessageModel(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       type: ChatMessageType.text,
//       isSentByMe: isSentByMe,
//       createdAt: DateTime.now(),
//       text: text,
//     );
//   }
//
//   factory ChatMessageModel.audio({
//     required String audioPath,
//     required Duration duration,
//     required bool isSentByMe,
//   }) {
//     return ChatMessageModel(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       type: ChatMessageType.audio,
//       isSentByMe: isSentByMe,
//       createdAt: DateTime.now(),
//       audioPath: audioPath,
//       audioDuration: duration,
//     );
//   }
//
//   factory ChatMessageModel.image({
//     required String imagePath,
//     required bool isSentByMe,
//   }) {
//     return ChatMessageModel(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       type: ChatMessageType.image,
//       isSentByMe: isSentByMe,
//       createdAt: DateTime.now(),
//       imagePath: imagePath,
//     );
//   }
// }

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final bool isOnline;

  const ChatDetailScreen({
    super.key,
    required this.userName,
    required this.userImage,
    this.isOnline = true,
  });

  @override
  State<ChatDetailScreen> createState() {
    return _ChatDetailScreenState();
  }
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController =
  TextEditingController();

  final FocusNode messageFocusNode = FocusNode();

  final ScrollController scrollController =
  ScrollController();

  final AudioRecorder audioRecorder =
  AudioRecorder();

  final List<ChatMessageModel> messages = [];

  /// Stores one selected reaction against each message id.
  final Map<String, String> messageReactions = <String, String>{};

  /// Keeps track of locally edited messages.
  final Set<String> editedMessageIds = <String>{};

  static const List<String> availableReactions = <String>[
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '🙏',
  ];

  bool isMessageEmpty = true;
  bool isRecording = false;
  bool isStoppingRecording = false;

  Duration recordingDuration = Duration.zero;
  Timer? recordingTimer;

  String? recordingFilePath;

  @override
  void initState() {
    super.initState();

    messageController.addListener(
      _onMessageChanged,
    );

    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    messages.addAll([
      ChatMessageModel.text(
        text:
        'Lorem ipsum is simply dummy text of the printing and typesetting industry.',
        isSentByMe: false,
      ),
      ChatMessageModel.text(
        text:
        'Lorem ipsum is simply dummy text of the printing and typesetting industry.',
        isSentByMe: true,
      ),
      ChatMessageModel.image(
        imagePath: 'assets/images/postImage1.jpg',
        isSentByMe: false,
      ),
    ]);
  }

  void _onMessageChanged() {
    final bool currentlyEmpty =
        messageController.text.trim().isEmpty;

    if (currentlyEmpty == isMessageEmpty) {
      return;
    }

    setState(() {
      isMessageEmpty = currentlyEmpty;
    });
  }

  @override
  void dispose() {
    recordingTimer?.cancel();

    messageController.removeListener(
      _onMessageChanged,
    );

    messageController.dispose();
    messageFocusNode.dispose();
    scrollController.dispose();
    audioRecorder.dispose();

    super.dispose();
  }

  // =====================================================
  // TEXT MESSAGE
  // =====================================================

  void sendTextMessage() {
    final String message =
    messageController.text.trim();

    if (message.isEmpty || isRecording) {
      return;
    }

    final ChatMessageModel newMessage =
    ChatMessageModel.text(
      text: message,
      isSentByMe: true,
    );

    setState(() {
      messages.add(newMessage);
      messageController.clear();
      isMessageEmpty = true;
    });

    messageFocusNode.requestFocus();

    _scrollToBottom();

    // Yahan API ya socket call add karein:
    //
    // await chatProvider.sendTextMessage(
    //   receiverId: receiverId,
    //   message: message,
    // );
  }

  // =====================================================
  // MESSAGE LONG-PRESS ACTIONS
  // =====================================================

  Future<void> _showMessageActions(
      ChatMessageModel message,
      ) async {
    await HapticFeedback.mediumImpact();

    if (!mounted) {
      return;
    }

    messageFocusNode.unfocus();

    final String? selectedReaction =
    messageReactions[message.id];

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 14),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'React',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F6F8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: availableReactions.map(
                          (String reaction) {
                        final bool isSelected =
                            selectedReaction == reaction;

                        return Material(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : Colors.transparent,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              Navigator.pop(bottomSheetContext);
                              _setMessageReaction(
                                message: message,
                                reaction: reaction,
                              );
                            },
                            child: AnimatedScale(
                              duration: const Duration(
                                milliseconds: 160,
                              ),
                              scale: isSelected ? 1.15 : 1,
                              child: SizedBox(
                                width: 42,
                                height: 42,
                                child: Center(
                                  child: Text(
                                    reaction,
                                    style: const TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                if (message.isSentByMe &&
                    message.type == ChatMessageType.text)
                  _buildMessageActionTile(
                    icon: Iconsax.edit_2,
                    title: 'Edit message',
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      _editTextMessage(message);
                    },
                  ),
                _buildMessageActionTile(
                  icon: Iconsax.trash,
                  title: message.isSentByMe
                      ? 'Delete message'
                      : 'Delete for me',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _confirmDeleteMessage(message);
                  },
                ),
                _buildMessageActionTile(
                  icon: Icons.close_rounded,
                  title: 'Cancel',
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 12,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setMessageReaction({
    required ChatMessageModel message,
    required String reaction,
  }) {
    final bool messageStillExists = messages.any(
          (ChatMessageModel item) => item.id == message.id,
    );

    if (!messageStillExists) {
      return;
    }

    setState(() {
      if (messageReactions[message.id] == reaction) {
        messageReactions.remove(message.id);
      } else {
        messageReactions[message.id] = reaction;
      }
    });

    // API/socket example:
    // await chatProvider.reactToMessage(
    //   messageId: message.id,
    //   reaction: messageReactions[message.id],
    // );
  }

  Future<void> _editTextMessage(
      ChatMessageModel message,
      ) async {
    if (!message.isSentByMe ||
        message.type != ChatMessageType.text) {
      return;
    }

    final TextEditingController editController =
    TextEditingController(text: message.text ?? '');

    final String? updatedText = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit message',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: editController,
            autofocus: true,
            minLines: 1,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Write your message',
              filled: true,
              fillColor: const Color(0xffF5F6F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  editController.text.trim(),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    editController.dispose();

    if (!mounted || updatedText == null) {
      return;
    }

    if (updatedText.isEmpty) {
      _showMessage(
        'Message cannot be empty.',
        isError: true,
      );
      return;
    }

    final int messageIndex = messages.indexWhere(
          (ChatMessageModel item) => item.id == message.id,
    );

    if (messageIndex < 0) {
      return;
    }

    final ChatMessageModel currentMessage =
    messages[messageIndex];

    if (currentMessage.text == updatedText) {
      return;
    }

    setState(() {
      messages[messageIndex] = ChatMessageModel(
        id: currentMessage.id,
        type: currentMessage.type,
        isSentByMe: currentMessage.isSentByMe,
        createdAt: currentMessage.createdAt,
        text: updatedText,
        audioPath: currentMessage.audioPath,
        audioDuration: currentMessage.audioDuration,
        imagePath: currentMessage.imagePath,
      );

      editedMessageIds.add(currentMessage.id);
    });

    _showMessage('Message updated.');

    // API/socket example:
    // await chatProvider.editMessage(
    //   messageId: currentMessage.id,
    //   message: updatedText,
    // );
  }

  Future<void> _confirmDeleteMessage(
      ChatMessageModel message,
      ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete message?'),
          content: Text(
            message.isSentByMe
                ? 'This message will be removed from the conversation.'
                : 'This message will be removed from your chat.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDelete != true) {
      return;
    }

    final int messageIndex = messages.indexWhere(
          (ChatMessageModel item) => item.id == message.id,
    );

    if (messageIndex < 0) {
      return;
    }

    final ChatMessageModel deletedMessage =
    messages[messageIndex];

    setState(() {
      messages.removeAt(messageIndex);
      messageReactions.remove(deletedMessage.id);
      editedMessageIds.remove(deletedMessage.id);
    });

    if (deletedMessage.isSentByMe &&
        deletedMessage.type == ChatMessageType.audio &&
        deletedMessage.audioPath != null) {
      try {
        final File audioFile = File(deletedMessage.audioPath!);

        if (await audioFile.exists()) {
          await audioFile.delete();
        }
      } catch (error) {
        debugPrint('Unable to delete local audio file: $error');
      }
    }

    _showMessage('Message deleted.');

    // API/socket example:
    // await chatProvider.deleteMessage(
    //   messageId: deletedMessage.id,
    //   deleteForEveryone: deletedMessage.isSentByMe,
    // );
  }

  // =====================================================
  // VOICE RECORDING
  // =====================================================

  Future<void> startRecording() async {
    if (isRecording || isStoppingRecording) {
      return;
    }

    try {
      final bool hasPermission =
      await audioRecorder.hasPermission();

      if (!hasPermission) {
        _showMessage(
          'Microphone permission is required.',
          isError: true,
        );

        return;
      }

      final Directory temporaryDirectory =
      await getTemporaryDirectory();

      final String filePath =
          '${temporaryDirectory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      const RecordConfig recordConfig =
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );

      await audioRecorder.start(
        recordConfig,
        path: filePath,
      );

      if (!mounted) {
        return;
      }

      messageFocusNode.unfocus();

      setState(() {
        isRecording = true;
        isStoppingRecording = false;
        recordingDuration = Duration.zero;
        recordingFilePath = filePath;
      });

      _startRecordingTimer();
    } catch (error) {
      _showMessage(
        'Unable to start recording: $error',
        isError: true,
      );
    }
  }

  Future<void> stopAndSendRecording() async {
    if (!isRecording || isStoppingRecording) {
      return;
    }

    setState(() {
      isStoppingRecording = true;
    });

    try {
      final String? savedPath =
      await audioRecorder.stop();

      _stopRecordingTimer();

      if (!mounted) {
        return;
      }

      final String? finalPath =
          savedPath ?? recordingFilePath;

      final Duration finalDuration =
          recordingDuration;

      setState(() {
        isRecording = false;
        isStoppingRecording = false;
        recordingDuration = Duration.zero;
        recordingFilePath = null;
      });

      if (finalPath == null) {
        _showMessage(
          'Audio recording could not be saved.',
          isError: true,
        );

        return;
      }

      final File audioFile =
      File(finalPath);

      if (!await audioFile.exists()) {
        _showMessage(
          'Recorded audio file was not found.',
          isError: true,
        );

        return;
      }

      if (finalDuration.inSeconds < 1) {
        await audioFile.delete();

        _showMessage(
          'Voice message is too short.',
          isError: true,
        );

        return;
      }

      final ChatMessageModel voiceMessage =
      ChatMessageModel.audio(
        audioPath: finalPath,
        duration: finalDuration,
        isSentByMe: true,
      );

      setState(() {
        messages.add(voiceMessage);
      });

      _scrollToBottom();

      // Yahan multipart API call add karein:
      //
      // await chatProvider.sendVoiceMessage(
      //   receiverId: receiverId,
      //   audioFile: audioFile,
      //   durationSeconds: finalDuration.inSeconds,
      // );
    } catch (error) {
      _stopRecordingTimer();

      if (!mounted) {
        return;
      }

      setState(() {
        isRecording = false;
        isStoppingRecording = false;
        recordingDuration = Duration.zero;
        recordingFilePath = null;
      });

      _showMessage(
        'Unable to send recording: $error',
        isError: true,
      );
    }
  }

  Future<void> cancelRecording() async {
    if (!isRecording || isStoppingRecording) {
      return;
    }

    setState(() {
      isStoppingRecording = true;
    });

    try {
      final String? savedPath =
      await audioRecorder.stop();

      _stopRecordingTimer();

      final String? filePath =
          savedPath ?? recordingFilePath;

      if (filePath != null) {
        final File file = File(filePath);

        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (error) {
      debugPrint(
        'Recording cancellation failed: $error',
      );
    } finally {
      if (mounted) {
        setState(() {
          isRecording = false;
          isStoppingRecording = false;
          recordingDuration = Duration.zero;
          recordingFilePath = null;
        });
      }
    }
  }

  void _startRecordingTimer() {
    recordingTimer?.cancel();

    recordingTimer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
        if (!mounted || !isRecording) {
          return;
        }

        setState(() {
          recordingDuration +=
          const Duration(seconds: 1);
        });

        // Optional maximum recording duration
        if (recordingDuration.inMinutes >= 5) {
          stopAndSendRecording();
        }
      },
    );
  }

  void _stopRecordingTimer() {
    recordingTimer?.cancel();
    recordingTimer = null;
  }

  // =====================================================
  // COMMON HELPERS
  // =====================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!scrollController.hasClients) {
          return;
        }

        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeOut,
        );
      },
    );
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? Colors.red.shade700
              : AppColors.primary,
          behavior:
          SnackBarBehavior.floating,
        ),
      );
  }

  String _formatDuration(
      Duration duration,
      ) {
    final String minutes =
    duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final String seconds =
    duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  String _formatMessageTime(
      DateTime dateTime,
      ) {
    int hour = dateTime.hour;

    final String period =
    hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;

    if (hour == 0) {
      hour = 12;
    }

    final String minute =
    dateTime.minute
        .toString()
        .padLeft(2, '0');

    return '$hour:$minute $period';
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primary,
      appBar: _buildAppBar(),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffF8F8F8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _buildMessagesList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.separated(
      controller: scrollController,
      keyboardDismissBehavior:
      ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        18,
      ),
      itemCount: messages.length + 1,
      separatorBuilder: (
          BuildContext context,
          int index,
          ) {
        return const SizedBox(height: 18);
      },
      itemBuilder: (
          BuildContext context,
          int index,
          ) {
        if (index == 0) {
          return _buildTodayDivider();
        }

        final ChatMessageModel message =
        messages[index - 1];

        return _buildMessageItem(message);
      },
    );
  }

  Widget _buildMessageItem(
      ChatMessageModel message,
      ) {
    final Widget messageBubble;

    switch (message.type) {
      case ChatMessageType.text:
        messageBubble = message.isSentByMe
            ? _buildSentMessage(
          message: message.text ?? '',
          time: _formatMessageTime(message.createdAt),
          isEdited: editedMessageIds.contains(message.id),
        )
            : _buildReceivedMessage(
          message: message.text ?? '',
          time: _formatMessageTime(message.createdAt),
        );
        break;

      case ChatMessageType.audio:
        messageBubble = AudioMessageBubble(
          audioPath: message.audioPath ?? '',
          duration: message.audioDuration ?? Duration.zero,
          time: _formatMessageTime(message.createdAt),
          isSentByMe: message.isSentByMe,
          userName: widget.userName,
          userImage: widget.userImage,
        );
        break;

      case ChatMessageType.image:
        messageBubble = _buildReceivedImageMessage(
          imagePath: message.imagePath ?? '',
          time: _formatMessageTime(message.createdAt),
        );
        break;
    }

    final String? reaction = messageReactions[message.id];

    return GestureDetector(
      key: ValueKey<String>(message.id),
      behavior: HitTestBehavior.translucent,
      onLongPress: () {
        _showMessageActions(message);
      },
      child: Column(
        crossAxisAlignment: message.isSentByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          messageBubble,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (
                Widget child,
                Animation<double> animation,
                ) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: reaction == null
                ? const SizedBox.shrink()
                : Container(
              key: ValueKey<String>(reaction),
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                reaction,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // APP BAR
  // =====================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      surfaceTintColor: AppColors.primary,
      toolbarHeight: 78,
      leadingWidth: 62,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 14,
        ),
        child: Center(
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder:
              const CircleBorder(),
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black87,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
      titleSpacing: 4,
      title: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                backgroundImage:
                AssetImage(widget.userImage),
              ),
              if (widget.isOnline)
                Positioned(
                  right: 0,
                  bottom: 1,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: widget.userName,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                CustomTextWidget(
                  text: widget.isOnline
                      ? 'Online'
                      : 'Offline',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white
                      .withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 14,
          ),
          child: Center(
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder:
                const CircleBorder(),
                onTap: _showChatOptions,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.black87,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showChatOptions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (
          BuildContext bottomSheetContext,
          ) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Iconsax.profile_circle,
                ),
                title:
                const Text('View profile'),
                onTap: () {
                  Navigator.pop(
                    bottomSheetContext,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Iconsax.search_normal,
                ),
                title: const Text(
                  'Search conversation',
                ),
                onTap: () {
                  Navigator.pop(
                    bottomSheetContext,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Iconsax.trash,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete conversation',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(
                    bottomSheetContext,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // =====================================================
  // MESSAGE INPUT
  // =====================================================

  Widget _buildMessageInput() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          14,
          9,
          14,
          11,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.05,
              ),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 200,
          ),
          child: isRecording
              ? _buildRecordingInput()
              : _buildNormalInput(),
        ),
      ),
    );
  }

  Widget _buildNormalInput() {
    return Row(
      key: const ValueKey(
        'normal-message-input',
      ),
      crossAxisAlignment:
      CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: _showAttachmentOptions,
          borderRadius:
          BorderRadius.circular(10),
          child: SizedBox(
            width: 38,
            height: 40,
            child: Icon(
              Icons.add_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            constraints:
            const BoxConstraints(
              minHeight: 40,
              maxHeight: 110,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF5F6F8),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: TextField(
              controller: messageController,
              focusNode: messageFocusNode,
              minLines: 1,
              maxLines: 4,
              textCapitalization:
              TextCapitalization.sentences,
              keyboardType:
              TextInputType.multiline,
              textInputAction:
              TextInputAction.newline,
              decoration: InputDecoration(
                hintText:
                'Type a message here...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 180,
          ),
          transitionBuilder: (
              Widget child,
              Animation<double> animation,
              ) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: isMessageEmpty
              ? _buildMicrophoneButton()
              : _buildSendButton(),
        ),
      ],
    );
  }

  Widget _buildMicrophoneButton() {
    return Material(
      key: const ValueKey(
        'microphone-button',
      ),
      color: AppColors.primary,
      borderRadius:
      BorderRadius.circular(10),
      child: InkWell(
        onTap: startRecording,
        borderRadius:
        BorderRadius.circular(10),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            Iconsax.microphone_2,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Material(
      key: const ValueKey(
        'send-button',
      ),
      color: AppColors.primary,
      borderRadius:
      BorderRadius.circular(10),
      child: InkWell(
        onTap: sendTextMessage,
        borderRadius:
        BorderRadius.circular(10),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            Iconsax.send_1,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildRecordingInput() {
    return Row(
      key: const ValueKey(
        'recording-message-input',
      ),
      children: [
        Material(
          color: Colors.red.withValues(
            alpha: 0.10,
          ),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: isStoppingRecording
                ? null
                : cancelRecording,
            customBorder:
            const CircleBorder(),
            child: const SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 42,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF5F6F8),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const _RecordingDot(),
                const SizedBox(width: 10),
                Text(
                  _formatDuration(
                    recordingDuration,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child:
                  _RecordingWaveAnimation(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: AppColors.primary,
          borderRadius:
          BorderRadius.circular(10),
          child: InkWell(
            onTap: isStoppingRecording
                ? null
                : stopAndSendRecording,
            borderRadius:
            BorderRadius.circular(10),
            child: SizedBox(
              width: 42,
              height: 42,
              child: isStoppingRecording
                  ? const Padding(
                padding:
                EdgeInsets.all(11),
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(
                Iconsax.send_1,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (
          BuildContext bottomSheetContext,
          ) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Iconsax.gallery,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );
                  },
                ),
                _buildAttachmentOption(
                  icon: Iconsax.camera,
                  label: 'Camera',
                  color: Colors.pink,
                  onTap: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );
                  },
                ),
                _buildAttachmentOption(
                  icon: Iconsax.document,
                  label: 'Document',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(
                      bottomSheetContext,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // EXISTING MESSAGE WIDGETS
  // =====================================================

  Widget _buildTodayDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.withValues(
              alpha: 0.18,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14,
          ),
          child: Text(
            'T O D A Y',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.withValues(
              alpha: 0.18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceivedMessage({
    required String message,
    required String time,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          constraints:
          const BoxConstraints(
            maxWidth: 285,
          ),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(12),
              bottomLeft:
              Radius.circular(12),
              bottomRight:
              Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 9,
              backgroundImage:
              AssetImage(widget.userImage),
            ),
            const SizedBox(width: 5),
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSentMessage({
    required String message,
    required String time,
    required bool isEdited,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.end,
      children: [
        Container(
          constraints:
          const BoxConstraints(
            maxWidth: 285,
          ),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius:
            const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(4),
              bottomLeft:
              Radius.circular(12),
              bottomRight:
              Radius.circular(12),
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
          MainAxisAlignment.end,
          children: [
            if (isEdited) ...[
              const Text(
                'Edited',
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.black38,
                ),
              ),
              const SizedBox(width: 7),
            ],
            Text(
              time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black45,
              ),
            ),
            const SizedBox(width: 14),
            const CircleAvatar(
              radius: 9,
              backgroundImage: AssetImage(
                'assets/images/user_image1.jpg',
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'You',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReceivedImageMessage({
    required String imagePath,
    required String time,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: 210,
          height: 230,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(6),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                  ) {
                return Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(
                    Iconsax.gallery,
                    size: 45,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 9,
              backgroundImage:
              AssetImage(widget.userImage),
            ),
            const SizedBox(width: 5),
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =======================================================
// AUDIO MESSAGE BUBBLE
// =======================================================

class AudioMessageBubble extends StatefulWidget {
  final String audioPath;
  final Duration duration;
  final String time;
  final bool isSentByMe;
  final String userName;
  final String userImage;

  const AudioMessageBubble({
    super.key,
    required this.audioPath,
    required this.duration,
    required this.time,
    required this.isSentByMe,
    required this.userName,
    required this.userImage,
  });

  @override
  State<AudioMessageBubble> createState() {
    return _AudioMessageBubbleState();
  }
}

class _AudioMessageBubbleState
    extends State<AudioMessageBubble> {
  final AudioPlayer audioPlayer =
  AudioPlayer();

  StreamSubscription<PlayerState>?
  playerStateSubscription;

  StreamSubscription<Duration>?
  positionSubscription;

  bool isPlaying = false;
  bool isLoading = false;

  Duration currentPosition =
      Duration.zero;

  @override
  void initState() {
    super.initState();

    playerStateSubscription =
        audioPlayer.playerStateStream.listen(
              (PlayerState state) {
            if (!mounted) {
              return;
            }

            setState(() {
              isPlaying = state.playing;
              isLoading =
                  state.processingState ==
                      ProcessingState.loading ||
                      state.processingState ==
                          ProcessingState.buffering;
            });

            if (state.processingState ==
                ProcessingState.completed) {
              audioPlayer.seek(Duration.zero);
              audioPlayer.pause();
            }
          },
        );

    positionSubscription =
        audioPlayer.positionStream.listen(
              (Duration position) {
            if (!mounted) {
              return;
            }

            setState(() {
              currentPosition = position;
            });
          },
        );
  }

  Future<void> toggleAudio() async {
    try {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
        return;
      }

      if (audioPlayer.audioSource == null) {
        final File file =
        File(widget.audioPath);

        if (!await file.exists()) {
          return;
        }

        await audioPlayer.setFilePath(
          widget.audioPath,
        );
      }

      await audioPlayer.play();
    } catch (error) {
      debugPrint(
        'Audio playback failed: $error',
      );
    }
  }

  String formatDuration(
      Duration duration,
      ) {
    final String minutes =
    duration.inMinutes
        .remainder(60)
        .toString();

    final String seconds =
    duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    playerStateSubscription?.cancel();
    positionSubscription?.cancel();
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bubbleColor =
    widget.isSentByMe
        ? AppColors.primary
        : Colors.white;

    final Color contentColor =
    widget.isSentByMe
        ? Colors.white
        : AppColors.primary;

    final Duration shownDuration =
    currentPosition > Duration.zero
        ? currentPosition
        : widget.duration;

    return Column(
      crossAxisAlignment:
      widget.isSentByMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          height: 55,
          constraints:
          const BoxConstraints(
            maxWidth: 300,
            minWidth: 230,
          ),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius:
            BorderRadius.only(
              topLeft: Radius.circular(
                widget.isSentByMe ? 12 : 4,
              ),
              topRight: Radius.circular(
                widget.isSentByMe ? 4 : 12,
              ),
              bottomLeft:
              const Radius.circular(12),
              bottomRight:
              const Radius.circular(12),
            ),
            boxShadow: widget.isSentByMe
                ? null
                : [
              BoxShadow(
                color: Colors.black
                    .withValues(
                  alpha: 0.04,
                ),
                blurRadius: 10,
                offset:
                const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Material(
                color: widget.isSentByMe
                    ? Colors.white
                    : AppColors.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: toggleAudio,
                  customBorder:
                  const CircleBorder(),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: isLoading
                        ? Padding(
                      padding:
                      const EdgeInsets.all(
                        8,
                      ),
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                        widget.isSentByMe
                            ? AppColors
                            .primary
                            : Colors
                            .white,
                      ),
                    )
                        : Icon(
                      isPlaying
                          ? Icons
                          .pause_rounded
                          : Icons
                          .play_arrow_rounded,
                      color:
                      widget.isSentByMe
                          ? AppColors
                          .primary
                          : Colors
                          .white,
                      size: 21,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StaticAudioWave(
                  color: contentColor,
                  progress:
                  widget.duration.inMilliseconds >
                      0
                      ? currentPosition
                      .inMilliseconds /
                      widget.duration
                          .inMilliseconds
                      : 0,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatDuration(
                  shownDuration,
                ),
                style: TextStyle(
                  fontSize: 11,
                  color: contentColor,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.isSentByMe
              ? [
            Text(
              widget.time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black45,
              ),
            ),
            const SizedBox(width: 14),
            const CircleAvatar(
              radius: 9,
              backgroundImage:
              AssetImage(
                'assets/images/user_image1.jpg',
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'You',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
          ]
              : [
            CircleAvatar(
              radius: 9,
              backgroundImage:
              AssetImage(
                widget.userImage,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              widget.time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =======================================================
// RECORDING ANIMATIONS
// =======================================================

class _RecordingDot extends StatefulWidget {
  const _RecordingDot();

  @override
  State<_RecordingDot> createState() {
    return _RecordingDotState();
  }
}

class _RecordingDotState
    extends State<_RecordingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration:
      const Duration(milliseconds: 800),
      lowerBound: 0.35,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _RecordingWaveAnimation
    extends StatefulWidget {
  const _RecordingWaveAnimation();

  @override
  State<_RecordingWaveAnimation> createState() {
    return _RecordingWaveAnimationState();
  }
}

class _RecordingWaveAnimationState
    extends State<_RecordingWaveAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  final List<double> waveHeights = [
    8,
    17,
    12,
    22,
    10,
    18,
    14,
    24,
    9,
    19,
    13,
    21,
    10,
    16,
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration:
      const Duration(milliseconds: 850),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (
          BuildContext context,
          Widget? child,
          ) {
        return Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children:
          List.generate(
            waveHeights.length,
                (int index) {
              final double phase =
                  (controller.value +
                      index /
                          waveHeights.length) %
                      1;

              final double factor =
              phase < 0.5
                  ? 0.5 + phase
                  : 1.5 - phase;

              return Container(
                width: 2,
                height:
                waveHeights[index] *
                    factor,
                decoration: BoxDecoration(
                  color: Colors.red
                      .withValues(alpha: 0.75),
                  borderRadius:
                  BorderRadius.circular(4),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StaticAudioWave
    extends StatelessWidget {
  final Color color;
  final double progress;

  const _StaticAudioWave({
    required this.color,
    required this.progress,
  });

  static const List<double> waveHeights = [
    8,
    14,
    20,
    11,
    17,
    24,
    13,
    18,
    10,
    22,
    16,
    9,
    19,
    25,
    12,
    18,
    10,
    15,
    22,
    9,
    16,
    12,
    19,
    8,
  ];

  @override
  Widget build(BuildContext context) {
    final double safeProgress =
    progress.clamp(0, 1);

    return SizedBox(
      height: 28,
      child: LayoutBuilder(
        builder: (
            BuildContext context,
            BoxConstraints constraints,
            ) {
          final int playedBars =
          (waveHeights.length *
              safeProgress)
              .round();

          return Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: List.generate(
              waveHeights.length,
                  (int index) {
                return Container(
                  width: 2,
                  height:
                  waveHeights[index],
                  decoration: BoxDecoration(
                    color: index <
                        playedBars
                        ? color
                        : color.withValues(
                      alpha: 0.35,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      4,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}