import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_stream/src/models/story_model.dart';

class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;

  const StoryViewScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewScreen> createState() =>
      _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _progressController;

  final TextEditingController _messageController =
  TextEditingController();

  final FocusNode _messageFocusNode = FocusNode();

  late int _currentIndex;

  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex.clamp(
      0,
      widget.stories.length - 1,
    );

    _pageController = PageController(
      initialPage: _currentIndex,
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _progressController.addStatusListener(
          (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _showNextStory();
        }
      },
    );

    _startProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  // =========================================================
  // STORY PROGRESS
  // =========================================================

  void _startProgress() {
    _progressController
      ..stop()
      ..reset()
      ..forward();

    _isPaused = false;
  }

  void _pauseProgress() {
    if (_isPaused) return;

    _progressController.stop();

    setState(() {
      _isPaused = true;
    });
  }

  void _resumeProgress() {
    if (!_isPaused) return;

    _progressController.forward();

    setState(() {
      _isPaused = false;
    });
  }

  // =========================================================
  // STORY NAVIGATION
  // =========================================================

  void _showNextStory() {
    if (_currentIndex <
        widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(
          milliseconds: 260,
        ),
        curve: Curves.easeOut,
      );

      return;
    }

    Navigator.of(context).pop();
  }

  void _showPreviousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(
          milliseconds: 260,
        ),
        curve: Curves.easeOut,
      );

      return;
    }

    _startProgress();
  }

  void _handleStoryTap(
      TapUpDetails details,
      ) {
    final double screenWidth =
        MediaQuery.sizeOf(context).width;

    final double tapPosition =
        details.localPosition.dx;

    if (tapPosition <
        screenWidth * 0.35) {
      _showPreviousStory();
    } else {
      _showNextStory();
    }
  }

  // =========================================================
  // SEND MESSAGE
  // =========================================================

  void _sendMessage() {
    final String message =
    _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    _messageController.clear();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Message sent successfully.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
          const Color(0xFFFF6B3D),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );

    _resumeProgress();
  }

  // =========================================================
  // MORE OPTIONS
  // =========================================================

  Future<void> _showMoreOptions() async {
    _pauseProgress();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (
          BuildContext bottomSheetContext,
          ) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            18,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(24),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(
                    bottom: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                ),

                _buildOptionTile(
                  icon:
                  Icons.volume_off_outlined,
                  title: 'Mute stories',
                  onTap: () {
                    Navigator.of(
                      bottomSheetContext,
                    ).pop();
                  },
                ),

                _buildOptionTile(
                  icon:
                  Icons.report_outlined,
                  title: 'Report story',
                  color: Colors.red,
                  onTap: () {
                    Navigator.of(
                      bottomSheetContext,
                    ).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (mounted) {
      _resumeProgress();
    }
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(15),
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.09),
          borderRadius:
          BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 15,
        color: Colors.grey.shade400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stories.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No stories available.',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    final StoryModel currentStory =
    widget.stories[_currentIndex];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            // ================================================
            // STORY IMAGE PAGES
            // ================================================

            Positioned.fill(
              child: GestureDetector(
                behavior:
                HitTestBehavior.translucent,
                onTapUp: _handleStoryTap,
                onLongPressStart: (_) {
                  _pauseProgress();
                },
                onLongPressEnd: (_) {
                  _resumeProgress();
                },
                child: PageView.builder(
                  controller: _pageController,
                  itemCount:
                  widget.stories.length,
                  physics:
                  const BouncingScrollPhysics(),
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });

                    _startProgress();
                  },
                  itemBuilder: (
                      BuildContext context,
                      int index,
                      ) {
                    return _buildStoryImage(
                      widget.stories[index],
                    );
                  },
                ),
              ),
            ),

            // ================================================
            // TOP DARK GRADIENT
            // ================================================

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 190,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end:
                      Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black
                            .withOpacity(0.70),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ================================================
            // BOTTOM DARK GRADIENT
            // ================================================

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 230,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin:
                      Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        Colors.black
                            .withOpacity(0.50),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ================================================
            // PROGRESS + USER HEADER
            // ================================================

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: <Widget>[
                    _buildProgressBars(),

                    _buildStoryHeader(
                      currentStory,
                    ),
                  ],
                ),
              ),
            ),

            // ================================================
            // MESSAGE INPUT
            // ================================================

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildMessageSection(
                currentStory,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // STORY IMAGE
  // =========================================================

  Widget _buildStoryImage(
      StoryModel story,
      ) {
    return Container(
      color: Colors.black,
      child: Image.network(
        story.storyImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? progress,
            ) {
          if (progress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.2,
            ),
          );
        },
        errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
            ) {
          return Container(
            color:
            const Color(0xFF222222),
            alignment: Alignment.center,
            child: const Column(
              mainAxisSize:
              MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white54,
                  size: 45,
                ),
                SizedBox(height: 10),
                Text(
                  'Story image unavailable',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // PROGRESS BARS
  // =========================================================

  Widget _buildProgressBars() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        7,
      ),
      child: Row(
        children: List<Widget>.generate(
          widget.stories.length,
              (int index) {
            return Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 2,
                ),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(10),
                  child: Container(
                    height: 3,
                    color: Colors.white
                        .withOpacity(0.35),
                    child: index <
                        _currentIndex
                        ? Container(
                      color: Colors.white,
                    )
                        : index >
                        _currentIndex
                        ? const SizedBox()
                        : AnimatedBuilder(
                      animation:
                      _progressController,
                      builder: (
                          BuildContext
                          context,
                          Widget? child,
                          ) {
                        return FractionallySizedBox(
                          widthFactor:
                          _progressController
                              .value,
                          alignment: Alignment
                              .centerLeft,
                          child:
                          Container(
                            color:
                            Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // USER HEADER
  // =========================================================

  Widget _buildStoryHeader(
      StoryModel story,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        7,
        9,
        8,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 45,
            height: 45,
            padding:
            const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                const Color(0xFFFF6B3D),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                story.profileImage,
                fit: BoxFit.cover,
                errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace?
                    stackTrace,
                    ) {
                  return Container(
                    color:
                    Colors.grey.shade300,
                    alignment:
                    Alignment.center,
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.black54,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        story.userName,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),

                    if (story.isVerified) ...[
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.verified_rounded,
                        color:
                        Color(0xFFFF6B3D),
                        size: 17,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  story.timeAgo,
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(0.78),
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed:
            _showMoreOptions,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize:
              const Size(42, 42),
            ),
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MESSAGE SECTION
  // =========================================================

  Widget _buildMessageSection(
      StoryModel story,
      ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        15,
        12,
        15,
        MediaQuery.paddingOf(context)
            .bottom +
            12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller:
              _messageController,
              focusNode:
              _messageFocusNode,
              textInputAction:
              TextInputAction.send,
              onTap: _pauseProgress,
              onSubmitted: (_) {
                _sendMessage();
              },
              decoration: InputDecoration(
                hintText:
                'Type a message here...',
                hintStyle: TextStyle(
                  color:
                  Colors.grey.shade500,
                  fontSize: 12,
                ),
                filled: true,
                fillColor:
                const Color(0xFFF7F7F8),
                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                  borderSide:
                  BorderSide.none,
                ),
                enabledBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color:
                    Colors.grey.shade200,
                  ),
                ),
                focusedBorder:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                  borderSide:
                  const BorderSide(
                    color:
                    Color(0xFFFF6B3D),
                    width: 1.4,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Material(
            color:
            const Color(0xFFFF6B3D),
            borderRadius:
            BorderRadius.circular(13),
            child: InkWell(
              onTap: _sendMessage,
              borderRadius:
              BorderRadius.circular(13),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// // =========================================================
// // STORY MODEL
// // =========================================================
//
// class StoryModel {
//   final int id;
//   final String userName;
//   final String profileImage;
//   final String storyImage;
//   final String timeAgo;
//   final bool isVerified;
//
//   const StoryModel({
//     required this.id,
//     required this.userName,
//     required this.profileImage,
//     required this.storyImage,
//     required this.timeAgo,
//     this.isVerified = false,
//   });
// }
//
// // =========================================================
// // DUMMY STORY DATA
// // =========================================================
//
// const List<StoryModel> dummyStories =
// <StoryModel>[
//   StoryModel(
//     id: 1,
//     userName: 'Brooklyn Simmons',
//     profileImage:
//     'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
//     storyImage:
//     'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1080&q=90',
//     timeAgo: '13 h',
//     isVerified: true,
//   ),
//   StoryModel(
//     id: 2,
//     userName: 'Jenny Wilson',
//     profileImage:
//     'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
//     storyImage:
//     'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=1080&q=90',
//     timeAgo: '8 h',
//     isVerified: true,
//   ),
//   StoryModel(
//     id: 3,
//     userName: 'Cameron Williamson',
//     profileImage:
//     'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
//     storyImage:
//     'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=1080&q=90',
//     timeAgo: '5 h',
//   ),
//   StoryModel(
//     id: 4,
//     userName: 'Leslie Alexander',
//     profileImage:
//     'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
//     storyImage:
//     'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=1080&q=90',
//     timeAgo: '2 h',
//     isVerified: true,
//   ),
// ];