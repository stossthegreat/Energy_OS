import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data for demonstration
    final messages = [
      {
        'title': 'Recovery Alert',
        'message': 'Your body recovered 8% faster than usual. Great job!',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'type': 'success',
        'isRead': false,
      },
      {
        'title': 'Fuel Reminder',
        'message': 'Time for your pre-workout meal. Your energy bowl is ready.',
        'time': DateTime.now().subtract(const Duration(hours: 5)),
        'type': 'info',
        'isRead': false,
      },
      {
        'title': 'Training Complete',
        'message': 'Upper Body Power session completed. 45min, 892 kcal burned.',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'success',
        'isRead': true,
      },
      {
        'title': 'Sleep Quality Report',
        'message': 'Last night: 7.5hrs, 94% quality. Your best week yet!',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'info',
        'isRead': true,
      },
    ];

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
          'Inbox',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Mark all as read
            },
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
      body: messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageCard(
                  message['title'] as String,
                  message['message'] as String,
                  message['time'] as DateTime,
                  message['type'] as String,
                  message['isRead'] as bool,
                );
              },
            ),
    );
  }

  Widget _buildMessageCard(
    String title,
    String message,
    DateTime time,
    String type,
    bool isRead,
  ) {
    Color accentColor;
    IconData icon;

    switch (type) {
      case 'success':
        accentColor = const Color(0xFF34d399);
        icon = Icons.check_circle_outline;
        break;
      case 'warning':
        accentColor = const Color(0xFFfbbf24);
        icon = Icons.warning_amber_outlined;
        break;
      case 'error':
        accentColor = const Color(0xFFf43f5e);
        icon = Icons.error_outline;
        break;
      default:
        accentColor = const Color(0xFF8b5cf6);
        icon = Icons.info_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isRead
            ? Colors.white.withOpacity(0.03)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isRead
              ? Colors.white.withOpacity(0.05)
              : accentColor.withOpacity(0.3),
          width: isRead ? 1 : 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // TODO: Open message detail
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isRead
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(time),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }
}

