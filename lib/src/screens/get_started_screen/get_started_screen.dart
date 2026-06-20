import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/onboarding_screen/onboarding_screen.dart';
import 'package:social_stream/src/theme/app_theme.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:social_stream/src/widgets/custom_elevated_button_widget.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.030,
            vertical: screenHeight * 0.010,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.030,),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppImages.appLogo,
                      width: 140,
                    ),
                    SizedBox(height: screenHeight * 0.020,),
                    Image.asset(
                      AppImages.onboardingImage,
                      width: double.infinity,
                      height: screenHeight * 0.45,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: screenHeight * 0.020,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your Premier ",
                          style: textStyle.headlineMedium,
                        ),

                        Text(
                          "Social",
                          style: textStyle.headlineMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Connection App",
                      style: textStyle.headlineMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015,),
                    Text(
                      "Connect With People Around The World,Share Your Moments Instantly,And Discover What’s Trending Everyday",
                      textAlign: TextAlign.center,
                      style: textStyle.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.020,),
                    CustomElevatedButtonWidget(
                        text: "Let's Get Started",
                        borderRadius: 100,
                        onPressed: (){
                          Navigator.pushReplacement(
                            context, MaterialPageRoute(
                            builder: (context)=>
                                OnboardingScreen(),
                          ),
                          );
                        }
                    ),
                    SizedBox(height: screenHeight * 0.010,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an Account?  ",
                          textAlign: TextAlign.center,
                          style: textStyle.titleMedium?.copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Sign In",
                          style: textStyle.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
