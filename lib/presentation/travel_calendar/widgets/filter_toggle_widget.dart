import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterToggleWidget extends StatelessWidget {
  final bool showMyTrips;
  final ValueChanged<bool> onToggle;

  const FilterToggleWidget({
    super.key,
    required this.showMyTrips,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: showMyTrips
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: showMyTrips
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'My Trips',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: showMyTrips
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            showMyTrips ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !showMyTrips
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'group',
                      color: !showMyTrips
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Team Trips',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: !showMyTrips
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            !showMyTrips ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
