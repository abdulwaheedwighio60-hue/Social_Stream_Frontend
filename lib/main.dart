import 'package:social_stream/src/provider/user_detail_provider.dart';
import 'package:social_stream/src/screens/nav_bar_screens/home_screen/update_post_screen.dart';
import 'package:social_stream/src/screens/privacy_polocy_screen/privacy_policy_screen.dart';
import 'package:social_stream/src/screens/splash_screen/splash_screen.dart';
import 'package:social_stream/src/services/like_provider.dart';
import 'package:social_stream/src/services/post_provider.dart';
import 'package:social_stream/src/services/user_authentication.dart';
import 'package:social_stream/src/theme/app_theme.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserDetailProvider(),
        ),
        ChangeNotifierProvider(
            create: (context) => UserAuthentication(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LikeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'SocialStream',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

