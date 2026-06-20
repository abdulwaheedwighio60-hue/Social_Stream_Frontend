import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart' show AppColors;
import 'package:social_stream/src/models/onboarding_model.dart';
import 'package:social_stream/src/screens/auth_screens/sign_in_screen/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  int currentIndex = 0;

  final List<OnboardingModel> onboardingList = [
    OnboardingModel(
      title: "Explore Profiles",
      subTitle:
      "Discover amazing people, explore profiles, and build meaningful connections worldwide.",
      image: AppImages.onboardingImage1,
    ),
    OnboardingModel(
      title: "Connect Easily",
      subTitle:
      "Find and connect with friends and communities instantly with just one tap.",
      image: AppImages.onboardingImage1,
    ),
    OnboardingModel(
      title: "Start Chatting",
      subTitle:
      "Send messages, share moments, and enjoy real-time conversations anytime.",
      image: AppImages.onboardingImage1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),

        child: SafeArea(
          child: PageView.builder(
            controller: _controller,
            itemCount: onboardingList.length,

            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },

            itemBuilder: (context, index) {
              return Stack(
                children: [

                  /// 🔥 TOP IMAGE
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,

                      padding: const EdgeInsets.only(
                        top: 140,
                        left: 30,
                        right: 30,
                      ),

                      child: SizedBox(
                        height: height * 0.42,
                        child: Image.asset(
                          onboardingList[index].image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  /// 🔥 SKIP BUTTON
                  Positioned(
                    top: 10,
                    right: 20,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context)=> SignInScreen(),
                        ),
                        );
                        print("Skip");
                      },
                      child: Text(
                        "Skip",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  /// 🔥 CURVED CONTAINER
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: BottomWaveClipper(),
                      child: Container(
                        height: height * 0.50,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            30,
                            95,
                            30,
                            30,
                          ),

                          child: Column(
                            children: [

                              /// 🔥 TITLE
                              AnimatedSwitcher(
                                duration:
                                const Duration(milliseconds: 400),

                                child: RichText(
                                  key: ValueKey(
                                    onboardingList[index].title,
                                  ),

                                  textAlign: TextAlign.center,

                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      //height: 1.3,
                                      color: Colors.black,
                                    ),

                                    children: [
                                      TextSpan(
                                        text:
                                        "${onboardingList[index].title} ",
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                        ),
                                      ),

                                      const TextSpan(
                                        text:
                                        "with SocialStream",
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              /// 🔥 SUBTITLE
                              AnimatedSwitcher(
                                duration:
                                const Duration(milliseconds: 400),

                                child: Text(
                                  onboardingList[index].subTitle,

                                  key: ValueKey(
                                    onboardingList[index].subTitle,
                                  ),

                                  textAlign: TextAlign.center,

                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              /// 🔥 PAGE INDICATORS
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,

                                children: List.generate(
                                  onboardingList.length,
                                      (dotIndex) => AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 300,
                                    ),

                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),

                                    height: 8,

                                    width: currentIndex == dotIndex
                                        ? 24
                                        : 8,

                                    decoration: BoxDecoration(
                                      color: currentIndex == dotIndex
                                          ? AppColors.primary
                                          : Colors.grey.shade300,

                                      borderRadius:
                                      BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              /// 🔥 BOTTOM BUTTONS
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,

                                children: [

                                  /// PREVIOUS BUTTON
                                  AnimatedOpacity(
                                    duration: const Duration(
                                      milliseconds: 300,
                                    ),

                                    opacity:
                                    currentIndex == 0 ? 0.4 : 1,

                                    child: _buildNavButton(
                                      icon: Icons
                                          .arrow_back_ios_new_rounded,

                                      isPrimary: false,

                                      onTap: () {
                                        if (currentIndex > 0) {
                                          _controller.previousPage(
                                            duration:
                                            const Duration(
                                              milliseconds: 400,
                                            ),
                                            curve:
                                            Curves.easeInOut,
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                  /// NEXT BUTTON
                                  _buildNavButton(
                                    icon: currentIndex ==
                                        onboardingList.length -
                                            1
                                        ? Icons.check_rounded
                                        : Icons
                                        .arrow_forward_ios_rounded,

                                    isPrimary: true,

                                    onTap: () {
                                      if (currentIndex <
                                          onboardingList.length -
                                              1) {
                                        _controller.nextPage(
                                          duration:
                                          const Duration(
                                            milliseconds: 400,
                                          ),
                                          curve:
                                          Curves.easeInOut,
                                        );
                                      } else {

                                        /// 🔥 NAVIGATE
                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute(
                                            builder: (context)=> SignInScreen(),
                                        ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔥 NAVIGATION BUTTON
  Widget _buildNavButton({
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary
              : Colors.white,

          shape: BoxShape.circle,

          border: Border.all(
            color: isPrimary
                ? AppColors.primary
                : Colors.grey.shade300,
          ),

          boxShadow: [
            if (isPrimary)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),

        child: Icon(
          icon,
          size: 20,
          color: isPrimary
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}

/// 🔥 CUSTOM WAVE CLIPPER
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);


    path.quadraticBezierTo(
      size.width / 2,
      80,
      size.width,
      0,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}