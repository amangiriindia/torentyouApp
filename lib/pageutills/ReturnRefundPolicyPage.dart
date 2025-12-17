import 'package:flutter/material.dart';
import '../../consts.dart';

class ReturnRefundPolicyPage extends StatefulWidget {
  const ReturnRefundPolicyPage({Key? key}) : super(key: key);

  @override
  _ReturnRefundPolicyPageState createState() => _ReturnRefundPolicyPageState();
}

class _ReturnRefundPolicyPageState extends State<ReturnRefundPolicyPage> {
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
                          Text("Return & Refund Policy"),
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

                        // No Shipping Policy
                        _buildNoShippingSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Subscription Refunds
                        _buildSubscriptionRefundsSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Non-Refundable Items
                        _buildNonRefundableSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Refund Process
                        _buildRefundProcessSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Cancellation Policy
                        _buildCancellationPolicySection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Payment Failures
                        _buildPaymentFailuresSection(context),
                        const SizedBox(height: 24),

                        const Divider(),

                        // Disputes
                        _buildDisputesSection(context),
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
          'This Return & Refund Policy describes the refund and cancellation policies of TRY MULTIVENTURE PRIVATE LIMITED trading as To Rent You ("Company", "We", "Us", or "Our") for our mobile application and services ("Service").',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'By using our Service, you agree to the terms described in this policy.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildNoShippingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'No Shipping Policy'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Important Notice',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'To Rent You is a digital platform that connects users for rental services. We do not ship any physical products. All transactions are conducted between users directly.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Any product exchanges, deliveries, or pickups are arranged directly between the renter and the product owner.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionRefundsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Subscription Refunds'),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.credit_card,
          title: 'Subscription Plans',
          description:
              'Subscription fees paid for premium plans are generally non-refundable. However, we may consider refund requests on a case-by-case basis.',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.schedule,
          title: 'Refund Timeline',
          description:
              'If approved, refunds will be processed within 7-10 business days to the original payment method used during purchase.',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          context,
          icon: Icons.check_circle_outline,
          title: 'Eligibility',
          description:
              'Refund requests must be made within 48 hours of purchase. Refunds are only considered for technical issues or unauthorized charges.',
        ),
      ],
    );
  }

  Widget _buildNonRefundableSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Non-Refundable Items'),
        const SizedBox(height: 12),
        Text(
          'The following are not eligible for refunds:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        _buildBulletPoint(
          context,
          'Completed subscription periods that have been fully utilized.',
        ),
        _buildBulletPoint(
          context,
          'Premium features or services that have already been accessed or used.',
        ),
        _buildBulletPoint(
          context,
          'Promotional or discounted subscriptions (unless otherwise stated).',
        ),
        _buildBulletPoint(
          context,
          'Refund requests made after the 48-hour window from purchase.',
        ),
        _buildBulletPoint(
          context,
          'Transactions between users (rentals arranged through the platform).',
        ),
      ],
    );
  }

  Widget _buildRefundProcessSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'How to Request a Refund'),
        const SizedBox(height: 12),
        Text(
          'To request a refund, please follow these steps:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 16),
        _buildStepCard(context, '1', 'Contact Support',
            'Email us at support@torentyou.com or use the contact form in the app.'),
        const SizedBox(height: 12),
        _buildStepCard(context, '2', 'Provide Details',
            'Include your transaction ID, purchase date, and reason for the refund request.'),
        const SizedBox(height: 12),
        _buildStepCard(context, '3', 'Wait for Review',
            'Our team will review your request within 2-3 business days.'),
        const SizedBox(height: 12),
        _buildStepCard(context, '4', 'Receive Response',
            'You will be notified via email about the status of your refund request.'),
      ],
    );
  }

  Widget _buildCancellationPolicySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Cancellation Policy'),
        const SizedBox(height: 12),
        _buildBulletPoint(
          context,
          'You can cancel your subscription at any time through the app settings.',
        ),
        _buildBulletPoint(
          context,
          'Cancellation will take effect at the end of the current billing period.',
        ),
        _buildBulletPoint(
          context,
          'No refund will be provided for the remaining days in the current subscription period.',
        ),
        _buildBulletPoint(
          context,
          'You will continue to have access to premium features until the end of the paid period.',
        ),
        _buildBulletPoint(
          context,
          'Auto-renewal will be disabled upon cancellation.',
        ),
      ],
    );
  }

  Widget _buildPaymentFailuresSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Payment Failures & Errors'),
        const SizedBox(height: 12),
        Text(
          'If you experience a payment failure or error:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
        ),
        const SizedBox(height: 16),
        _buildBulletPoint(
          context,
          'If payment is deducted but subscription is not activated, contact us immediately with transaction details.',
        ),
        _buildBulletPoint(
          context,
          'We will investigate and resolve the issue within 24-48 hours.',
        ),
        _buildBulletPoint(
          context,
          'Refunds for failed transactions will be processed within 7-10 business days.',
        ),
        _buildBulletPoint(
          context,
          'For payment gateway issues, you may also need to contact PhonePe support.',
        ),
      ],
    );
  }

  Widget _buildDisputesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(text: 'Disputes Between Users'),
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
                      'Platform Limitation',
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
                'To Rent You is a connecting platform. We do not process payments between users for rental transactions. Any disputes regarding rental items, quality, condition, or agreements must be resolved directly between the renter and the product owner.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'We encourage users to communicate clearly and document agreements to avoid disputes.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
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
          'If you have any questions about this Return & Refund Policy, please contact us:',
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

  Widget _buildStepCard(
    BuildContext context,
    String stepNumber,
    String title,
    String description,
  ) {
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryTextColor,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                Icons.assignment_return,
                size: 60,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Return & Refund Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
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