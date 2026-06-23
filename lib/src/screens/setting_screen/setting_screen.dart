import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/screens/help_center_screen/help_center_screen.dart';
import 'package:social_stream/src/screens/payment_method_screen/payment_method_screen.dart';
import 'package:social_stream/src/screens/privacy_polocy_screen/privacy_policy_screen.dart';
import 'package:social_stream/src/widgets/custom_circle_icon_widget.dart';
import 'package:social_stream/src/widgets/custom_text_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  bool notificationSwitch = true;
  bool darkModeSwitch = false;
  bool biometricSwitch = true;

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.transparent,

        centerTitle: true,

        leading: Padding(

          padding: const EdgeInsets.all(10),

          child: CustomCircleIconWidget(

            icon: Icons.arrow_back,

            onTap: () {

              Navigator.pop(context);
            },
          ),
        ),

        title: const CustomTextWidget(

          text: "Settings",

          fontWeight: FontWeight.w700,

          fontSize: 18,
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),

        child: Column(

          children: [

            // =========================================================
            // PROFILE CARD
            // =========================================================

            Container(

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(24),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black.withOpacity(0.04),

                    blurRadius: 12,

                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Row(

                children: [

                  Container(

                    width: 65,
                    height: 65,

                    decoration: BoxDecoration(

                      shape: BoxShape.circle,

                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),

                    child: ClipOval(

                      child: Image.network(

                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330",

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(

                          "Brooklyn Simmons",

                          style:
                          textTheme.titleMedium?.copyWith(

                            fontSize: 17,

                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(

                          "brooklyn@gmail.com",

                          style:
                          textTheme.bodySmall?.copyWith(

                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),

                          decoration: BoxDecoration(

                            color:
                            AppColors.primary.withOpacity(0.1),

                            borderRadius:
                            BorderRadius.circular(100),
                          ),

                          child: const Text(

                            "Premium User",

                            style: TextStyle(

                              color: AppColors.primary,

                              fontSize: 11,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(

                    width: 45,
                    height: 45,

                    decoration: BoxDecoration(

                      color:
                      AppColors.primary.withOpacity(0.08),

                      borderRadius:
                      BorderRadius.circular(14),
                    ),

                    child: const Icon(

                      Iconsax.edit,

                      color: AppColors.primary,

                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =========================================================
            // ACCOUNT
            // =========================================================

            _buildSectionTitle(
              title: "Account",
            ),

            const SizedBox(height: 14),

            _buildSettingsCard(

              children: [

                _buildTile(

                  icon: Iconsax.user,

                  title: "Manage Account",

                  subtitle:
                  "Profile information and settings",

                  onTap: () {},
                ),

                _divider(),

                _buildTile(

                  icon: Iconsax.lock,

                  title: "Privacy",

                  subtitle:
                  "Control account visibility",

                  onTap: () {},
                ),

                _divider(),

                _buildTile(

                  icon: Iconsax.security_safe,

                  title: "Security",

                  subtitle:
                  "Password and authentication",

                  onTap: () {},
                ),

                _divider(),

                _buildTile(

                  icon: Iconsax.card,

                  title: "Payment Methods",

                  subtitle:
                  "Manage cards and billing",

                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => PaymentMethodScreen(),
                    ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 28),

            // =========================================================
            // PREFERENCES
            // =========================================================

            _buildSectionTitle(
              title: "Preferences",
            ),

            const SizedBox(height: 14),

            _buildSettingsCard(

              children: [

                _buildSwitchTile(

                  icon: Iconsax.notification,

                  title: "Push Notifications",

                  value: notificationSwitch,

                  onChanged: (value) {

                    setState(() {

                      notificationSwitch = value;
                    });
                  },
                ),

                _divider(),

                _buildSwitchTile(

                  icon: Icons.dark_mode_outlined,

                  title: "Dark Mode",

                  value: darkModeSwitch,

                  onChanged: (value) {

                    setState(() {

                      darkModeSwitch = value;
                    });
                  },
                ),

                _divider(),

                _buildSwitchTile(

                  icon: Icons.fingerprint,

                  title: "Biometric Login",

                  value: biometricSwitch,

                  onChanged: (value) {

                    setState(() {

                      biometricSwitch = value;
                    });
                  },
                ),

                _divider(),

                _buildTile(

                  icon: Iconsax.language_square,

                  title: "Language",

                  subtitle: "English (US)",

                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 28),

            // =========================================================
            // SUPPORT
            // =========================================================

            _buildSectionTitle(
              title: "Support",
            ),

            const SizedBox(height: 14),

            _buildSettingsCard(

              children: [

                _buildTile(

                  icon: Iconsax.message_question,

                  title: "Help Center",

                  subtitle:
                  "FAQs and customer support",

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (context) =>
                        const HelpCenterScreen(),
                      ),
                    );
                  },
                ),

                _divider(),

                _buildTile(

                  icon: Iconsax.document_text,

                  title: "Terms & Conditions",

                  subtitle:
                  "Application policies and terms",

                  onTap: () {},
                ),

                _divider(),

                _buildTile(

                  icon: Iconsax.shield_tick,

                  title: "Privacy Policy",

                  subtitle:
                  "Your data and privacy rights",

                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => PrivacyPolicyScreen()
                    ),
                    );
                  },
                ),

                _divider(),

                _buildTile(

                  icon: Iconsax.info_circle,

                  title: "About App",

                  subtitle:
                  "Version 1.0.0",

                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),

            // =========================================================
            // LOGOUT BUTTON
            // =========================================================

            SizedBox(

              width: double.infinity,

              height: 56,

              child: ElevatedButton.icon(

                onPressed: () {},

                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),

                label: const Text(

                  "Logout",

                  style: TextStyle(

                    fontSize: 16,

                    fontWeight: FontWeight.w700,
                  ),
                ),

                style: ElevatedButton.styleFrom(

                  backgroundColor: AppColors.primary,

                  elevation: 0,

                  shape: RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _buildSectionTitle({
    required String title,
  }) {

    return Align(

      alignment: Alignment.centerLeft,

      child: Text(

        title,

        style: const TextStyle(

          fontSize: 16,

          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // =========================================================
  // SETTINGS CARD
  // =========================================================

  Widget _buildSettingsCard({
    required List<Widget> children,
  }) {

    return Container(

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.04),

            blurRadius: 12,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Padding(

        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),

        child: Column(
          children: children,
        ),
      ),
    );
  }

  // =========================================================
  // NORMAL TILE
  // =========================================================

  Widget _buildTile({

    required IconData icon,

    required String title,

    required String subtitle,

    required VoidCallback onTap,
  }) {

    return ListTile(

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 4,
      ),

      leading: Container(

        width: 48,
        height: 48,

        decoration: BoxDecoration(

          color:
          AppColors.primary.withOpacity(0.08),

          borderRadius:
          BorderRadius.circular(15),
        ),

        child: Icon(

          icon,

          color: AppColors.primary,

          size: 22,
        ),
      ),

      title: Text(

        title,

        style: const TextStyle(

          fontWeight: FontWeight.w600,

          fontSize: 15,
        ),
      ),

      subtitle: Padding(

        padding: const EdgeInsets.only(top: 4),

        child: Text(

          subtitle,

          style: TextStyle(

            color: Colors.grey.shade600,

            fontSize: 12,
          ),
        ),
      ),

      trailing: Icon(

        Icons.arrow_forward_ios_rounded,

        size: 18,

        color: Colors.grey.shade500,
      ),

      onTap: onTap,
    );
  }

  // =========================================================
  // SWITCH TILE
  // =========================================================

  Widget _buildSwitchTile({

    required IconData icon,

    required String title,

    required bool value,

    required ValueChanged<bool> onChanged,
  }) {

    return ListTile(

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 4,
      ),

      leading: Container(

        width: 48,
        height: 48,

        decoration: BoxDecoration(

          color:
          AppColors.primary.withOpacity(0.08),

          borderRadius:
          BorderRadius.circular(15),
        ),

        child: Icon(

          icon,

          color: AppColors.primary,

          size: 22,
        ),
      ),

      title: Text(

        title,

        style: const TextStyle(

          fontWeight: FontWeight.w600,

          fontSize: 15,
        ),
      ),

      trailing: Switch(

        value: value,

        activeColor: AppColors.primary,

        onChanged: onChanged,
      ),
    );
  }

  // =========================================================
  // DIVIDER
  // =========================================================

  Widget _divider() {

    return Divider(

      height: 1,

      color: Colors.grey.shade200,

      indent: 82,

      endIndent: 20,
    );
  }
}