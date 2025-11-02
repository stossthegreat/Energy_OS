import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              '1. Information We Collect',
              'We collect information you provide directly to us, including your name, email address, profile information, health metrics (weight, height, age), meal data, workout data, sleep data, and other information you choose to provide.',
            ),
            _buildSection(
              '2. How We Use Your Information',
              'We use the information we collect to provide, maintain, and improve our services, personalize your experience, generate insights and recommendations, communicate with you, and ensure the security of our services.',
            ),
            _buildSection(
              '3. Information Sharing',
              'We do not sell your personal information. We may share your information with service providers who perform services on our behalf, if required by law, or with your consent.',
            ),
            _buildSection(
              '4. Data Security',
              'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
            ),
            _buildSection(
              '5. Data Retention',
              'We retain your personal information for as long as necessary to provide you with our services and as described in this Privacy Policy. You can request deletion of your account and data at any time.',
            ),
            _buildSection(
              '6. Your Rights',
              'You have the right to access, correct, or delete your personal information. You can also object to or restrict certain processing of your data. To exercise these rights, please contact us.',
            ),
            _buildSection(
              '7. Cookies and Tracking',
              'We use cookies and similar tracking technologies to track activity on our App and hold certain information. You can control the use of cookies through your device settings.',
            ),
            _buildSection(
              '8. Children\'s Privacy',
              'Our App is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),
            _buildSection(
              '9. International Data Transfers',
              'Your information may be transferred to and processed in countries other than your country of residence. We ensure appropriate safeguards are in place to protect your information.',
            ),
            _buildSection(
              '10. Changes to Privacy Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the App.',
            ),
            _buildSection(
              '11. Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at privacy@energyos.app',
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

