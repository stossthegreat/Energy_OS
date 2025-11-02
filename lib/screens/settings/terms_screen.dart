import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: November 1, 2025',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using Energy OS ("the App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.',
            ),
            _buildSection(
              '2. Use of the App',
              'Energy OS is designed to help you optimize your nutrition, fitness, and overall well-being. You agree to use the App for lawful purposes only and in accordance with these Terms.',
            ),
            _buildSection(
              '3. User Accounts',
              'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.',
            ),
            _buildSection(
              '4. Health Disclaimer',
              'Energy OS provides general health and wellness information. This information is not medical advice and should not be treated as such. Always consult with a qualified healthcare professional before making any health-related decisions.',
            ),
            _buildSection(
              '5. Data Collection and Privacy',
              'We collect and process your personal data as described in our Privacy Policy. By using the App, you consent to such collection and processing.',
            ),
            _buildSection(
              '6. Intellectual Property',
              'All content, features, and functionality of the App are owned by Energy OS and are protected by international copyright, trademark, and other intellectual property laws.',
            ),
            _buildSection(
              '7. Termination',
              'We reserve the right to terminate or suspend your account and access to the App at our sole discretion, without notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties.',
            ),
            _buildSection(
              '8. Limitation of Liability',
              'To the maximum extent permitted by law, Energy OS shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the App.',
            ),
            _buildSection(
              '9. Changes to Terms',
              'We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the new Terms in the App. Your continued use of the App after such changes constitutes acceptance of the new Terms.',
            ),
            _buildSection(
              '10. Contact Us',
              'If you have any questions about these Terms, please contact us at support@energyos.app',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

