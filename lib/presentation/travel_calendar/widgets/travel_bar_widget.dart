import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TravelBarWidget extends StatelessWidget {
  final Map<String, dynamic> trip;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const TravelBarWidget({
    super.key,
    required this.trip,
    required this.onTap,
    required this.onLongPress,
  });

  String _formatDateRange() {
    final startDate = trip["startDate"] as DateTime;
    final endDate = trip["endDate"] as DateTime;

    final startMonth = _getMonthAbbreviation(startDate.month);
    final endMonth = _getMonthAbbreviation(endDate.month);

    if (startDate.month == endDate.month) {
      return '$startMonth ${startDate.day}-${endDate.day}';
    } else {
      return '$startMonth ${startDate.day} - $endMonth ${endDate.day}';
    }
  }

  String _getMonthAbbreviation(int month) {
    const months = [
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
    return months[month - 1];
  }

  int _getTripDuration() {
    final startDate = trip["startDate"] as DateTime;
    final endDate = trip["endDate"] as DateTime;
    return endDate.difference(startDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final tripColor =
        trip["color"] as Color? ?? AppTheme.lightTheme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: tripColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tripColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip["title"] as String? ?? '',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${trip["origin"]} → ${trip["destination"]}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.getStatusColor(
                                trip["status"] as String? ?? 'draft')
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (trip["status"] as String? ?? 'draft').toUpperCase(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.getStatusColor(
                              trip["status"] as String? ?? 'draft'),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      trip["cost"] as String? ?? '',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  _formatDateRange(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: 16),
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '${_getTripDuration()} days',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  trip["requestor"] as String? ?? '',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
