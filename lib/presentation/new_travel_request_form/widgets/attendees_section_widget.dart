import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AttendeesSectionWidget extends StatefulWidget {
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onToggle;
  final List<Map<String, dynamic>> attendees;
  final ValueChanged<List<Map<String, dynamic>>> onAttendeesChanged;

  const AttendeesSectionWidget({
    super.key,
    required this.isExpanded,
    required this.isCompleted,
    required this.onToggle,
    required this.attendees,
    required this.onAttendeesChanged,
  });

  @override
  State<AttendeesSectionWidget> createState() => _AttendeesSectionWidgetState();
}

class _AttendeesSectionWidgetState extends State<AttendeesSectionWidget> {
  final TextEditingController _attendeeController = TextEditingController();

  // Mock company directory
  final List<Map<String, dynamic>> _companyDirectory = [
    {
      'id': 1,
      'name': 'Sarah Johnson',
      'email': 'sarah.johnson@company.com',
      'department': 'Marketing',
      'title': 'Marketing Director',
    },
    {
      'id': 2,
      'name': 'Michael Chen',
      'email': 'michael.chen@company.com',
      'department': 'Sales',
      'title': 'Sales Manager',
    },
    {
      'id': 3,
      'name': 'Emily Rodriguez',
      'email': 'emily.rodriguez@company.com',
      'department': 'Product',
      'title': 'Product Manager',
    },
    {
      'id': 4,
      'name': 'David Kim',
      'email': 'david.kim@company.com',
      'department': 'Engineering',
      'title': 'Senior Developer',
    },
    {
      'id': 5,
      'name': 'Lisa Thompson',
      'email': 'lisa.thompson@company.com',
      'department': 'Finance',
      'title': 'Finance Director',
    },
  ];

  List<Map<String, dynamic>> _filteredDirectory = [];

  @override
  void initState() {
    super.initState();
    _filteredDirectory = _companyDirectory;
  }

  void _filterDirectory(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDirectory = _companyDirectory;
      } else {
        _filteredDirectory = _companyDirectory.where((person) {
          return (person['name'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (person['email'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (person['department'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _addAttendee(Map<String, dynamic> person) {
    List<Map<String, dynamic>> updatedAttendees = List.from(widget.attendees);

    // Check if attendee already exists
    bool alreadyExists =
        updatedAttendees.any((attendee) => attendee['id'] == person['id']);

    if (!alreadyExists) {
      updatedAttendees.add(person);
      widget.onAttendeesChanged(updatedAttendees);
      _attendeeController.clear();
      _filteredDirectory = _companyDirectory;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${person['name']} is already added'),
          backgroundColor: AppTheme.warningLight,
        ),
      );
    }
  }

  void _removeAttendee(int index) {
    List<Map<String, dynamic>> updatedAttendees = List.from(widget.attendees);
    updatedAttendees.removeAt(index);
    widget.onAttendeesChanged(updatedAttendees);
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
                'Meeting Attendees',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.attendees.isNotEmpty
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.attendees.length}',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: widget.attendees.isNotEmpty
                      ? AppTheme.successLight
                      : AppTheme.lightTheme.colorScheme.outline,
                  fontWeight: FontWeight.w600,
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
                Text(
                  'Add Attendees',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _attendeeController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, email, or department...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.outline,
                        size: 20,
                      ),
                    ),
                  ),
                  onChanged: _filterDirectory,
                ),
                if (_attendeeController.text.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredDirectory.length,
                      itemBuilder: (context, index) {
                        final person = _filteredDirectory[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            child: Text(
                              (person['name'] as String)
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          title: Text(
                            person['name'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '${person['title']} • ${person['department']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          onTap: () => _addAttendee(person),
                        );
                      },
                    ),
                  ),
                ],
                if (widget.attendees.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text(
                    'Selected Attendees (${widget.attendees.length})',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...widget.attendees.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> attendee = entry.value;

                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            child: Text(
                              (attendee['name'] as String)
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attendee['name'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${attendee['title']} • ${attendee['department']}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeAttendee(index),
                            icon: CustomIconWidget(
                              iconName: 'remove_circle',
                              color: AppTheme.errorLight,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                if (widget.attendees.isEmpty) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'people',
                          color: AppTheme.lightTheme.colorScheme.outline,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'No attendees added yet. Search and add meeting participants from your company directory.',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                        ),
                      ],
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

  @override
  void dispose() {
    _attendeeController.dispose();
    super.dispose();
  }
}
