import 'package:flutter/material.dart';
import '../utils/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notifications data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'like',
      'title': 'New Like',
      'message': 'Alex liked your "Zombie Apocalypse" answer',
      'time': '2m ago',
      'isRead': false,
      'icon': Icons.favorite_rounded,
      'color': AppColors.primaryPink,
    },
    {
      'id': '2',
      'type': 'comment',
      'title': 'New Comment',
      'message': 'Sarah replied: "Haha totally agree! 😂"',
      'time': '1h ago',
      'isRead': false,
      'icon': Icons.chat_bubble_rounded,
      'color': AppColors.primaryBlue,
    },
    {
      'id': '3',
      'type': 'invite',
      'title': 'Squad Invite',
      'message': 'Mike invited you to join "The Night Owls"',
      'time': '3h ago',
      'isRead': true,
      'icon': Icons.group_add_rounded,
      'color': AppColors.primaryPurple,
    },
    {
      'id': '4',
      'type': 'system',
      'title': 'Daily Streak',
      'message': 'You\'re on a 5-day streak! Keep it up! 🔥',
      'time': '1d ago',
      'isRead': true,
      'icon': Icons.local_fire_department_rounded,
      'color': const Color(0xFFFF9500),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: Color(0xFFA1A1B5)),
            onPressed: () {
              // Mark all as read logic
              setState(() {
                for (var notification in _notifications) {
                  notification['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  backgroundColor: Color(0xFF1B263B),
                ),
              );
            },
            tooltip: 'Mark all as read',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF2D2D44),
            height: 1,
          ),
        ),
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_rounded,
                    size: 64,
                    color: const Color(0xFF2D2D44),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No new notifications',
                    style: TextStyle(
                      color: Color(0xFFA1A1B5),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _NotificationItem(
                  notification: notification,
                  onTap: () {
                    // Navigate to detail
                    setState(() {
                      notification['isRead'] = true;
                    });
                  },
                );
              },
            ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRead = notification['isRead'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead ? Colors.transparent : const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead ? const Color(0xFF2D2D44) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (notification['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'] as IconData,
                  color: notification['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['title'],
                          style: TextStyle(
                            color: isRead ? const Color(0xFFA1A1B5) : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          notification['time'],
                          style: TextStyle(
                            color: const Color(0xFF5D5D72),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        color: isRead ? const Color(0xFF5D5D72) : const Color(0xFFA1A1B5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Unread Indicator
              if (!isRead)
                Container(
                  margin: const EdgeInsets.only(left: 12, top: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
