import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/nav_bar_screens/profile_screen/edit_profile_screen.dart';
import 'package:social_stream/src/screens/setting_screen/setting_screen.dart';
import 'package:social_stream/src/widgets/custom_text_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState
    extends State<UserProfileScreen> {

  int selectedTab = 0;

  final List<String> postImages = [

    "https://images.unsplash.com/photo-1496747611176-843222e1e57c",

    "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f",

    "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f",

    "https://images.unsplash.com/photo-1524504388940-b1c1722653e1",

    "https://images.unsplash.com/photo-1529139574466-a303027c1d8b",

    "https://images.unsplash.com/photo-1494790108377-be9c29b29330",

    "https://images.unsplash.com/photo-1524504388940-b1c1722653e1",

    "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
  ];

  @override
  Widget build(BuildContext context) {

    final textStyle =
        Theme.of(context).textTheme;

    return Scaffold(

      backgroundColor: Colors.white,

      body: SafeArea(

        child: Column(

          children: [

            // =====================================
            // FIXED TOP SECTION
            // =====================================

            Expanded(

              child: Column(

                children: [

                  // =====================================
                  // HEADER
                  // =====================================

                  Stack(

                    clipBehavior: Clip.none,

                    children: [

                      Container(

                        height: 150,
                        width: double.infinity,

                        decoration:
                        const BoxDecoration(

                          borderRadius:
                          BorderRadius.only(

                            bottomLeft:
                            Radius.circular(25),

                            bottomRight:
                            Radius.circular(25),
                          ),

                          image: DecorationImage(

                            image: NetworkImage(
                              "https://images.unsplash.com/photo-1517841905240-472988babdf9",
                            ),

                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // BACK BUTTON

                      Positioned(

                        top: 18,
                        left: 18,

                        child: _buildCircleButton(
                          onTab: (){},
                          icon:
                          Icons.arrow_back_ios_new,
                        ),
                      ),

                      // SETTINGS

                      Positioned(

                        top: 18,
                        right: 18,

                        child: _buildCircleButton(
                          onTab: (){
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context)=> SettingScreen())
                            );
                          },
                          icon: Icons.settings,

                        ),
                      ),

                      // PROFILE IMAGE

                      Positioned(

                        bottom: -50,
                        left: 0,
                        right: 0,

                        child: Center(

                          child: Container(

                            width: 105,
                            height: 105,

                            padding:
                            const EdgeInsets.all(4),

                            decoration: BoxDecoration(

                              color: Colors.white,

                              shape: BoxShape.circle,

                              boxShadow: [

                                BoxShadow(

                                  color:
                                  Colors.black.withOpacity(
                                    0.08,
                                  ),

                                  blurRadius: 10,
                                ),
                              ],
                            ),

                            child: const CircleAvatar(

                              backgroundImage:
                              NetworkImage(
                                "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // =====================================
                  // USER INFO
                  // =====================================

                  Text(

                    "Brooklyn Simmons",

                    style:
                    textStyle.titleLarge?.copyWith(

                      fontWeight:
                      FontWeight.w700,

                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(

                    "Fashion Designer",

                    style:
                    textStyle.bodyMedium?.copyWith(

                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      const Icon(

                        Icons.link,

                        color:
                        Color(0xffFF6B2C),

                        size: 18,
                      ),

                      const SizedBox(width: 5),

                      Text(

                        "www.example.com",

                        style: TextStyle(

                          color:
                          Colors.orange.shade700,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // =====================================
                  // STATS
                  // =====================================

                  Padding(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),

                    child: Row(

                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        Expanded(
                          child: _buildStatItem(
                            "542",
                            "Posts",
                          ),
                        ),

                        _buildDivider(),

                        Expanded(
                          child: _buildStatItem(
                            "45.6K",
                            "Followers",
                          ),
                        ),

                        _buildDivider(),

                        Expanded(
                          child: _buildStatItem(
                            "2K",
                            "Following",
                          ),
                        ),

                        _buildDivider(),

                        Expanded(
                          child: _buildStatItem(
                            "10M",
                            "Likes",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // =====================================
                  // BUTTONS
                  // =====================================

                  Padding(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),

                    child: Row(

                      children: [

                        Expanded(

                          child: ElevatedButton.icon(

                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) => EditProfileScreen()
                              ),
                              );
                            },

                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                            ),

                            label: const Text(
                              "Edit Profile",
                            ),

                            style:
                            ElevatedButton.styleFrom(

                              elevation: 0,

                              backgroundColor:
                              const Color(
                                0xffFF6B2C,
                              ),

                              foregroundColor:
                              Colors.white,

                              minimumSize:
                              const Size(
                                double.infinity,
                                45,
                              ),

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(
                                  5,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(

                          child: OutlinedButton.icon(

                            onPressed: () {},

                            icon: const Icon(
                              Iconsax.scan_barcode,
                              size: 18,
                            ),

                            label: const Text(
                              "QR Code",
                            ),

                            style:
                            OutlinedButton.styleFrom(

                              foregroundColor:
                              const Color(
                                0xffFF6B2C,
                              ),

                              side: const BorderSide(
                                color: Color(
                                  0xffFF6B2C,
                                ),
                              ),

                              minimumSize:
                              const Size(
                                double.infinity,
                                45,
                              ),

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(
                                  5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // =====================================
                  // TABS
                  // =====================================

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,

                    children: [

                      _buildTabItem(
                        index: 0,
                        icon:
                        Icons.grid_view_rounded,
                        title: "Feeds",
                      ),

                      _buildTabItem(
                        index: 1,
                        icon:
                        Iconsax.video,
                        title: "Shorts",
                      ),

                      _buildTabItem(
                        index: 2,
                        icon:
                        Iconsax.tag,
                        title: "Tagged",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // =====================================
                  // GRID ONLY SCROLL
                  // =====================================

                  Expanded(

                    child: GridView.builder(

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),

                      itemCount:
                      postImages.length,

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: 3,

                        crossAxisSpacing: 10,

                        mainAxisSpacing: 10,

                        childAspectRatio: 0.72,
                      ),

                      itemBuilder:
                          (context, index) {

                        return ClipRRect(

                          borderRadius:
                          BorderRadius.circular(
                            16,
                          ),

                          child: Image.network(

                            postImages[index],

                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================
  // TAB ITEM
  // =========================================

  Widget _buildTabItem({

    required int index,

    required IconData icon,

    required String title,

  }) {

    bool isSelected =
        selectedTab == index;

    return GestureDetector(

      onTap: () {

        setState(() {

          selectedTab = index;
        });
      },

      child: Column(

        children: [

          Row(

            children: [

              Icon(

                icon,

                size: 18,

                color: isSelected
                    ? const Color(0xffFF6B2C)
                    : Colors.grey,
              ),

              const SizedBox(width: 5),

              Text(

                title,

                style: TextStyle(

                  fontWeight:
                  FontWeight.w600,

                  color: isSelected
                      ? const Color(
                    0xffFF6B2C,
                  )
                      : Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          AnimatedContainer(

            duration:
            const Duration(milliseconds: 250),

            width: isSelected ? 70 : 0,

            height: 3,

            decoration: BoxDecoration(

              color:
              const Color(0xffFF6B2C),

              borderRadius:
              BorderRadius.circular(
                100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================
  // STAT ITEM
  // =========================================

  Widget _buildStatItem(
      String value,
      String title,
      ) {

    return Column(

      children: [

        CustomTextWidget(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),

        const SizedBox(height: 4),

        CustomTextWidget(
          text: title,
          fontSize: 12,
          color: Colors.grey,
        ),
      ],
    );
  }

  // =========================================
  // DIVIDER
  // =========================================

  Widget _buildDivider() {

    return Container(

      width: 1,
      height: 35,

      color: Colors.grey.shade300,
    );
  }

  // =========================================
  // CIRCLE BUTTON
  // =========================================

  Widget _buildCircleButton({

    required IconData icon,
    required VoidCallback onTab,

  }) {

    return GestureDetector(
      onTap: onTab,
      child: Container(

        width: 35,
        height: 35,

        decoration: BoxDecoration(

          color: Colors.white,

          shape: BoxShape.circle,

          boxShadow: [

            BoxShadow(

              color:
              Colors.black.withOpacity(
                0.06,
              ),

              blurRadius: 10,
            ),
          ],
        ),

        child: Icon(
          icon,
          size: 20,
        ),
      ),
    );
  }
}