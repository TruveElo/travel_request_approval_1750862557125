import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onCreateRequest;

  const EmptyStateWidget({
    super.key,
    required this.onCreateRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: CustomIconWidget(
                iconName: 'flight_takeoff',
                color: AppTheme.lightTheme.primaryColor,
                size: 64,
              ),
            ),

            SizedBox(height: 24),

            // Title
            Text(
              'No Travel Requests',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),

            // Description
            Text(
              'Start planning your business trips by creating your first travel request.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 32),

            // CTA Button
            ElevatedButton.icon(
              onPressed: onCreateRequest,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
              label: Text('Create Your First Request'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Secondary actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Handle import from calendar
                  },
                  icon: CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 18,
                  ),
                  label: Text('Import from Calendar'),
                ),
                SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () {
                    // Handle view templates
                  },
                  icon: CustomIconWidget(
                    iconName: 'description',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 18,
                  ),
                  label: Text('View Templates'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
