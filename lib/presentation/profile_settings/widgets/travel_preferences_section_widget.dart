import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TravelPreferencesSectionWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const TravelPreferencesSectionWidget({
    super.key,
    required this.userData,
  });

  @override
  State<TravelPreferencesSectionWidget> createState() =>
      _TravelPreferencesSectionWidgetState();
}

class _TravelPreferencesSectionWidgetState
    extends State<TravelPreferencesSectionWidget> {
  late String selectedOriginCity;
  late String selectedAccommodation;
  late List<String> selectedAirlines;

  final List<String> cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose'
  ];

  final List<String> accommodationTypes = [
    'Business Hotel',
    'Economy Hotel',
    'Extended Stay',
    'Luxury Hotel',
    'Boutique Hotel'
  ];

  final List<String> airlines = [
    'Delta',
    'American Airlines',
    'United',
    'Southwest',
    'JetBlue',
    'Alaska Airlines',
    'Spirit',
    'Frontier'
  ];

  @override
  void initState() {
    super.initState();
    selectedOriginCity = widget.userData["defaultOriginCity"] as String;
    selectedAccommodation =
        widget.userData["accommodationPreference"] as String;
    selectedAirlines =
        List<String>.from(widget.userData["preferredAirlines"] as List);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travel Preferences',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            _buildDropdownRow(
              icon: 'location_city',
              label: 'Default Origin City',
              value: selectedOriginCity,
              items: cities,
              onChanged: (value) {
                setState(() {
                  selectedOriginCity = value!;
                });
              },
            ),
            Divider(height: 24),
            _buildDropdownRow(
              icon: 'hotel',
              label: 'Accommodation Preference',
              value: selectedAccommodation,
              items: accommodationTypes,
              onChanged: (value) {
                setState(() {
                  selectedAccommodation = value!;
                });
              },
            ),
            Divider(height: 24),
            _buildAirlinesSection(),
            Divider(height: 24),
            _buildExpenseCategoriesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow({
    required String icon,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
              SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: value,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAirlinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'flight',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              'Preferred Airlines',
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: airlines.map((airline) {
            final isSelected = selectedAirlines.contains(airline);
            return FilterChip(
              label: Text(airline),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedAirlines.add(airline);
                  } else {
                    selectedAirlines.remove(airline);
                  }
                });
              },
              selectedColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.lightTheme.primaryColor,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExpenseCategoriesSection() {
    final categories = widget.userData["expenseCategories"] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'receipt',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 12),
            Text(
              'Expense Categories',
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            return Chip(
              label: Text(category as String),
              backgroundColor:
                  AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            );
          }).toList(),
        ),
      ],
    );
  }
}
