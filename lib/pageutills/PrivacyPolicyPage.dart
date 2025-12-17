import 'package:flutter/material.dart';
import '../../consts.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool _isAppBarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo is ScrollUpdateNotification) {
            setState(() {
              _isAppBarCollapsed = scrollInfo.metrics.pixels > 100;
            });
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: _HeaderSection(),
                title: _isAppBarCollapsed
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 8),
                          Text("Privacy Policy"),
                        ],
                      )
                    : null,
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
              ),
              pinned: true,
              floating: true,
              snap: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Last Updated
                        Text(
                          'Last updated: August 28, 2025',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                        const SizedBox(height: 24),

                        // Introduction
                        _buildIntroductionSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Information We Collect
                        _buildInformationWeCollectSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // How We Use Your Information
                        _buildHowWeUseSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Sharing Your Information
                        _buildSharingInformationSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Location Data
                        _buildLocationDataSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Security
                        _buildSecuritySection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Children's Privacy
                        _buildChildrenPrivacySection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Changes to Policy
                        _buildChangesSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Contact Us
                        _buildContactSection(context),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Privacy Policy describes how TRY MULTIVENTURE PRIVATE LIMITED trading as To Rent You ("Company", "We", "Us", or "Our") collects, uses, and protects your personal information when you use our application ("Service"). By using the Service, you agree to the terms described in this Privacy Policy.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildInformationWeCollectSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Information We Collect'),
        const SizedBox(height: 12),
        Text(
          'When you use our Service, we may collect the following personal data:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          icon: Icons.phone_android,
          title: 'Mobile Number',
          description:
              'Required for login and signup via OTP (One-Time Password).',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.person,
          title: 'Personal Information',
          description:
              'Name, Address (including City, State, Postal Code).',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.payment,
          title: 'Payment Information',
          description:
              'Payment details used when purchasing plans or making transactions. All payments are processed securely through our partner PhonePe.',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.location_on,
          title: 'Location Data',
          description:
              'With your permission, we collect your current location during product uploads to detect and display the correct product location.',
        ),
      ],
    );
  }

  Widget _buildHowWeUseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'How We Use Your Information'),
        const SizedBox(height: 12),
        Text(
          'We use the collected data for the following purposes:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 16),
        _buildBulletPoint(
          context,
          'To authenticate users using OTP login and signup.',
        ),
        _buildBulletPoint(
          context,
          'To provide and maintain our Service.',
        ),
        _buildBulletPoint(
          context,
          'To register and manage your account.',
        ),
        _buildBulletPoint(
          context,
          'To process transactions and manage subscriptions.',
        ),
        _buildBulletPoint(
          context,
          'To improve and personalize your experience.',
        ),
        _buildBulletPoint(
          context,
          'To communicate with you about updates and offers.',
        ),
      ],
    );
  }

  Widget _buildSharingInformationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Sharing Your Information'),
        const SizedBox(height: 12),
        Text(
          'We may share your information in the following circumstances:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 16),
        _buildBulletPoint(
          context,
          'With Service Providers: Such as PhonePe for processing payments, and SMS/OTP service providers for authentication.',
        ),
        _buildBulletPoint(
          context,
          'For Legal Compliance: If required by law or government authorities.',
        ),
        _buildBulletPoint(
          context,
          'For Business Transfers: In case of a merger, acquisition, or sale of assets.',
        ),
        _buildBulletPoint(
          context,
          'With Your Consent: If you agree to share information for specific purposes.',
        ),
      ],
    );
  }

  Widget _buildLocationDataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Location Data'),
        const SizedBox(height: 12),
        Text(
          'We collect your location only while uploading products to help detect and display the correct product location.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'You may enable or disable location access through your device settings.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Security of Your Data'),
        const SizedBox(height: 12),
        Text(
          'We use commercially acceptable means to protect your personal information, including OTP authentication for login. However, no method of data transmission or storage is 100% secure, and we cannot guarantee absolute security.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildChildrenPrivacySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Children\'s Privacy'),
        const SizedBox(height: 12),
        Text(
          'Our Service is not directed at individuals under 13 years of age. We do not knowingly collect personal data from children.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildChangesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Changes to This Privacy Policy'),
        const SizedBox(height: 12),
        Text(
          'We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated July 30, 2023.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Contact Us'),
        const SizedBox(height: 12),
        Text(
          'If you have any questions about this Privacy Policy, you can contact us:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          context,
          icon: Icons.email,
          label: 'Email',
          value: 'support@torentyou.com',
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          context,
          icon: Icons.language,
          label: 'Website',
          value: 'https://torentyou.com/base/contact_us',
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryTextColor,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryTextColor,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
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

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryTextColor,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.privacy_tip,
                size: 60,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
    );
  }
}