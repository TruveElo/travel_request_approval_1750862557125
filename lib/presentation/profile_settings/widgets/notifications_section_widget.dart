import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class NotificationsSectionWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const NotificationsSectionWidget({
    super.key,
    required this.userData,
  });

  @override
  State<NotificationsSectionWidget> createState() =>
      _NotificationsSectionWidgetState();
}

class _NotificationsSectionWidgetState
    extends State<NotificationsSectionWidget> {
  late bool approvalUpdates;
  late bool deadlineReminders;
  late bool teamNotifications;

  @override
  void initState() {
    super.initState();
    final notifications =
        widget.userData["notifications"] as Map<String, dynamic>;
    approvalUpdates = notifications["approvalUpdates"] as bool;
    deadlineReminders = notifications["deadlineReminders"] as bool;
    teamNotifications = notifications["teamNotifications"] as bool;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Notifications',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    // Open system notification settings
                  },
                  child: Text('System Settings'),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildNotificationToggle(
              icon: 'notifications_active',
              title: 'Approval Status Updates',
              subtitle:
                  'Get notified when your travel requests are approved or denied',
              value: approvalUpdates,
              onChanged: (value) {
                setState(() {
                  approvalUpdates = value;
                });
                _showConfirmationSnackBar(
                    'Approval notifications ${value ? 'enabled' : 'disabled'}');
              },
            ),
            Divider(height: 24),
            _buildNotificationToggle(
              icon: 'schedule',
              title: 'Deadline Reminders',
              subtitle:
                  'Reminders for upcoming travel dates and submission deadlines',
              value: deadlineReminders,
              onChanged: (value) {
                setState(() {
                  deadlineReminders = value;
                });
                _showConfirmationSnackBar(
                    'Deadline reminders ${value ? 'enabled' : 'disabled'}');
              },
            ),
            Divider(height: 24),
            _buildNotificationToggle(
              icon: 'group',
              title: 'Team Notifications',
              subtitle: 'Updates about team travel schedules and announcements',
              value: teamNotifications,
              onChanged: (value) {
                setState(() {
                  teamNotifications = value;
                });
                _showConfirmationSnackBar(
                    'Team notifications ${value ? 'enabled' : 'disabled'}');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showConfirmationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
