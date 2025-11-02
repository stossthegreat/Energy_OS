import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/gradient_button.dart';

class DeactivateAccountScreen extends ConsumerStatefulWidget {
  const DeactivateAccountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeactivateAccountScreen> createState() =>
      _DeactivateAccountScreenState();
}

class _DeactivateAccountScreenState
    extends ConsumerState<DeactivateAccountScreen> {
  String? _selectedReason;
  final _feedbackController = TextEditingController();
  bool _isLoading = false;

  final List<String> _reasons = [
    'Taking a break',
    'Privacy concerns',
    'Not useful anymore',
    'Too expensive',
    'Found a better alternative',
    'Other',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _handleDeactivate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Confirm Deactivation'),
        content: const Text(
          'Are you sure you want to deactivate your account? Your data will be preserved and you can reactivate anytime by logging back in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Call deactivate account API
      // For now, just sign out
      await ref.read(authServiceProvider).signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deactivated successfully'),
          backgroundColor: Color(0xFFf59e0b),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deactivate Account'),
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
            // Warning
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFf59e0b).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFf59e0b).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFf59e0b),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Deactivating your account will temporarily disable your profile and data.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // What happens
            const Text(
              'What happens when you deactivate?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoItem('Your profile will be hidden from other users'),
            _buildInfoItem('You won\'t receive notifications'),
            _buildInfoItem('Your data will be preserved'),
            _buildInfoItem('You can reactivate anytime by logging back in'),

            const SizedBox(height: 32),

            // Reason
            const Text(
              'Why are you leaving? (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...List<Widget>.generate(_reasons.length, (index) {
              final reason = _reasons[index];
              return RadioListTile<String>(
                value: reason,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() => _selectedReason = value);
                },
                title: Text(
                  reason,
                  style: const TextStyle(color: Colors.white),
                ),
                activeColor: const Color(0xFFf59e0b),
              );
            }),

            const SizedBox(height: 20),

            // Feedback
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Additional Feedback',
                hintText: 'Tell us more...',
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Deactivate Button
            GradientButton(
              text: 'Deactivate Account',
              onPressed: _handleDeactivate,
              gradientColors: const ['#f59e0b', '#f97316'],
              icon: Icons.remove_circle_outline,
              isLoading: _isLoading,
            ),

            const SizedBox(height: 16),

            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Never mind, keep my account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.white.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

