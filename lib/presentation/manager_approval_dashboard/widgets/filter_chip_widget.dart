import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isUrgent;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.isUrgent = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? (isUrgent
            ? AppTheme.warningLight
            : AppTheme.lightTheme.colorScheme.primary)
        : AppTheme.lightTheme.colorScheme.surface;

    final Color textColor =
        isSelected ? Colors.white : AppTheme.lightTheme.colorScheme.onSurface;

    final Color borderColor = isSelected
        ? (isUrgent
            ? AppTheme.warningLight
            : AppTheme.lightTheme.colorScheme.primary)
        : AppTheme.lightTheme.colorScheme.outline;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUrgent && isSelected)
              Padding(
                padding: EdgeInsets.only(right: 6),
                child: CustomIconWidget(
                  iconName: 'warning',
                  color: Colors.white,
                  size: 16,
                ),
              ),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (count > 0) ...[
              SizedBox(width: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
