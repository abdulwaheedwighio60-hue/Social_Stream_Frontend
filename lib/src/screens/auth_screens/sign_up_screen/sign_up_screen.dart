import 'package:flutter/material.dart';

import 'package:social_stream/src/constants/app_images.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/auth_screens/sign_up_screen/complete_profile_screen.dart';
import 'package:social_stream/src/utils/media_query.dart';
import 'package:social_stream/src/widgets/custom_elevated_button_widget.dart';
import 'package:social_stream/src/widgets/custom_text_form_field_widget.dart';
import 'package:social_stream/src/widgets/social_icon_button_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState
    extends State<SignUpScreen> {

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
  nameController =
  TextEditingController();

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  // =========================
  // VARIABLES
  // =========================
  bool obscurePassword = true;
  bool agreeTerms = true;

  @override
  void dispose() {

    nameController.dispose();
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

      body: SafeArea(

        child: SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),

          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
              screenWidth * 0.07,

              vertical:
              screenHeight * 0.015,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  SizedBox(
                    height:
                    screenHeight * 0.030,
                  ),

                  // =========================
                  // TITLE
                  // =========================
                  Text(
                    "Create Account",

                    style: textStyle
                        .headlineMedium
                        ?.copyWith(
                      fontSize: 28,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.012,
                  ),

                  Text(
                    "Fill your information below or register\nwith your social account.",

                    textAlign:
                    TextAlign.center,

                    style: textStyle
                        .bodyMedium
                        ?.copyWith(
                      color:
                      AppColors
                          .textSecondary,

                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.045,
                  ),

                  // =========================
                  // NAME
                  // =========================
                  Align(
                    alignment:
                    Alignment.centerLeft,

                    child: Text(
                      "Name",

                      style: textStyle
                          .titleMedium
                          ?.copyWith(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.010,
                  ),

                  CustomTextFormFieldWidget(
                    controller:
                    nameController,

                    hintText:
                    "Ex. John Doe",

                    fillColor:
                    AppColors.background,

                    borderRadius: 10,

                    keyboardType:
                    TextInputType.name,

                    textInputAction:
                    TextInputAction.next,

                    validator: (value) {

                      if (value ==
                          null ||
                          value
                              .trim()
                              .isEmpty) {

                        return "Name is required";
                      }

                      return null;
                    },
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.025,
                  ),

                  // =========================
                  // EMAIL
                  // =========================
                  Align(
                    alignment:
                    Alignment.centerLeft,

                    child: Text(
                      "Email",

                      style: textStyle
                          .titleMedium
                          ?.copyWith(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.010,
                  ),

                  CustomTextFormFieldWidget(
                    controller:
                    emailController,

                    hintText:
                    "example@gmail.com",

                    fillColor:
                    AppColors.background,

                    borderRadius: 10,

                    keyboardType:
                    TextInputType.emailAddress,

                    textInputAction:
                    TextInputAction.next,

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
                  Align(
                    alignment:
                    Alignment.centerLeft,

                    child: Text(
                      "Password",

                      style: textStyle
                          .titleMedium
                          ?.copyWith(
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.010,
                  ),

                  CustomTextFormFieldWidget(
                    controller:
                    passwordController,

                    hintText:
                    "••••••••••••",

                    obscureText:
                    obscurePassword,

                    fillColor:
                    AppColors.background,

                    borderRadius: 10,

                    textInputAction:
                    TextInputAction.done,

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
                    screenHeight * 0.020,
                  ),

                  // =========================
                  // TERMS & CONDITIONS
                  // =========================
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,

                    children: [

                      GestureDetector(
                        onTap: () {

                          setState(() {

                            agreeTerms =
                            !agreeTerms;
                          });
                        },

                        child: Container(
                          height: 20,
                          width: 20,

                          decoration:
                          BoxDecoration(
                            color:
                            agreeTerms
                                ? AppColors
                                .primary
                                : Colors
                                .transparent,

                            borderRadius:
                            BorderRadius
                                .circular(
                              4,
                            ),

                            border:
                            Border.all(
                              color:
                              AppColors
                                  .primary,
                            ),
                          ),

                          child:
                          agreeTerms
                              ? const Icon(
                            Icons.check,
                            size: 14,
                            color:
                            AppColors
                                .white,
                          )
                              : null,
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [

                              TextSpan(
                                text:
                                "Agree with ",

                                style:
                                textStyle
                                    .bodyMedium
                                    ?.copyWith(
                                  color:
                                  AppColors
                                      .black,
                                ),
                              ),

                              TextSpan(
                                text:
                                "Terms & Condition",

                                style:
                                textStyle
                                    .bodyMedium
                                    ?.copyWith(
                                  color:
                                  AppColors
                                      .primary,

                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.035,
                  ),

                  // =========================
                  // SIGN UP BUTTON
                  // =========================
                  CustomElevatedButtonWidget(
                    text: "Sign Up",

                    borderRadius:
                    100,

                    onPressed: () {

                      if (_formKey
                          .currentState!
                          .validate()) {

                        if (!agreeTerms) {

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(

                            const SnackBar(
                              content: Text(
                                "Please agree to terms & conditions",
                              ),
                            ),
                          );

                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CompleteProfileScreen(
                              userName: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.040,
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
                          horizontal: 12,
                        ),

                        child: Text(
                          "Or sign up with",

                          style:
                          textStyle
                              .bodyMedium
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
                    screenHeight * 0.035,
                  ),

                  // =========================
                  // SOCIAL BUTTONS
                  // =========================
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      SocialIconButtonWidget(
                        imagePath:
                        AppImages.appleIcon,

                        onTap: () {},
                      ),

                      SizedBox(
                        width:
                        screenWidth * 0.045,
                      ),

                      SocialIconButtonWidget(
                        imagePath:
                        AppImages.googleIcon,

                        onTap: () {},
                      ),

                      SizedBox(
                        width:
                        screenWidth * 0.045,
                      ),

                      SocialIconButtonWidget(
                        imagePath:
                        AppImages.facebookIcon,

                        onTap: () {},
                      ),
                    ],
                  ),

                  SizedBox(
                    height:
                    screenHeight * 0.050,
                  ),

                  // =========================
                  // SIGN IN
                  // =========================
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      Text(
                        "Already have an account?",

                        style: textStyle
                            .bodyMedium
                            ?.copyWith(
                          color:
                          AppColors
                              .darkGrey,

                          fontWeight:
                          FontWeight
                              .w500,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },

                        child: Text(
                          " Sign In",

                          style: textStyle
                              .bodyMedium
                              ?.copyWith(
                            color:
                            AppColors
                                .primary,

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