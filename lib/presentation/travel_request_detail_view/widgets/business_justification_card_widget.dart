import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class BusinessJustificationCardWidget extends StatefulWidget {
  final String justification;
  final String expectedOutcomes;

  const BusinessJustificationCardWidget({
    super.key,
    required this.justification,
    required this.expectedOutcomes,
  });

  @override
  State<BusinessJustificationCardWidget> createState() =>
      _BusinessJustificationCardWidgetState();
}

class _BusinessJustificationCardWidgetState
    extends State<BusinessJustificationCardWidget> {
  bool _isExpanded = false;
  final int _maxLines = 3;

  bool get _shouldShowExpandButton => widget.justification.length > 150;

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
                  iconName: 'business_center',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Business Justification',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              crossFadeState: _isExpanded || !_shouldShowExpandButton
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                widget.justification,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                maxLines: _maxLines,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                widget.justification,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            if (_shouldShowExpandButton) ...[
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'Show Less' : 'Show More',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20),
            Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'flag',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Expected Outcomes',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              widget.expectedOutcomes,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
