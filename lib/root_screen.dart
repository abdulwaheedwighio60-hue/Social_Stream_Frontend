import 'package:social_stream/src/screens/nav_bar_screens/chat_screen/inboxScreen.dart';
import 'package:social_stream/src/screens/nav_bar_screens/home_screen/home_screen.dart';
import 'package:social_stream/src/screens/nav_bar_screens/post_upload_screen/post_upload_screen.dart';
import 'package:social_stream/src/screens/nav_bar_screens/profile_screen/user_profile_screen.dart';
import 'package:social_stream/src/screens/nav_bar_screens/reels_screen/reels_screen.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() =>
      _RootScreenState();
}

class _RootScreenState
    extends State<RootScreen> {

  // =====================================
  // CURRENT INDEX
  // =====================================

  int currentIndex = 0;

  // =====================================
  // SCREENS
  // =====================================

  final List<Widget> screens = [
    HomeScreen(),
    ReelsScreen(),
    PostUploadScreen(),
    InboxScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final bool isReelsScreen =
        currentIndex == 1;

    return Scaffold(

      extendBody: true,

      backgroundColor:
      isReelsScreen
          ? Colors.black
          : AppColors.white,

      body: screens[currentIndex],

      // =====================================
      // FLOATING NAVBAR
      // =====================================

      bottomNavigationBar: Padding(

        padding: const EdgeInsets.only(

          left: 18,

          right: 18,

          bottom: 10,
        ),

        child: ClipRRect(

          borderRadius:
          BorderRadius.circular(8),

          child: BackdropFilter(

            filter: ColorFilter.mode(
              Colors.black.withOpacity(0.02),
              BlendMode.srcOver,
            ),

            child: Container(

              height: 60,

              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(8),

                boxShadow: [

                  BoxShadow(

                    color:
                    Colors.black.withOpacity(
                      0.12,
                    ),

                    blurRadius: 18,

                    offset:
                    const Offset(0, 6),
                  ),
                ],
              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceAround,

                children: [

                  // HOME
                  _navItem(
                    icon: Iconsax.home_1,
                    index: 0,
                  ),

                  // REELS
                  _navItem(
                    icon: Iconsax.video_play,
                    index: 1,
                  ),

                  // CENTER BUTTON
                  GestureDetector(

                    onTap: () {

                      setState(() {

                        currentIndex = 2;
                      });
                    },

                    child: Container(

                      height: 45,

                      width: 45,

                      decoration:
                      const BoxDecoration(

                        color:
                        AppColors.primary,

                        shape:
                        BoxShape.circle,
                      ),

                      child: const Icon(

                        Icons.add,

                        color:
                        Colors.white,

                        size: 30,
                      ),
                    ),
                  ),

                  // MESSAGE
                  _navItem(
                    icon: Iconsax.message,
                    index: 3,
                  ),

                  // PROFILE
                  _navItem(
                    icon: Iconsax.user,
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =====================================
  // NAV ITEM
  // =====================================

  Widget _navItem({

    required IconData icon,

    required int index,
  }) {

    final bool isSelected =
        currentIndex == index;

    return GestureDetector(

      onTap: () {

        setState(() {

          currentIndex = index;
        });
      },

      child: AnimatedContainer(

        duration: const Duration(
          milliseconds: 250,
        ),

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(

          color: isSelected
              ? AppColors.primary
              .withOpacity(0.12)
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(14),
        ),

        child: Icon(

          icon,

          size: 24,

          color: isSelected
              ? AppColors.primary
              : Colors.grey.shade600,
        ),
      ),
    );
  }
}