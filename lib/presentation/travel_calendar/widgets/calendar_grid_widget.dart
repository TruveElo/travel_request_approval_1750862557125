import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalendarGridWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> travelData;
  final Function(Map<String, dynamic>) onTripTap;
  final Function(DateTime) onDateTap;

  const CalendarGridWidget({
    super.key,
    required this.selectedDate,
    required this.travelData,
    required this.onTripTap,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildWeekdayHeaders(),
          _buildCalendarDays(),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: weekdays
            .map((day) => Expanded(
                  child: Text(
                    day,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCalendarDays() {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(selectedDate.year, selectedDate.month, day);
      final tripsForDay = _getTripsForDate(currentDate);

      dayWidgets.add(_buildDayCell(currentDate, tripsForDay));
    }

    return Container(
      padding: EdgeInsets.all(8),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        children: dayWidgets,
      ),
    );
  }

  Widget _buildDayCell(DateTime date, List<Map<String, dynamic>> trips) {
    final isToday = _isSameDay(date, DateTime.now());
    final isSelected = _isSameDay(date, selectedDate);
    final hasTrips = trips.isNotEmpty;

    return GestureDetector(
      onTap: () => onDateTap(date),
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : isToday
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: isToday
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.day.toString(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isToday
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (hasTrips) ...[
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: trips
                    .take(3)
                    .map((trip) => Container(
                          width: 4,
                          height: 4,
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: trip["color"] as Color? ??
                                AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTripsForDate(DateTime date) {
    return travelData.where((trip) {
      final startDate = trip["startDate"] as DateTime;
      final endDate = trip["endDate"] as DateTime;
      return date.isAfter(startDate.subtract(Duration(days: 1))) &&
          date.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
