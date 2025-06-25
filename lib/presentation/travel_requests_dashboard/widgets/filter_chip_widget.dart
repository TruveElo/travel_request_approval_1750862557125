import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onRemove;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.count,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (count > 0) ...[
              SizedBox(width: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.primaryColor,
                size: 16,
              ),
            ),
          ],
        ),
        backgroundColor:
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        side: BorderSide(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
