import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/models/story_model.dart';
import 'package:social_stream/src/screens/nav_bar_screens/home_screen/post_card_widget.dart';
import 'package:social_stream/src/screens/nav_bar_screens/home_screen/widget/comment_bottom_sheet.dart';
import 'package:social_stream/src/screens/notification/notification_screen.dart';
import 'package:social_stream/src/screens/stories/stories_screen.dart' hide StoryModel;
import 'package:social_stream/src/services/post_provider.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:social_stream/src/widgets/custom_circle_icon_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {

    super.initState();

    Future.microtask(() {

      Provider.of<PostProvider>(
        context,
        listen: false,
      ).fetchPosts();
    });
  }


   List<StoryModel> dummyStories = <StoryModel>[
    StoryModel(
      id: 1,
      userName: 'Brooklyn Simmons',
      profileImage:
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      storyImage:
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1080&q=90',
      timeAgo: '13 h',
      isVerified: true,
    ),
    StoryModel(
      id: 2,
      userName: 'Jenny Wilson',
      profileImage:
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      storyImage:
      'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=1080&q=90',
      timeAgo: '8 h',
      isVerified: true,
    ),
    StoryModel(
      id: 3,
      userName: 'Cameron Williamson',
      profileImage:
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
      storyImage:
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=1080&q=90',
      timeAgo: '5 h',
    ),
    StoryModel(
      id: 4,
      userName: 'Leslie Alexander',
      profileImage:
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      storyImage:
      'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=1080&q=90',
      timeAgo: '2 h',
      isVerified: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.020,
          vertical: screenHeight * 0.010,
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02,),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                // LEFT
                Image.asset(
                  AppImages.appLogo,
                  width: 160,

                ),


                // RIGHT
                Row(
                  children: [

                    CustomCircleIconWidget(
                      icon: Iconsax.search_normal,
                    ),

                    const SizedBox(width: 10),

                    CustomCircleIconWidget(
                      icon: Iconsax.notification,
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()
                            ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 110,

              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (
                          BuildContext context,
                          ) {
                        return  StoryViewScreen(
                          stories: dummyStories,
                        );
                      },
                    ),
                  );
                  print("Click The Storeis Section");
                },
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),

                  itemCount: 10,


                  separatorBuilder: (_, __) =>
                  const SizedBox(width: 12),

                  itemBuilder: (context, index) {
                    final bool isLive = index == 1;
                    final bool isYourStory = index == 0;

                    return SizedBox(
                      width: 90,

                      child: Stack(
                        clipBehavior: Clip.none,

                        children: [

                          // STORY CARD
                          Container(
                            height: 140,
                            width: 120,

                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(18),

                              image: DecorationImage(
                                image: AssetImage(
                                  AppImages.userImage1,
                                ),

                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // DARK OVERLAY
                          Container(
                            height: 140,
                            width: 120,

                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(10),

                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,

                                colors: [
                                  Colors.black.withOpacity(0.15),
                                  Colors.black.withOpacity(0.45),
                                ],
                              ),
                            ),
                          ),

                          // LIVE BADGE
                          if (isLive)
                            Positioned(
                              top: 6,
                              left: 6,

                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),

                                child: const Text(
                                  "Live",

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                          // USER IMAGE
                          Positioned(
                            bottom: 8,
                            left: 6,

                            child: Stack(
                              clipBehavior: Clip.none,

                              children: [

                                Container(
                                  padding:
                                  const EdgeInsets.all(2),

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                      AppColors.primary,
                                      width: 2,
                                    ),
                                  ),

                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundImage:
                                    AssetImage(
                                      AppImages.userImage1,
                                    ),
                                  ),
                                ),

                                // ADD BUTTON
                                if (isYourStory)
                                  Positioned(
                                    right: -2,
                                    bottom: -2,

                                    child: Container(
                                      height: 18,
                                      width: 18,

                                      decoration:
                                      const BoxDecoration(
                                        color:
                                        AppColors.white,
                                        shape:
                                        BoxShape.circle,
                                      ),

                                      child: const Icon(
                                        Icons.add,
                                        size: 14,
                                        color:
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // USER NAME
                          Positioned(
                            bottom: 10,
                            left: 34,

                            child: Text(
                              isYourStory
                                  ? "You"
                                  : "Theresa",

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight:
                                FontWeight.w600,
                              ),

                              overflow:
                              TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.020,),
            Expanded(

              child:
              Consumer<PostProvider>(

                builder:
                    (context, provider, child) {

                  // LOADING

                  if (provider.isLoading) {

                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  // EMPTY

                  if (provider.posts.isEmpty) {

                    return const Center(

                      child: Text(
                        "No Posts Found",
                      ),
                    );
                  }

                  // POSTS

                  return ListView.builder(

                    itemCount:
                    provider.posts.length,

                    padding:
                    const EdgeInsets.only(
                      bottom: 20,
                    ),

                    itemBuilder:
                        (context, index) {

                      final post =
                      provider.posts[index];

                      return PostCardWidget(
                        key: ValueKey<int>(
                          post.id ?? index,
                        ),

                        postId: post.id ?? 0,

                        userName:
                        post.fullName ?? 'Social Stream User',

                        userUsername:
                        post.userName?.trim().isNotEmpty == true
                            ? '@${post.userName}'
                            : '@user',

                        userImage:
                        post.profileImage ?? '',

                        postImages:
                        post.images,

                        caption:
                        post.caption ?? '',

                        location:
                        post.addLocation ?? '',

                        likes:
                        post.likeCount,

                        isLiked:
                        post.isLiked,

                        comments:
                        '0',

                        shares:
                        '0',

                        onLikeChanged: (
                            bool isLiked,
                            int likeCount,
                            ) {
                          post.isLiked = isLiked;
                          post.likeCount = likeCount;
                        },

                        onCommentTap: () {
                          CommentBottomSheet.show(
                            context,
                            postId: post.id ?? 0,
                          );
                        },

                        onShareTap: () {},

                        onBookmarkTap: () {},

                        onMoreTap: () {},
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}

