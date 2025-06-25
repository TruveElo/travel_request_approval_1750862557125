import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CalendarHeaderWidget extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onTodayPressed;
  final DateTime lastSyncTime;

  const CalendarHeaderWidget({
    super.key,
    required this.selectedDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onTodayPressed,
    required this.lastSyncTime,
  });

  String _getMonthYear() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[selectedDate.month - 1]} ${selectedDate.year}';
  }

  String _getLastSyncText() {
    final now = DateTime.now();
    final difference = now.difference(lastSyncTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPreviousMonth,
                icon: CustomIconWidget(
                  iconName: 'chevron_left',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showMonthYearPicker(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _getMonthYear(),
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onNextMonth,
                icon: CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onTodayPressed,
                child: Text(
                  'Today',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              Text(
                'Last sync: ${_getLastSyncText()}',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DatePickerDialog(
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      ),
    );
  }
}
