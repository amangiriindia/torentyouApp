import 'package:flutter/material.dart';
import '../../consts.dart';

class TermsConditionsPage extends StatefulWidget {
  const TermsConditionsPage({Key? key}) : super(key: key);

  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
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
                          Text("Terms & Conditions"),
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

                        // Account Registration
                        _buildAccountRegistrationSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // User Responsibilities
                        _buildUserResponsibilitiesSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Posting Ads
                        _buildPostingAdsSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Prohibited Activities
                        _buildProhibitedActivitiesSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Payment & Subscription
                        _buildPaymentSubscriptionSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Intellectual Property
                        _buildIntellectualPropertySection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Limitation of Liability
                        _buildLimitationOfLiabilitySection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Termination
                        _buildTerminationSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Changes to Terms
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
          'Welcome to To Rent You! These Terms and Conditions ("Terms") govern your use of our mobile application and services ("Service") provided by TRY MULTIVENTURE PRIVATE LIMITED. By accessing or using the Service, you agree to be bound by these Terms. If you do not agree with these Terms, please do not use the Service.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildAccountRegistrationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Account Registration'),
        const SizedBox(height: 12),
        _buildBulletPoint(
          context,
          'You must provide accurate and complete information during registration.',
        ),
        _buildBulletPoint(
          context,
          'You are responsible for maintaining the confidentiality of your account credentials.',
        ),
        _buildBulletPoint(
          context,
          'You must be at least 13 years old to use the Service.',
        ),
        _buildBulletPoint(
          context,
          'You agree to notify us immediately of any unauthorized use of your account.',
        ),
      ],
    );
  }

  Widget _buildUserResponsibilitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'User Responsibilities'),
        const SizedBox(height: 12),
        Text(
          'As a user of To Rent You, you agree to:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 12),
        _buildBulletPoint(
          context,
          'Use the Service only for lawful purposes and in accordance with these Terms.',
        ),
        _buildBulletPoint(
          context,
          'Provide accurate information in all listings and communications.',
        ),
        _buildBulletPoint(
          context,
          'Respect the intellectual property rights of others.',
        ),
        _buildBulletPoint(
          context,
          'Not engage in any activity that could harm, disrupt, or interfere with the Service.',
        ),
        _buildBulletPoint(
          context,
          'Comply with all applicable local, state, and national laws.',
        ),
      ],
    );
  }

  Widget _buildPostingAdsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Posting Ads and Listings'),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.verified_user,
          title: 'Content Ownership',
          description:
              'You retain ownership of the content you post, but grant us a license to use, display, and distribute it through our Service.',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.rule,
          title: 'Content Guidelines',
          description:
              'All listings must be accurate, complete, and not misleading. You must have the right to rent or offer the items/services listed.',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.block,
          title: 'Prohibited Content',
          description:
              'We reserve the right to remove any content that violates these Terms or is deemed inappropriate.',
        ),
      ],
    );
  }

  Widget _buildProhibitedActivitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Prohibited Activities'),
        const SizedBox(height: 12),
        Text(
          'You may not:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        _buildBulletPoint(
          context,
          'Post false, misleading, or fraudulent listings.',
        ),
        _buildBulletPoint(
          context,
          'Use the Service to harass, threaten, or harm others.',
        ),
        _buildBulletPoint(
          context,
          'Attempt to gain unauthorized access to our systems or user accounts.',
        ),
        _buildBulletPoint(
          context,
          'Use automated systems or bots to access the Service.',
        ),
        _buildBulletPoint(
          context,
          'Collect or harvest personal information from other users.',
        ),
        _buildBulletPoint(
          context,
          'Engage in any illegal activities or promote illegal products/services.',
        ),
      ],
    );
  }

  Widget _buildPaymentSubscriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Payment & Subscription'),
        const SizedBox(height: 12),
        _buildBulletPoint(
          context,
          'All payments are processed securely through our payment partner PhonePe.',
        ),
        _buildBulletPoint(
          context,
          'Subscription fees are non-refundable except as required by law.',
        ),
        _buildBulletPoint(
          context,
          'You can cancel your subscription at any time through the app settings.',
        ),
        _buildBulletPoint(
          context,
          'We reserve the right to change subscription pricing with advance notice.',
        ),
        _buildBulletPoint(
          context,
          'Failure to pay subscription fees may result in service suspension.',
        ),
      ],
    );
  }

  Widget _buildIntellectualPropertySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Intellectual Property'),
        const SizedBox(height: 12),
        Text(
          'The Service, including its design, logo, graphics, and content, is owned by TRY MULTIVENTURE PRIVATE LIMITED and protected by copyright and trademark laws. You may not copy, modify, distribute, or create derivative works without our express written permission.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildLimitationOfLiabilitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Limitation of Liability'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Important Notice',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'TRY MULTIVENTURE PRIVATE LIMITED (To Rent You) is a platform that connects users. We are not responsible for:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 8),
              _buildBulletPoint(
                context,
                'The quality, safety, or legality of items or services listed.',
              ),
              _buildBulletPoint(
                context,
                'The accuracy of user listings or communications.',
              ),
              _buildBulletPoint(
                context,
                'Any disputes between users.',
              ),
              _buildBulletPoint(
                context,
                'Damages arising from your use of the Service.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTerminationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Termination'),
        const SizedBox(height: 12),
        Text(
          'We reserve the right to suspend or terminate your account at any time for:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 12),
        _buildBulletPoint(
          context,
          'Violation of these Terms and Conditions.',
        ),
        _buildBulletPoint(
          context,
          'Fraudulent or illegal activity.',
        ),
        _buildBulletPoint(
          context,
          'Abuse of the Service or other users.',
        ),
        _buildBulletPoint(
          context,
          'Non-payment of subscription fees.',
        ),
        const SizedBox(height: 12),
        Text(
          'You may delete your account at any time by contacting us through the app or visiting our contact page.',
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
        _SectionHeader(text: 'Changes to These Terms'),
        const SizedBox(height: 12),
        Text(
          'We may update these Terms from time to time. We will notify you of any material changes by posting the new Terms on this page and updating the "Last updated" date. Your continued use of the Service after changes are posted constitutes acceptance of the revised Terms.',
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
          'If you have any questions about these Terms and Conditions, you can contact us:',
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
                Icons.description,
                size: 60,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 24,
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