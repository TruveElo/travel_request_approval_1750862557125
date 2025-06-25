import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class TimelineCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;

  const TimelineCardWidget({
    super.key,
    required this.timeline,
  });

  String _formatDateTime(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final String formattedDate = '${date.day}/${date.month}/${date.year}';
      final String formattedTime =
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      return '$formattedDate at $formattedTime';
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    return AppTheme.getStatusColor(status);
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return Icons.send;
      case 'under review':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle;
      case 'denied':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationLevel1,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'timeline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Request Timeline',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: timeline.length,
              itemBuilder: (context, index) {
                final timelineItem = timeline[index];
                final String status = timelineItem['status'] as String;
                final String comment = timelineItem['comment'] as String;
                final String actor = timelineItem['actor'] as String;
                final String date = timelineItem['date'] as String;
                final bool isLast = index == timeline.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                _getStatusColor(status).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _getStatusColor(status),
                              width: 2,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName:
                                _getStatusIcon(status).codePoint.toString(),
                            color: _getStatusColor(status),
                            size: 20,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 60,
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  status,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusColor(status),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  _formatDateTime(date),
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              comment,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'by $actor',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
