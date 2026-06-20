import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/screens/auth_screens/sign_in_screen/sign_in_screen.dart';
import 'package:social_stream/src/screens/get_started_screen/get_started_screen.dart';
import 'package:social_stream/src/screens/onboarding_screen/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
          () {

        // Navigate Screen
        // Example:

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const GetStartedScreen(),
          ),
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.appLogo,
                width: 230,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
