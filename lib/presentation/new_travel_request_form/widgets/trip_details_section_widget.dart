import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TripDetailsSectionWidget extends StatelessWidget {
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onToggle;
  final String tripName;
  final ValueChanged<String> onTripNameChanged;

  const TripDetailsSectionWidget({
    super.key,
    required this.isExpanded,
    required this.isCompleted,
    required this.onToggle,
    required this.tripName,
    required this.onTripNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationLevel1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: isCompleted ? 'check_circle' : 'radio_button_unchecked',
              color: isCompleted
                  ? AppTheme.successLight
                  : AppTheme.lightTheme.colorScheme.outline,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Trip Details',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!isCompleted)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.errorLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Required',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.errorLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) => onToggle(),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Name *',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: tripName,
                  decoration: InputDecoration(
                    hintText:
                        'Enter trip name (e.g., Client Meeting - New York)',
                    counterText: '${tripName.length}/100',
                  ),
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Trip name is required';
                    }
                    return null;
                  },
                  onChanged: onTripNameChanged,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Choose a descriptive name that clearly identifies the purpose and destination of your trip.',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
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
