import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TravelRequestCardWidget extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onArchive;

  const TravelRequestCardWidget({
    super.key,
    required this.request,
    required this.onTap,
    this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.onShare,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final String status = request['status'] as String;
    final Color statusColor = AppTheme.getStatusColor(status);

    return Dismissible(
      key: Key('request_${request['id']}'),
      background: _buildSwipeBackground(isLeft: true),
      secondaryBackground: _buildSwipeBackground(isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Right swipe - Edit/Duplicate actions
          if (onEdit != null && status == 'Draft') {
            onEdit!();
          } else {
            onDuplicate();
          }
        } else {
          // Left swipe - Share/Archive actions
          onShare();
        }
      },
      confirmDismiss: (direction) async {
        // Show action menu instead of dismissing
        if (direction == DismissDirection.startToEnd) {
          _showLeftSwipeMenu(context);
        } else {
          _showRightSwipeMenu(context);
        }
        return false; // Don't actually dismiss
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Card(
          elevation: AppTheme.elevationLevel1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with route and status
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'flight_takeoff',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${request['origin']} → ${request['destination']}',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Trip name
                Text(
                  request['tripName'] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12),

                // Details row
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: 'calendar_today',
                        label: 'Departure',
                        value: _formatDate(request['departureDate'] as String),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailItem(
                        icon: 'attach_money',
                        label: 'Est. Cost',
                        value: request['estimatedCost'] as String,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Manager and priority
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.textSecondaryLight,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              request['manager'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (request['priority'] == 'High')
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'priority_high',
                              color: AppTheme.errorLight,
                              size: 12,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'High',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.errorLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.textSecondaryLight,
              size: 14,
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall,
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color:
            isLeft ? AppTheme.lightTheme.primaryColor : AppTheme.successLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: CustomIconWidget(
        iconName: isLeft ? 'edit' : 'share',
        color: Colors.white,
        size: 24,
      ),
    );
  }

  void _showLeftSwipeMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null && request['status'] == 'Draft')
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                title: Text('Edit Request'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit!();
                },
              ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Duplicate Request'),
              onTap: () {
                Navigator.pop(context);
                onDuplicate();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text('Delete Request'),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRightSwipeMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.successLight,
                size: 24,
              ),
              title: Text('Share Request'),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'archive',
                color: AppTheme.warningLight,
                size: 24,
              ),
              title: Text('Archive Request'),
              onTap: () {
                Navigator.pop(context);
                onArchive();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Options',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'flag',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text('Priority Flag'),
              onTap: () {
                Navigator.pop(context);
                // Handle priority flag
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'note_add',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Add Note'),
              onTap: () {
                Navigator.pop(context);
                // Handle add note
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.textSecondaryLight,
                size: 24,
              ),
              title: Text('View History'),
              onTap: () {
                Navigator.pop(context);
                // Handle view history
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    } catch (e) {
      return dateString;
    }
  }
}
