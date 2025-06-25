import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ApprovalSectionWidget extends StatefulWidget {
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onToggle;
  final String selectedManager;
  final String comments;
  final ValueChanged<String> onManagerChanged;
  final ValueChanged<String> onCommentsChanged;

  const ApprovalSectionWidget({
    super.key,
    required this.isExpanded,
    required this.isCompleted,
    required this.onToggle,
    required this.selectedManager,
    required this.comments,
    required this.onManagerChanged,
    required this.onCommentsChanged,
  });

  @override
  State<ApprovalSectionWidget> createState() => _ApprovalSectionWidgetState();
}

class _ApprovalSectionWidgetState extends State<ApprovalSectionWidget> {
  // Mock managers data
  final List<Map<String, dynamic>> _managers = [
    {
      'id': 1,
      'name': 'Jennifer Martinez',
      'email': 'jennifer.martinez@company.com',
      'title': 'VP of Operations',
      'department': 'Operations',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
    },
    {
      'id': 2,
      'name': 'Robert Anderson',
      'email': 'robert.anderson@company.com',
      'title': 'Director of Sales',
      'department': 'Sales',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
    },
    {
      'id': 3,
      'name': 'Maria Garcia',
      'email': 'maria.garcia@company.com',
      'title': 'Finance Manager',
      'department': 'Finance',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
    },
    {
      'id': 4,
      'name': 'James Wilson',
      'email': 'james.wilson@company.com',
      'title': 'HR Director',
      'department': 'Human Resources',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
    },
    {
      'id': 5,
      'name': 'Sarah Thompson',
      'email': 'sarah.thompson@company.com',
      'title': 'Marketing Director',
      'department': 'Marketing',
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
    },
  ];

  List<Map<String, dynamic>> _filteredManagers = [];
  bool _showManagerDropdown = false;

  @override
  void initState() {
    super.initState();
    _filteredManagers = _managers;
  }

  void _filterManagers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredManagers = _managers;
      } else {
        _filteredManagers = _managers.where((manager) {
          return (manager['name'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (manager['title'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (manager['department'] as String)
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Map<String, dynamic>? _getSelectedManagerData() {
    if (widget.selectedManager.isEmpty) return null;
    return _managers.firstWhere(
      (manager) => manager['name'] == widget.selectedManager,
      orElse: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedManagerData = _getSelectedManagerData();

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
                'Approval',
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
                Text(
                  'Select Manager *',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),

                // Selected Manager Display
                if (selectedManagerData != null &&
                    selectedManagerData.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          child: Text(
                            (selectedManagerData['name'] as String)
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
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
                                selectedManagerData['name'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.lightTheme.colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              Text(
                                '${selectedManagerData['title']} • ${selectedManagerData['department']}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.onManagerChanged('');
                            setState(() {
                              _showManagerDropdown = false;
                            });
                          },
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showManagerDropdown = true;
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'swap_horiz',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    label: Text('Change Manager'),
                  ),
                ] else ...[
                  // Manager Search Field
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search for your manager...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.lightTheme.colorScheme.outline,
                          size: 20,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _filterManagers(value);
                      setState(() {
                        _showManagerDropdown = value.isNotEmpty;
                      });
                    },
                    onTap: () {
                      setState(() {
                        _showManagerDropdown = true;
                      });
                    },
                    validator: (value) {
                      if (widget.selectedManager.isEmpty) {
                        return 'Please select a manager for approval';
                      }
                      return null;
                    },
                  ),
                ],

                // Manager Dropdown
                if (_showManagerDropdown && _filteredManagers.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Container(
                    constraints: BoxConstraints(maxHeight: 250),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredManagers.length,
                      itemBuilder: (context, index) {
                        final manager = _filteredManagers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            child: Text(
                              (manager['name'] as String)
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          title: Text(
                            manager['name'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '${manager['title']} • ${manager['department']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          onTap: () {
                            widget.onManagerChanged(manager['name'] as String);
                            setState(() {
                              _showManagerDropdown = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],

                SizedBox(height: 20),

                // Comments Section
                Text(
                  'Additional Comments',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.comments,
                  decoration: InputDecoration(
                    hintText:
                        'Add any additional information for your manager...',
                    counterText: '${widget.comments.length}/300',
                  ),
                  maxLines: 3,
                  maxLength: 300,
                  onChanged: widget.onCommentsChanged,
                ),
                SizedBox(height: 16),

                // Approval Process Info
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
                            iconName: 'info',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Approval Process:',
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
                        '1. Your manager will receive a notification\n2. They can approve or request changes\n3. You\'ll be notified of the decision\n4. Approved requests proceed to booking',
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
