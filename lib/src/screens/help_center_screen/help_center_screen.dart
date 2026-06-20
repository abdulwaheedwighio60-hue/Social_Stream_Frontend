import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/widgets/custom_circle_icon_widget.dart';
import 'package:social_stream/src/widgets/custom_text_widget.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() =>
      _HelpCenterScreenState();
}

class _HelpCenterScreenState
    extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  int selectedCategory = 0;

  int expandedFaqIndex = -1;

  final List<String> categories = [

    "All",

    "Services",

    "General",

    "Account",
  ];

  final List<Map<String, String>> faqList = [

    {
      "question":
      "Is this social media app free to use?",

      "answer":
      "Yes, our social media application is completely free to use for all users.",
    },

    {
      "question":
      "How can I unfollow a user?",

      "answer":
      "Open user profile and tap unfollow button.",
    },

    {
      "question":
      "How can I stay updated on new features?",

      "answer":
      "Enable app notifications from settings.",
    },

    {
      "question":
      "How can I verify my account on this app?",

      "answer":
      "Go to account settings and submit verification request.",
    },

    {
      "question":
      "How do I contact customer support?",

      "answer":
      "Use Contact Us section for support.",
    },

    {
      "question":
      "What if I encounter technical problems?",

      "answer":
      "Try restarting the app or contact support team.",
    },

    {
      "question":
      "How to add app review?",

      "answer":
      "You can review the app directly from Play Store or App Store.",
    },
  ];

  int expandedContactIndex = -1;

  @override
  void initState() {

    super.initState();

    _tabController =
        TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {

    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xffF8F8F8),

      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        leading: Padding(

          padding: const EdgeInsets.all(10),

          child: CustomCircleIconWidget(
            icon: Icons.arrow_back,
          ),
        ),

        title: const CustomTextWidget(
          text: "Help Center",
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),

      body: SafeArea(

        child: Column(

          children: [

            // =====================================
            // SEARCH FIELD
            // =====================================

            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),

              child: Container(

                height: 52,

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(16),
                ),

                child: TextFormField(

                  decoration: InputDecoration(

                    border: InputBorder.none,

                    hintText: "Search",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),

                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xffF97316),
                    ),
                  ),
                ),
              ),
            ),

            // =====================================
            // TAB BAR
            // =====================================

            Container(

              color: Colors.white,

              child: TabBar(

                controller: _tabController,

                dividerColor: Colors.transparent,

                indicatorColor:
                const Color(0xffF97316),

                indicatorWeight: 3,

                labelColor:
                const Color(0xffF97316),

                unselectedLabelColor:
                Colors.grey,

                tabs: const [

                  Tab(text: "FAQ"),

                  Tab(text: "Contact Us"),
                ],
              ),
            ),

            // =====================================
            // TAB VIEW
            // =====================================

            Expanded(

              child: TabBarView(

                controller: _tabController,

                children: [

                  // =================================
                  // FAQ TAB
                  // =================================

                  Column(

                    children: [

                      const SizedBox(height: 18),

                      // =============================
                      // CATEGORY FILTERS
                      // =============================

                      SizedBox(

                        height: 42,

                        child: ListView.builder(

                          scrollDirection:
                          Axis.horizontal,

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),

                          itemCount:
                          categories.length,

                          itemBuilder:
                              (context, index) {

                            final isSelected =
                                selectedCategory ==
                                    index;

                            return GestureDetector(

                              onTap: () {

                                setState(() {

                                  selectedCategory =
                                      index;
                                });
                              },

                              child: Container(

                                margin:
                                const EdgeInsets.only(
                                  right: 12,
                                ),

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),

                                decoration:
                                BoxDecoration(

                                  color: isSelected

                                      ? const Color(
                                    0xffF97316,
                                  )

                                      : Colors.white,

                                  borderRadius:
                                  BorderRadius.circular(
                                    30,
                                  ),
                                ),

                                child: Center(

                                  child: Text(

                                    categories[index],

                                    style: TextStyle(

                                      color: isSelected

                                          ? Colors.white

                                          : Colors.grey
                                          .shade700,

                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =============================
                      // FAQ LIST
                      // =============================

                      Expanded(

                        child: ListView.builder(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),

                          itemCount:
                          faqList.length,
                          itemBuilder:
                              (context, index) {
                            final faq =
                            faqList[index];
                            final isExpanded =
                                expandedFaqIndex ==
                                    index;
                            return Container(
                              margin:
                              const EdgeInsets.only(
                                bottom: 14,
                              ),

                              decoration:
                              BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                BorderRadius.circular(
                                  18,
                                ),

                                border: Border.all(
                                  color: Colors
                                      .grey.shade200,
                                ),
                              ),

                              child: Theme(

                                data:
                                Theme.of(context)
                                    .copyWith(
                                  dividerColor:
                                  Colors.transparent,
                                ),

                                child: ExpansionTile(

                                  initiallyExpanded:
                                  isExpanded,

                                  onExpansionChanged:
                                      (value) {

                                    setState(() {

                                      expandedFaqIndex =
                                      value
                                          ? index
                                          : -1;
                                    });
                                  },

                                  tilePadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),

                                  childrenPadding:
                                  const EdgeInsets.only(
                                    left: 18,
                                    right: 18,
                                    bottom: 18,
                                  ),

                                  iconColor:
                                  const Color(
                                    0xffF97316,
                                  ),

                                  collapsedIconColor:
                                  const Color(
                                    0xffF97316,
                                  ),

                                  title: Text(

                                    faq["question"] ??
                                        "",

                                    style:
                                    const TextStyle(

                                      fontWeight:
                                      FontWeight.w600,

                                      fontSize: 14,
                                    ),
                                  ),

                                  children: [

                                    Align(

                                      alignment:
                                      Alignment
                                          .centerLeft,

                                      child: Text(

                                        faq["answer"] ??
                                            "",

                                        style:
                                        TextStyle(

                                          color: Colors
                                              .grey
                                              .shade600,

                                          height: 1.5,

                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // =================================
                  // CONTACT US TAB
                  // =================================

                  ListView(

                    padding:
                    const EdgeInsets.all(18),

                    children: [

                      _buildContactTile(
                        index: 0,
                        icon:
                        Icons.headset_mic_outlined,
                        title: "Customer Service",
                      ),

                      _buildContactTile(
                        index: 1,
                        icon: Iconsax.message,
                        title: "WhatsApp",
                        subtitle:
                        "+1 (480) 555-0103",
                      ),

                      _buildContactTile(
                        index: 2,
                        icon: Icons.language,
                        title: "Website",
                        subtitle:
                        "www.example.com",
                      ),

                      _buildContactTile(
                        index: 3,
                        icon: Icons.facebook,
                        title: "Facebook",
                        subtitle:
                        "facebook.com/socialstream",
                      ),

                      _buildContactTile(
                        index: 4,
                        icon: Icons.travel_explore,
                        title: "Twitter",
                        subtitle:
                        "@socialstream",
                      ),

                      _buildContactTile(
                        index: 5,
                        icon: Icons.camera_alt,
                        title: "Instagram",
                        subtitle:
                        "@socialstream",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================
  // CONTACT TILE
  // ===================================

  Widget _buildContactTile({

    required int index,

    required IconData icon,

    required String title,

    String? subtitle,

  }) {

    final isExpanded =
        expandedContactIndex == index;

    return Container(

      margin: const EdgeInsets.only(
        bottom: 14,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Theme(

        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),

        child: ExpansionTile(

          initiallyExpanded: isExpanded,

          onExpansionChanged: (value) {

            setState(() {

              expandedContactIndex =
              value ? index : -1;
            });
          },

          tilePadding:
          const EdgeInsets.symmetric(
            horizontal: 18,
          ),

          childrenPadding:
          const EdgeInsets.only(
            left: 18,
            right: 18,
            bottom: 18,
          ),

          iconColor:
          const Color(0xffF97316),

          collapsedIconColor:
          const Color(0xffF97316),

          leading: Icon(
            icon,
            color: const Color(0xffF97316),
          ),

          title: Text(

            title,

            style: const TextStyle(

              fontWeight: FontWeight.w600,

              fontSize: 14,
            ),
          ),

          children: [

            if (subtitle != null)

              Align(

                alignment:
                Alignment.centerLeft,

                child: Text(

                  subtitle,

                  style: TextStyle(

                    color:
                    Colors.grey.shade600,

                    fontSize: 13,

                    height: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}