import 'package:flutter/material.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/utils/media_query.dart';

class ChatUserWidget extends StatefulWidget {
  const ChatUserWidget({super.key});

  @override
  State<ChatUserWidget> createState() => _ChatUserWidgetState();
}

class _ChatUserWidgetState extends State<ChatUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.015,
        vertical: screenHeight * 0.010,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// PROFILE
          Stack(
            children: [

              Container(
                padding: const EdgeInsets.all(2),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.7),
                    width: 2,
                  ),
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),

                  child: Image.asset(
                    "assets/images/user_image1.jpg",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// ONLINE DOT
              Positioned(
                bottom: 4,
                right: 4,

                child: Container(
                  width: 14,
                  height: 14,

                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //SizedBox(height: screenHeight * 0.005),

          /// NAME
          SizedBox(
            child: Text(
              "Jenny Smith",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}