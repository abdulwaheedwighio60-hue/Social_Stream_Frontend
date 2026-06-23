import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_stream/src/constants/colors.dart';
import 'package:social_stream/src/widgets/custom_circle_icon_widget.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() =>
      _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState
    extends State<PrivacyPolicyScreen> {
  static const String _lastUpdated =
      'June 22, 2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leadingWidth: 62,
        leading: Padding(
          padding: const EdgeInsets.all(
            10.0
          ),
          child: CustomCircleIconWidget(
            icon: CupertinoIcons.arrow_left,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            35,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeaderCard(),

              const SizedBox(height: 18),

              _buildPolicySection(
                icon: CupertinoIcons.person_crop_circle,
                title: 'Information We Collect',
                description:
                'We may collect information that you provide directly when creating an account, updating your profile, publishing posts, sending messages, or contacting support.',
                points: const <String>[
                  'Name, username, email address and phone number.',
                  'Profile image, biography and account details.',
                  'Posts, comments, reactions, images and other content.',
                  'Device information, IP address and application usage.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.settings,
                title: 'How We Use Your Information',
                description:
                'The collected information is used to operate, maintain and improve the Social Stream application.',
                points: const <String>[
                  'Create and manage your account.',
                  'Display your profile and published content.',
                  'Provide social features such as likes and comments.',
                  'Improve application security and performance.',
                  'Respond to support requests and user feedback.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.share,
                title: 'Information Sharing',
                description:
                'We do not sell or rent your personal information. Information may only be shared when required to provide the service, comply with legal obligations or protect users.',
                points: const <String>[
                  'With trusted service providers used by the application.',
                  'When required by law or a valid legal request.',
                  'To prevent fraud, abuse or security threats.',
                  'With your permission or at your direction.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.lock_shield,
                title: 'Data Security',
                description:
                'We use reasonable administrative and technical measures to protect your information. However, no online service can guarantee complete security.',
                points: const <String>[
                  'Secure authentication and protected API access.',
                  'Restricted access to personal information.',
                  'Monitoring for suspicious or unauthorized activity.',
                  'Regular improvements to security practices.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.photo,
                title: 'Images and Media',
                description:
                'Images and media uploaded to the application may be stored using third-party cloud storage services.',
                points: const <String>[
                  'Uploaded media may be processed or compressed.',
                  'Media may remain cached temporarily after removal.',
                  'Users must only upload content they are authorized to share.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.location,
                title: 'Location Information',
                description:
                'Location details are only collected when you voluntarily add a location to your profile or post.',
                points: const <String>[
                  'Location information is not required for normal usage.',
                  'You can avoid sharing a location when publishing content.',
                  'Previously shared location details can be removed by editing the post.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.person_2,
                title: 'Your Rights and Choices',
                description:
                'You can manage your account information and published content through the application.',
                points: const <String>[
                  'Update your profile information.',
                  'Edit or delete your own posts.',
                  'Control the information you share publicly.',
                  'Request account deletion or data assistance.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.person_badge_minus,
                title: 'Account Deletion',
                description:
                'You may request deletion of your account. Some information may be retained when required for legal, security or operational purposes.',
                points: const <String>[
                  'Your profile may no longer be visible after deletion.',
                  'Published content may be removed from active systems.',
                  'Backup copies may remain temporarily.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.cloud,
                title: 'Third-Party Services',
                description:
                'The application may use third-party services for hosting, media storage, notifications, analytics or authentication.',
                points: const <String>[
                  'Third-party services may process limited technical data.',
                  'Their use of information is governed by their own policies.',
                  'We only use services required to operate the application.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.person_crop_circle_badge_exclam,
                title: 'Children’s Privacy',
                description:
                'The application is not intended for children who are below the minimum legal age required to use online services in their region.',
                points: const <String>[
                  'We do not knowingly collect information from children.',
                  'Parents or guardians may contact us regarding such information.',
                ],
              ),

              _buildPolicySection(
                icon: CupertinoIcons.refresh,
                title: 'Changes to This Policy',
                description:
                'We may update this privacy policy when our services, legal requirements or privacy practices change.',
                points: const <String>[
                  'The updated policy will be available in the application.',
                  'The latest revision date will appear at the top.',
                  'Continued use may indicate acceptance of the updated policy.',
                ],
              ),

              _buildContactCard(),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  '© 2026 Social Stream. All rights reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER CARD
  // =========================================================

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppColors.primary,
            AppColors.primary.withOpacity(0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withOpacity(0.20),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              CupertinoIcons.shield_lefthalf_fill,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(height: 17),

          const Text(
            'Your Privacy Matters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'This policy explains how Social Stream collects, uses and protects your information.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.90),
              fontSize: 13,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  CupertinoIcons.calendar,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 7),
                Text(
                  'Last updated: $_lastUpdated',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // POLICY SECTION
  // =========================================================

  Widget _buildPolicySection({
    required IconData icon,
    required String title,
    required String description,
    required List<String> points,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                  AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),

          if (points.isNotEmpty) ...<Widget>[
            const SizedBox(height: 13),

            ...points.map(
                  (String point) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 9,
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(
                          top: 7,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // CONTACT CARD
  // =========================================================

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                CupertinoIcons.mail,
                color: AppColors.primary,
                size: 23,
              ),
              SizedBox(width: 10),
              Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'For privacy-related questions, account deletion or data requests, contact our support team.',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: <Widget>[
                Icon(
                  CupertinoIcons.envelope,
                  color: AppColors.primary,
                  size: 18,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'support@socialstream.com',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}