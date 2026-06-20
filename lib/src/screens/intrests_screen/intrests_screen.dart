import 'package:flutter/material.dart';
import 'package:social_stream/root_screen.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/nav_bar_screens/home_screen/home_screen.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:social_stream/src/widgets/custom_elevated_button_widget.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() =>
      _InterestsScreenState();
}

class _InterestsScreenState
    extends State<InterestsScreen> {

  // =========================
  // SELECTED INTERESTS
  // =========================
  final List<String> selectedInterests =
  [];

  // =========================
  // INTERESTS LIST
  // =========================
  final List<Map<String, dynamic>>
  interests = [

    {
      "title": "Gaming",
      "icon": Icons.sports_esports,
    },

    {
      "title": "Music",
      "icon": Icons.music_note,
    },

    {
      "title": "Book",
      "icon": Icons.menu_book,
    },

    {
      "title": "Language",
      "icon": Icons.language,
    },

    {
      "title": "Photography",
      "icon": Icons.camera_alt,
    },

    {
      "title": "Fashion",
      "icon": Icons.checkroom,
    },

    {
      "title": "Nature",
      "icon": Icons.eco,
    },

    {
      "title": "GYM",
      "icon": Icons.fitness_center,
    },

    {
      "title": "Animal",
      "icon": Icons.pets,
    },

    {
      "title": "Arts",
      "icon": Icons.palette,
    },

    {
      "title": "Football",
      "icon": Icons.sports_soccer,
    },

    {
      "title": "Finance",
      "icon": Icons.attach_money,
    },

    {
      "title": "Technology",
      "icon": Icons.memory,
    },

    {
      "title": "Business",
      "icon": Icons.business_center,
    },

    {
      "title": "Travel",
      "icon": Icons.flight,
    },

    {
      "title": "Cars",
      "icon": Icons.directions_car,
    },
  ];

  // =========================
  // SELECT INTEREST
  // =========================
  void toggleInterest(
      String interest,
      ) {

    setState(() {

      if (selectedInterests
          .contains(interest)) {

        selectedInterests
            .remove(interest);

      } else {

        if (selectedInterests.length <
            5) {

          selectedInterests.add(
            interest,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final textTheme =
        Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor:
      const Color(0xffF8F8F8),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
            screenWidth * 0.06,

            vertical:
            screenHeight * 0.015,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // =========================
              // BACK BUTTON
              // =========================
              Container(
                height: 42,
                width: 42,

                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,

                  border: Border.all(
                    color:
                    AppColors.divider,
                  ),
                ),

                child: IconButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  icon: const Icon(
                    Icons
                        .arrow_back_ios_new,
                    size: 18,
                    color:
                    AppColors.black,
                  ),
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.045,
              ),

              // =========================
              // TITLE
              // =========================
              Center(
                child: Column(
                  children: [

                    Text(
                      "Select up to 5 interests",

                      textAlign:
                      TextAlign.center,

                      style: textTheme
                          .headlineMedium
                          ?.copyWith(
                        fontSize: 28,
                        fontWeight:
                        FontWeight
                            .w700,
                      ),
                    ),

                    SizedBox(
                      height:
                      screenHeight *
                          0.015,
                    ),

                    Text(
                      "Discover meaningful connections by selecting your favorite interests.",

                      textAlign:
                      TextAlign.center,

                      style: textTheme
                          .bodyMedium
                          ?.copyWith(
                        color:
                        AppColors
                            .textSecondary,

                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.050,
              ),

              // =========================
              // INTERESTS
              // =========================
              Expanded(
                child: SingleChildScrollView(
                  physics:
                  const BouncingScrollPhysics(),

                  child: Wrap(
                    spacing: 12,
                    runSpacing: 14,

                    children: interests.map((
                        interest,
                        ) {

                      final bool isSelected =
                      selectedInterests
                          .contains(
                        interest["title"],
                      );

                      return GestureDetector(
                        onTap: () {

                          toggleInterest(
                            interest["title"],
                          );
                        },

                        child: AnimatedContainer(
                          duration:
                          const Duration(
                            milliseconds:
                            250,
                          ),

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                            18,
                            vertical:
                            12,
                          ),

                          decoration:
                          BoxDecoration(
                            color:
                            isSelected
                                ? AppColors
                                .primary
                                : AppColors
                                .white,

                            borderRadius:
                            BorderRadius.circular(
                              100,
                            ),

                            border:
                            Border.all(
                              color:
                              isSelected
                                  ? AppColors
                                  .primary
                                  : AppColors
                                  .divider,
                            ),

                            boxShadow:
                            isSelected
                                ? [
                              BoxShadow(
                                color: AppColors
                                    .primary
                                    .withOpacity(
                                  0.20,
                                ),

                                blurRadius:
                                12,

                                offset:
                                const Offset(
                                  0,
                                  4,
                                ),
                              ),
                            ]
                                : [],
                          ),

                          child: Row(
                            mainAxisSize:
                            MainAxisSize
                                .min,

                            children: [

                              Icon(
                                interest[
                                "icon"],

                                size: 18,

                                color:
                                isSelected
                                    ? AppColors
                                    .white
                                    : AppColors
                                    .textSecondary,
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              Text(
                                interest[
                                "title"],

                                style: textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color:
                                  isSelected
                                      ? AppColors
                                      .white
                                      : AppColors
                                      .textSecondary,

                                  fontWeight:
                                  FontWeight
                                      .w600,

                                  fontSize:
                                  14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.030,
              ),

              // =========================
              // SELECTED COUNT
              // =========================
              Center(
                child: Text(
                  "${selectedInterests.length}/5 Selected",

                  style: textTheme.bodyMedium
                      ?.copyWith(
                    color:
                    AppColors.primary,

                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.020,
              ),

              // =========================
              // BUTTON
              // =========================
              CustomElevatedButtonWidget(
                text: "Next",

                borderRadius: 100,

                onPressed: () {

                  if (selectedInterests
                      .isNotEmpty) {

                    // Navigate
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => RootScreen(),
                    ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}