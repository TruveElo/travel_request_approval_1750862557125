import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TripDetailBottomSheet extends StatelessWidget {
  final Map<String, dynamic> trip;

  const TripDetailBottomSheet({
    super.key,
    required this.trip,
  });

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tripColor =
        trip["color"] as Color? ?? AppTheme.lightTheme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXLarge),
          topRight: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Trip title and status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trip["title"] as String? ?? '',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.getStatusColor(
                                  trip["status"] as String? ?? 'draft')
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          (trip["status"] as String? ?? 'draft').toUpperCase(),
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.getStatusColor(
                                trip["status"] as String? ?? 'draft'),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Trip details
                  _buildDetailRow(
                    icon: 'flight_takeoff',
                    label: 'Route',
                    value: '${trip["origin"]} → ${trip["destination"]}',
                  ),
                  _buildDetailRow(
                    icon: 'calendar_today',
                    label: 'Departure',
                    value: _formatDate(trip["startDate"] as DateTime),
                  ),
                  _buildDetailRow(
                    icon: 'calendar_today',
                    label: 'Return',
                    value: _formatDate(trip["endDate"] as DateTime),
                  ),
                  _buildDetailRow(
                    icon: 'person',
                    label: 'Requestor',
                    value: trip["requestor"] as String? ?? '',
                  ),
                  _buildDetailRow(
                    icon: 'attach_money',
                    label: 'Estimated Cost',
                    value: trip["cost"] as String? ?? '',
                  ),

                  SizedBox(height: 24),

                  // Purpose section
                  Text(
                    'Purpose',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    trip["purpose"] as String? ?? '',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),

                  SizedBox(height: 24),

                  // Attendees section
                  if ((trip["attendees"] as List?)?.isNotEmpty == true) ...[
                    Text(
                      'Attendees',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (trip["attendees"] as List)
                          .map((attendee) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: tripColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  attendee as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: tripColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 24),
                  ],

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/travel-request-detail-view');
                          },
                          child: Text('View Details'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Edit functionality
                          },
                          child: Text('Edit Trip'),
                        ),
                      ),
                    ],
                  ),

                  // Bottom padding for safe area
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
