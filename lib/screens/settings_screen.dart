import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Account',
              [
                _buildSettingTile(
                  'Profile',
                  Icons.person_outline,
                  () {},
                ),
                _buildSettingTile(
                  'Privacy',
                  Icons.lock_outline,
                  () {},
                ),
                _buildSettingTile(
                  'Notifications',
                  Icons.notifications_outlined,
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Data',
              [
                _buildSettingTile(
                  'Export Data',
                  Icons.download_outlined,
                  () {},
                ),
                _buildSettingTile(
                  'Sync Settings',
                  Icons.sync,
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Support',
              [
                _buildSettingTile(
                  'Help Center',
                  Icons.help_outline,
                  () {},
                ),
                _buildSettingTile(
                  'Contact Us',
                  Icons.email_outlined,
                  () {},
                ),
                _buildSettingTile(
                  'About',
                  Icons.info_outline,
                  () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Account Actions',
              [
                _buildSettingTile(
                  'Sign Out',
                  Icons.logout,
                  () {},
                  isDestructive: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.4),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive
                    ? const Color(0xFFf43f5e)
                    : Colors.white.withOpacity(0.6),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDestructive
                        ? const Color(0xFFf43f5e)
                        : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

