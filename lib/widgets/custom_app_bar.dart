import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsTap;
  final VoidCallback onInboxTap;
  final int unreadCount;

  const CustomAppBar({
    Key? key,
    required this.onSettingsTap,
    required this.onInboxTap,
    this.unreadCount = 0,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - App name and tagline
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.4),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'ENERGY OS',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Your Biological Operating System',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            
            // Right side - Time and icons
            Row(
              children: [
                // Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('h:mm a').format(now),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('EEE, MMM d').format(now),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.4),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Inbox icon with badge
                Stack(
                  children: [
                    IconButton(
                      onPressed: onInboxTap,
                      icon: const Icon(Icons.inbox_outlined),
                      color: Colors.white,
                      iconSize: 24,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFf43f5e),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                
                // Settings icon
                IconButton(
                  onPressed: onSettingsTap,
                  icon: const Icon(Icons.settings_outlined),
                  color: Colors.white,
                  iconSize: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

