import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class RequestHeaderCardWidget extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const RequestHeaderCardWidget({
    super.key,
    required this.requestData,
  });

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final String status = requestData['status'] as String;
    final String origin = requestData['origin'] as String;
    final String destination = requestData['destination'] as String;
    final String tripName = requestData['tripName'] as String;
    final double totalCost = requestData['totalCost'] as double;
    final String departureDate = requestData['departureDate'] as String;
    final String returnDate = requestData['returnDate'] as String;

    return Card(
      elevation: AppTheme.elevationLevel2,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$origin → $destination',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        tripName,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(status).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'flight_takeoff',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Departure',
                        style: AppTheme.lightTheme.textTheme.labelMedium,
                      ),
                      Spacer(),
                      Text(
                        _formatDateTime(departureDate),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'flight_land',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Return',
                        style: AppTheme.lightTheme.textTheme.labelMedium,
                      ),
                      Spacer(),
                      Text(
                        _formatDateTime(returnDate),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'attach_money',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Total Estimated Cost',
                        style: AppTheme.lightTheme.textTheme.labelMedium,
                      ),
                      Spacer(),
                      Text(
                        '\$${totalCost.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Submitted by ${requestData['submittedBy']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                Spacer(),
                Text(
                  _formatDate(requestData['submittedDate'] as String),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
