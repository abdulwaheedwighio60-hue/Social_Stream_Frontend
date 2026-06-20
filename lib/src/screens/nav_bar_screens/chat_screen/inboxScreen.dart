import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/nav_bar_screens/chat_screen/chat_detail_screen.dart';
import 'package:social_stream/src/screens/nav_bar_screens/chat_screen/widget/chat_user_widget.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:social_stream/src/widgets/custom_circle_icon_widget.dart';
import 'package:social_stream/src/widgets/custom_text_widget.dart';


class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomCircleIconWidget(
              icon: Icons.arrow_back_rounded,
              onTap: (){}
          ),
        ),
        title: CustomTextWidget(
          text: "Chat",
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomCircleIconWidget(
                icon: Iconsax.search_normal,
                onTap: (){}
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.020,),
          SizedBox(
            height: 110,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context,index){
                  return ChatUserWidget();
                }
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.030,
                    vertical: screenHeight * 0.010,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.030,),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatDetailScreen(
                                userName: "Carla Scheon",
                                userImage: "assets/images/user_image1.jpg",
                                isOnline: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryDark.withValues(alpha: 0.08),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              /// Profile Image + Online Indicator
                              Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        "assets/images/user_image1.jpg",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 12),

                              /// Name + Last Message
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextWidget(
                                      text: "Carla Scheon",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomTextWidget(
                                      text: "Your last message goes here...",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkGrey.withValues(alpha: 0.6),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              /// Time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomTextWidget(
                                    text: "09:34 PM",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryDark.withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}