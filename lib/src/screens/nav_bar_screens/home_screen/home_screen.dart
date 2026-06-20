import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/nav_bar_screens/home_screen/post_card_widget.dart';
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
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 110,

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
                        key: ValueKey<int>(post.id ?? index),

                        // POST ID
                        postId: post.id ?? 0,

                        // USER
                        userName: post.fullName ?? 'Social Stream User',

                        userUsername: post.userName?.trim().isNotEmpty == true
                            ? '@${post.userName}'
                            : '@user',

                        userImage: post.profileImage ?? '',

                        // POST
                        postImages: post.images ?? const [],

                        caption: post.caption ?? '',

                        location: post.addLocation ?? '',

                        likes: '8.5k',

                        comments: '256',

                        shares: '1.2k',

                        isLiked: false,

                        isVerified: true,

                        isBookmarked: false,

                        // Like API PostCardWidget ke andar call ho rahi hai.
                        // Yeh callback sirf successful like ke baad chalega.
                        onLikeTap: () {
                          debugPrint(
                            'Post ${post.id} liked successfully',
                          );
                        },

                        onCommentTap: () {
                          debugPrint(
                            'Comment clicked for post ${post.id}',
                          );
                        },

                        onShareTap: () {
                          debugPrint(
                            'Share clicked for post ${post.id}',
                          );
                        },

                        onBookmarkTap: () {
                          debugPrint(
                            'Bookmark clicked for post ${post.id}',
                          );
                        },

                        onMoreTap: () {
                          debugPrint(
                            'More options clicked for post ${post.id}',
                          );
                        },
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

