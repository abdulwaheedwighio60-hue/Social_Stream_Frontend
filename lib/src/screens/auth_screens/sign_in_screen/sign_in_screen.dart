import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_stream/root_screen.dart';

import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/auth_screens/sign_up_screen/sign_up_screen.dart';
import 'package:social_stream/src/services/user_authentication.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:social_stream/src/widgets/app_snack_bar.dart';
import 'package:social_stream/src/widgets/custom_elevated_button_widget.dart';
import 'package:social_stream/src/widgets/custom_text_form_field_widget.dart';
import 'package:social_stream/src/widgets/social_icon_button_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() =>
      _SignInScreenState();
}

class _SignInScreenState
    extends State<SignInScreen> {

  // =========================
  // FORM KEY
  // =========================
  final GlobalKey<FormState>
  _formKey =
  GlobalKey<FormState>();

  // =========================
  // CONTROLLERS
  // =========================
  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  // =========================
  // PASSWORD VISIBILITY
  // =========================
  bool obscurePassword = true;

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final textStyle =
        Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor:
      AppColors.white,

      appBar: AppBar(
        backgroundColor:
        Colors.transparent,

        elevation: 0,
        scrolledUnderElevation: 0,

        surfaceTintColor:
        Colors.transparent,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),

          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
              screenWidth * 0.06,

              vertical:
              screenHeight * 0.010,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  SizedBox(
                    height:
                    screenHeight * 0.010,
                  ),

                  // =========================
                  // TITLE SECTION
                  // =========================
                  Center(
                    child: Column(
                      children: [

                        Text(
                          "Sign In",

                          style: textStyle
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
                          "Welcome back! Continue your social journey.",

                          textAlign:
                          TextAlign.center,

                          style: textStyle
                              .titleMedium
                              ?.copyWith(
                            fontSize:
                            15,

                            fontWeight:
                            FontWeight
                                .w400,

                            color:
                            AppColors
                                .textSecondary,

                            height:
                            1.6,
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
                  // EMAIL
                  // =========================
                  Text(
                    "Email",

                    style: textStyle
                        .titleMedium
                        ?.copyWith(
                      fontSize: 15,

                      fontWeight:
                      FontWeight
                          .w600,
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.008,
                  ),

                  CustomTextFormFieldWidget(
                    controller:
                    emailController,

                    hintText:
                    "example@gmail.com",

                    keyboardType:
                    TextInputType
                        .emailAddress,

                    textInputAction:
                    TextInputAction
                        .next,

                    fillColor:
                    AppColors
                        .background,

                    borderRadius: 8,

                    prefixIcon:
                    const Icon(
                      Icons
                          .email_outlined,

                      color:
                      AppColors
                          .textSecondary,
                    ),

                    validator: (value) {

                      if (value ==
                          null ||
                          value
                              .trim()
                              .isEmpty) {

                        return "Email is required";
                      }

                      return null;
                    },
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.025,
                  ),

                  // =========================
                  // PASSWORD
                  // =========================
                  Text(
                    "Password",

                    style: textStyle
                        .titleMedium
                        ?.copyWith(
                      fontSize: 15,

                      fontWeight:
                      FontWeight
                          .w600,
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.008,
                  ),

                  CustomTextFormFieldWidget(
                    controller:
                    passwordController,

                    hintText:
                    "Enter Password",

                    obscureText:
                    obscurePassword,

                    textInputAction:
                    TextInputAction
                        .done,

                    fillColor:
                    AppColors
                        .background,

                    borderRadius: 8,

                    prefixIcon:
                    const Icon(
                      Icons
                          .lock_outline,

                      color:
                      AppColors
                          .textSecondary,
                    ),

                    suffixIcon:
                    GestureDetector(
                      onTap: () {

                        setState(() {

                          obscurePassword =
                          !obscurePassword;
                        });
                      },

                      child: Icon(
                        obscurePassword
                            ? Icons
                            .visibility_off_outlined
                            : Icons
                            .visibility_outlined,

                        color:
                        AppColors
                            .textSecondary,
                      ),
                    ),

                    validator: (value) {

                      if (value ==
                          null ||
                          value
                              .trim()
                              .isEmpty) {

                        return "Password is required";
                      }

                      return null;
                    },
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.018,
                  ),

                  // =========================
                  // FORGOT PASSWORD
                  // =========================
                  Align(
                    alignment:
                    Alignment
                        .centerRight,

                    child:
                    GestureDetector(
                      onTap: () {},

                      child: Text(
                        "Forgot Password?",

                        style: textStyle
                            .titleMedium
                            ?.copyWith(
                          color:
                          AppColors
                              .primary,

                          fontSize:
                          14,

                          fontWeight:
                          FontWeight
                              .w600,

                          decoration:
                          TextDecoration
                              .underline,

                          decorationColor:
                          AppColors
                              .primary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.035,
                  ),

                  // =========================
                  // SIGN IN BUTTON
                  // =========================
                  CustomElevatedButtonWidget(

                    text: "Sign In",

                    borderRadius: 100,

                    onPressed: () async {
                      // Keyboard close
                      FocusManager.instance.primaryFocus?.unfocus();

                      // Form validation
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        return;
                      }

                      final authProvider = Provider.of<UserAuthentication>(
                        context,
                        listen: false,
                      );

                      try {
                        final response = await authProvider.loginUser(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context: context,
                        );

                        // Await ke baad context use karne se pehle mounted check
                        if (!mounted) return;

                        final bool isSuccess = response["success"] == true;

                        // =====================================================
                        // LOGIN SUCCESS
                        // =====================================================

                        if (isSuccess) {
                          final String successMessage =
                              response["data"]?["message"]?.toString().trim() ?? '';

                          AppSnackBar.showSuccess(
                            context,
                            message: successMessage.isNotEmpty
                                ? successMessage
                                : 'You have logged in successfully.',
                          );

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const RootScreen(),
                            ),
                          );

                          return;
                        }

                        // =====================================================
                        // LOGIN FAILED
                        // =====================================================

                        final String errorMessage =
                            response["message"]?.toString().trim() ?? '';

                        AppSnackBar.showError(
                          context,
                          message: errorMessage.isNotEmpty
                              ? errorMessage
                              : 'Login failed. Please check your email and password.',
                        );
                      } catch (error, stackTrace) {
                        debugPrint('Login error: $error');
                        debugPrintStack(stackTrace: stackTrace);

                        if (!mounted) return;

                        AppSnackBar.showError(
                          context,
                          message:
                          'Unable to log in right now. Please check your connection and try again.',
                        );
                      }
                    },
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.035,
                  ),

                  // =========================
                  // DIVIDER
                  // =========================
                  Row(
                    children: [

                      const Expanded(
                        child: Divider(
                          color:
                          AppColors
                              .divider,
                        ),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal:
                          12,
                        ),

                        child: Text(
                          "Or Sign in with",

                          style:
                          textStyle
                              .titleSmall
                              ?.copyWith(
                            color:
                            AppColors
                                .textSecondary,
                          ),
                        ),
                      ),

                      const Expanded(
                        child: Divider(
                          color:
                          AppColors
                              .divider,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.030,
                  ),

                  // =========================
                  // SOCIAL BUTTONS
                  // =========================
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: [

                      SocialIconButtonWidget(
                        imagePath:
                        AppImages
                            .appleIcon,

                        onTap: () {},
                      ),

                      SizedBox(
                        width:
                        screenWidth *
                            0.040,
                      ),

                      SocialIconButtonWidget(
                        imagePath:
                        AppImages
                            .googleIcon,

                        onTap: () {},
                      ),

                      SizedBox(
                        width:
                        screenWidth *
                            0.040,
                      ),

                      SocialIconButtonWidget(
                        imagePath:
                        AppImages
                            .facebookIcon,

                        onTap: () {},
                      ),
                    ],
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.050,
                  ),

                  // =========================
                  // SIGN UP
                  // =========================
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: [

                      Text(
                        "Don't have an account?",

                        style: textStyle
                            .titleMedium
                            ?.copyWith(
                          color:
                          AppColors
                              .darkGrey,

                          fontSize:
                          14,

                          fontWeight:
                          FontWeight
                              .w500,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context)=>
                                  SignUpScreen()
                          ),
                          );
                        },

                        child: Text(
                          " Sign Up",

                          style: textStyle
                              .titleMedium
                              ?.copyWith(
                            color:
                            AppColors
                                .primary,

                            fontSize:
                            14,

                            fontWeight:
                            FontWeight
                                .w600,

                            decoration:
                            TextDecoration
                                .underline,

                            decorationColor:
                            AppColors
                                .primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.030,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}