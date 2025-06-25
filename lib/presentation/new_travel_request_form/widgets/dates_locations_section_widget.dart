import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class DatesLocationsSectionWidget extends StatefulWidget {
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onToggle;
  final DateTime? departureDate;
  final TimeOfDay? departureTime;
  final DateTime? returnDate;
  final TimeOfDay? returnTime;
  final String originCity;
  final String destinationCity;
  final ValueChanged<DateTime?> onDepartureDateChanged;
  final ValueChanged<TimeOfDay?> onDepartureTimeChanged;
  final ValueChanged<DateTime?> onReturnDateChanged;
  final ValueChanged<TimeOfDay?> onReturnTimeChanged;
  final ValueChanged<String> onOriginCityChanged;
  final ValueChanged<String> onDestinationCityChanged;

  const DatesLocationsSectionWidget({
    super.key,
    required this.isExpanded,
    required this.isCompleted,
    required this.onToggle,
    required this.departureDate,
    required this.departureTime,
    required this.returnDate,
    required this.returnTime,
    required this.originCity,
    required this.destinationCity,
    required this.onDepartureDateChanged,
    required this.onDepartureTimeChanged,
    required this.onReturnDateChanged,
    required this.onReturnTimeChanged,
    required this.onOriginCityChanged,
    required this.onDestinationCityChanged,
  });

  @override
  State<DatesLocationsSectionWidget> createState() =>
      _DatesLocationsSectionWidgetState();
}

class _DatesLocationsSectionWidgetState
    extends State<DatesLocationsSectionWidget> {
  // Mock cities data
  final List<Map<String, dynamic>> _cities = [
    {'name': 'New York', 'country': 'USA', 'code': 'NYC'},
    {'name': 'Los Angeles', 'country': 'USA', 'code': 'LAX'},
    {'name': 'Chicago', 'country': 'USA', 'code': 'CHI'},
    {'name': 'San Francisco', 'country': 'USA', 'code': 'SFO'},
    {'name': 'Boston', 'country': 'USA', 'code': 'BOS'},
    {'name': 'London', 'country': 'UK', 'code': 'LDN'},
    {'name': 'Paris', 'country': 'France', 'code': 'PAR'},
    {'name': 'Tokyo', 'country': 'Japan', 'code': 'TYO'},
    {'name': 'Singapore', 'country': 'Singapore', 'code': 'SIN'},
    {'name': 'Sydney', 'country': 'Australia', 'code': 'SYD'},
  ];

  List<Map<String, dynamic>> _filteredOriginCities = [];
  List<Map<String, dynamic>> _filteredDestinationCities = [];
  bool _showOriginDropdown = false;
  bool _showDestinationDropdown = false;

  @override
  void initState() {
    super.initState();
    _filteredOriginCities = _cities;
    _filteredDestinationCities = _cities;
  }

  void _filterOriginCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOriginCities = _cities;
      } else {
        _filteredOriginCities = _cities.where((city) {
          return (city['name'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (city['country'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _filterDestinationCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDestinationCities = _cities;
      } else {
        _filteredDestinationCities = _cities.where((city) {
          return (city['name'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (city['country'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture
          ? (widget.departureDate ?? DateTime.now().add(Duration(days: 10)))
          : (widget.returnDate ?? DateTime.now().add(Duration(days: 11))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return DatePickerTheme(
          data: DatePickerThemeData(
            backgroundColor: AppTheme.lightTheme.cardColor,
            headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
            headerForegroundColor: Colors.white,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return AppTheme.lightTheme.colorScheme.onSurface;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.lightTheme.colorScheme.primary;
              }
              return Colors.transparent;
            }),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isDeparture) {
        widget.onDepartureDateChanged(picked);
        // Auto-set return date to next day if not set
        if (widget.returnDate == null) {
          widget.onReturnDateChanged(picked.add(Duration(days: 1)));
        }
      } else {
        widget.onReturnDateChanged(picked);
      }
    }
  }

  Future<void> _selectTime(BuildContext context, bool isDeparture) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isDeparture
          ? (widget.departureTime ?? TimeOfDay(hour: 9, minute: 0))
          : (widget.returnTime ?? TimeOfDay(hour: 17, minute: 0)),
    );

    if (picked != null) {
      if (isDeparture) {
        widget.onDepartureTimeChanged(picked);
      } else {
        widget.onReturnTimeChanged(picked);
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    return time.format(context);
  }

  bool _isAdvanceBookingValid() {
    if (widget.departureDate != null) {
      int daysDifference =
          widget.departureDate!.difference(DateTime.now()).inDays;
      return daysDifference >= 10;
    }
    return true;
  }

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
              iconName: widget.isCompleted
                  ? 'check_circle'
                  : 'radio_button_unchecked',
              color: widget.isCompleted
                  ? AppTheme.successLight
                  : AppTheme.lightTheme.colorScheme.outline,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Dates & Locations',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!widget.isCompleted)
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
        initiallyExpanded: widget.isExpanded,
        onExpansionChanged: (expanded) => widget.onToggle(),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Departure Section
                Text(
                  'Departure *',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'calendar_today',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _formatDate(widget.departureDate),
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, true),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'access_time',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _formatTime(widget.departureTime),
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (!_isAdvanceBookingValid()) ...[
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.warningLight.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'warning',
                          color: AppTheme.warningLight,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Travel date is less than 10 days away. This may affect approval processing.',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.warningLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 20),

                // Return Section
                Text(
                  'Return *',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'calendar_today',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _formatDate(widget.returnDate),
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, false),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'access_time',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _formatTime(widget.returnTime),
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Locations Section
                Text(
                  'Locations *',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),

                // Origin City
                Text(
                  'From (Origin)',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.originCity,
                  decoration: InputDecoration(
                    hintText: 'Search origin city...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: 'flight_takeoff',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    widget.onOriginCityChanged(value);
                    _filterOriginCities(value);
                    setState(() {
                      _showOriginDropdown = value.isNotEmpty;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _showOriginDropdown = true;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Origin city is required';
                    }
                    return null;
                  },
                ),

                if (_showOriginDropdown &&
                    _filteredOriginCities.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Container(
                    constraints: BoxConstraints(maxHeight: 150),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredOriginCities.length,
                      itemBuilder: (context, index) {
                        final city = _filteredOriginCities[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            city['name'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            city['country'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          onTap: () {
                            widget.onOriginCityChanged(city['name'] as String);
                            setState(() {
                              _showOriginDropdown = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],

                SizedBox(height: 16),

                // Destination City
                Text(
                  'To (Destination)',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.destinationCity,
                  decoration: InputDecoration(
                    hintText: 'Search destination city...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: 'flight_land',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    widget.onDestinationCityChanged(value);
                    _filterDestinationCities(value);
                    setState(() {
                      _showDestinationDropdown = value.isNotEmpty;
                    });
                  },
                  onTap: () {
                    setState(() {
                      _showDestinationDropdown = true;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Destination city is required';
                    }
                    return null;
                  },
                ),

                if (_showDestinationDropdown &&
                    _filteredDestinationCities.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Container(
                    constraints: BoxConstraints(maxHeight: 150),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredDestinationCities.length,
                      itemBuilder: (context, index) {
                        final city = _filteredDestinationCities[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            city['name'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            city['country'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          onTap: () {
                            widget.onDestinationCityChanged(
                                city['name'] as String);
                            setState(() {
                              _showDestinationDropdown = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
