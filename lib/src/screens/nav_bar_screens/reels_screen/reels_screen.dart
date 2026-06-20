import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();

  final List<String> videos = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videos.length,

        itemBuilder: (context, index) {
          return ReelItem(
            videoUrl: videos[index],
          );
        },
      ),
    );
  }
}

class ReelItem extends StatefulWidget {
  final String videoUrl;

  const ReelItem({
    super.key,
    required this.videoUrl,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _controller;

  bool isLiked = false;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;

      if (isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: togglePlayPause,

      child: Stack(
        fit: StackFit.expand,
        children: [

          /// VIDEO
          _controller.value.isInitialized
              ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
              : const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),

          /// DARK OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          /// CENTER PLAY ICON
          if (!isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 80,
              ),
            ),

          /// RIGHT ACTIONS
          Positioned(
            right: 12,
            bottom: 100,

            child: Column(
              children: [

                /// PROFILE
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/300",
                  ),
                ),

                const SizedBox(height: 25),

                /// LIKE
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },

                  child: Column(
                    children: [

                      Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                        isLiked ? Colors.red : Colors.white,
                        size: 32,
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "12.5K",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// COMMENT
                const Column(
                  children: [

                    Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.white,
                      size: 30,
                    ),

                    SizedBox(height: 5),

                    Text(
                      "1.2K",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// SHARE
                const Column(
                  children: [

                    Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 28,
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Share",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// BOTTOM INFO
          Positioned(
            left: 14,
            right: 80,
            bottom: 15,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// USERNAME
                const Row(
                  children: [

                    Text(
                      "@abdulwaheed",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(width: 8),

                    Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// CAPTION
                const Text(
                  "Flutter reels UI 🔥 Professional TikTok style screen with smooth scrolling.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                /// MUSIC
                Row(
                  children: [

                    const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 16,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        "Original Audio - Abdul Waheed",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}