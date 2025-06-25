import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class BusinessJustificationSectionWidget extends StatelessWidget {
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onToggle;
  final String businessJustification;
  final String expectedOutcomes;
  final ValueChanged<String> onBusinessJustificationChanged;
  final ValueChanged<String> onExpectedOutcomesChanged;

  const BusinessJustificationSectionWidget({
    super.key,
    required this.isExpanded,
    required this.isCompleted,
    required this.onToggle,
    required this.businessJustification,
    required this.expectedOutcomes,
    required this.onBusinessJustificationChanged,
    required this.onExpectedOutcomesChanged,
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
                'Business Justification',
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
                  'Business Justification *',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: businessJustification,
                  decoration: InputDecoration(
                    hintText: 'Explain the business need for this travel...',
                    counterText: '${businessJustification.length}/500',
                  ),
                  maxLines: 4,
                  maxLength: 500,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Business justification is required';
                    }
                    if (value.trim().length < 20) {
                      return 'Please provide more detailed justification (minimum 20 characters)';
                    }
                    return null;
                  },
                  onChanged: onBusinessJustificationChanged,
                ),
                SizedBox(height: 16),
                Text(
                  'Expected Outcomes *',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: expectedOutcomes,
                  decoration: InputDecoration(
                    hintText: 'Describe the expected outcomes and benefits...',
                    counterText: '${expectedOutcomes.length}/300',
                  ),
                  maxLines: 3,
                  maxLength: 300,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Expected outcomes are required';
                    }
                    return null;
                  },
                  onChanged: onExpectedOutcomesChanged,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'lightbulb',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Tips for strong justification:',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Link to specific business objectives\n• Quantify potential impact or value\n• Explain why remote alternatives won\'t work\n• Include relevant deadlines or time constraints',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onPrimaryContainer,
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
