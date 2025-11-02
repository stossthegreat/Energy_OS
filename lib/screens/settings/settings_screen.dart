import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            userData.when(
              data: (user) => user != null ? _buildProfileHeader(context, user) : const SizedBox(),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 8),

            // Settings List
            _buildSection(
              context,
              'Account',
              [
                _buildTile(
                  context,
                  Icons.person_outline,
                  'Profile Settings',
                  'Edit your personal information',
                  () {
                    // TODO: Navigate to profile settings
                  },
                ),
                _buildTile(
                  context,
                  Icons.security,
                  'Account & Security',
                  'Password, email, and authentication',
                  () {
                    // TODO: Navigate to account security
                  },
                ),
              ],
            ),

            _buildSection(
              context,
              'Preferences',
              [
                _buildTile(
                  context,
                  Icons.notifications_outlined,
                  'Notifications',
                  'Manage your notification settings',
                  () {
                    // TODO: Navigate to notifications
                  },
                ),
                _buildTile(
                  context,
                  Icons.privacy_tip_outlined,
                  'Privacy',
                  'Data sharing and visibility',
                  () {
                    // TODO: Navigate to privacy
                  },
                ),
              ],
            ),

            _buildSection(
              context,
              'Support',
              [
                _buildTile(
                  context,
                  Icons.help_outline,
                  'Help Center',
                  'Get help and support',
                  () {
                    // TODO: Open help center
                  },
                ),
                _buildTile(
                  context,
                  Icons.feedback_outlined,
                  'Send Feedback',
                  'Tell us what you think',
                  () {
                    // TODO: Open feedback form
                  },
                ),
              ],
            ),

            _buildSection(
              context,
              'Legal',
              [
                _buildTile(
                  context,
                  Icons.article_outlined,
                  'Terms of Service',
                  'Read our terms',
                  () {
                    // TODO: Navigate to terms
                  },
                ),
                _buildTile(
                  context,
                  Icons.shield_outlined,
                  'Privacy Policy',
                  'How we handle your data',
                  () {
                    // TODO: Navigate to privacy policy
                  },
                ),
              ],
            ),

            _buildSection(
              context,
              'Account Management',
              [
                _buildTile(
                  context,
                  Icons.logout,
                  'Sign Out',
                  'Sign out of your account',
                  () async {
                    final confirmed = await _showConfirmDialog(
                      context,
                      'Sign Out',
                      'Are you sure you want to sign out?',
                    );
                    if (confirmed) {
                      await ref.read(authServiceProvider).signOut();
                    }
                  },
                ),
                _buildTile(
                  context,
                  Icons.remove_circle_outline,
                  'Deactivate Account',
                  'Temporarily disable your account',
                  () {
                    // TODO: Navigate to deactivate account
                  },
                  color: Colors.orange,
                ),
                _buildTile(
                  context,
                  Icons.delete_forever,
                  'Delete Account',
                  'Permanently delete your account and data',
                  () {
                    // TODO: Navigate to delete account
                  },
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Version
            Text(
              'Energy OS v1.0.0',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.1),
            child: Text(
              user.name?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf59e0b).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.premiumTier?.toUpperCase() ?? 'FREE',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFf59e0b),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to profile edit
            },
            icon: const Icon(Icons.edit_outlined),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 12),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.4),
              letterSpacing: 1.5,
            ),
          ),
        ),
        ...tiles,
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color? color,
  }) {
    final tileColor = color ?? Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: tileColor.withOpacity(0.8)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: tileColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: tileColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: tileColor.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

