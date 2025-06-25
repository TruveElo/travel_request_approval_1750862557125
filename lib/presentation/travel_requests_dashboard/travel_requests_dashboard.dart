import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/travel_request_card_widget.dart';

class TravelRequestsDashboard extends StatefulWidget {
  const TravelRequestsDashboard({super.key});

  @override
  State<TravelRequestsDashboard> createState() =>
      _TravelRequestsDashboardState();
}

class _TravelRequestsDashboardState extends State<TravelRequestsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<String> activeFilters = ['Pending', 'Draft'];
  bool isLoading = false;
  String lastSyncTime = '';

  // Mock data for travel requests
  final List<Map<String, dynamic>> travelRequests = [
    {
      "id": 1,
      "origin": "New York",
      "destination": "London",
      "tripName": "Client Meeting Q4",
      "status": "Pending",
      "departureDate": "2024-02-15",
      "estimatedCost": "\$2,450.00",
      "manager": "Sarah Johnson",
      "priority": "High",
      "createdDate": "2024-01-28",
      "description": "Quarterly business review with UK clients",
      "duration": "5 days"
    },
    {
      "id": 2,
      "origin": "San Francisco",
      "destination": "Tokyo",
      "tripName": "Tech Conference 2024",
      "status": "Approved",
      "departureDate": "2024-03-10",
      "estimatedCost": "\$3,200.00",
      "manager": "Michael Chen",
      "priority": "Medium",
      "createdDate": "2024-01-25",
      "description": "Annual technology conference attendance",
      "duration": "7 days"
    },
    {
      "id": 3,
      "origin": "Chicago",
      "destination": "Berlin",
      "tripName": "Product Launch",
      "status": "Draft",
      "departureDate": "2024-04-05",
      "estimatedCost": "\$1,890.00",
      "manager": "Emma Wilson",
      "priority": "High",
      "createdDate": "2024-01-30",
      "description": "European product launch event",
      "duration": "4 days"
    },
    {
      "id": 4,
      "origin": "Boston",
      "destination": "Sydney",
      "tripName": "Partnership Meeting",
      "status": "Denied",
      "departureDate": "2024-02-28",
      "estimatedCost": "\$4,100.00",
      "manager": "David Brown",
      "priority": "Low",
      "createdDate": "2024-01-20",
      "description": "Strategic partnership discussions",
      "duration": "6 days"
    },
    {
      "id": 5,
      "origin": "Miami",
      "destination": "Barcelona",
      "tripName": "Sales Summit",
      "status": "Pending",
      "departureDate": "2024-03-20",
      "estimatedCost": "\$2,100.00",
      "manager": "Lisa Garcia",
      "priority": "Medium",
      "createdDate": "2024-02-01",
      "description": "Annual sales team summit",
      "duration": "3 days"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _updateLastSyncTime();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateLastSyncTime() {
    setState(() {
      lastSyncTime =
          'Last synced: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isLoading = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
    _updateLastSyncTime();
  }

  void _removeFilter(String filter) {
    setState(() {
      activeFilters.remove(filter);
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['All', 'Draft', 'Pending', 'Approved', 'Denied']
                  .map((status) => FilterChip(
                        label: Text(status),
                        selected: activeFilters.contains(status),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              if (!activeFilters.contains(status)) {
                                activeFilters.add(status);
                              }
                            } else {
                              activeFilters.remove(status);
                            }
                          });
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get filteredRequests {
    if (activeFilters.isEmpty || activeFilters.contains('All')) {
      return travelRequests;
    }
    return travelRequests
        .where((request) => activeFilters.contains(request['status'] as String))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filter
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.borderLight,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search travel requests...',
                              prefixIcon: CustomIconWidget(
                                iconName: 'search',
                                color: AppTheme.textSecondaryLight,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showFilterOptions,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'filter_list',
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'assignment',
                              color: _tabController.index == 0
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.textSecondaryLight,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text('Requests'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: _tabController.index == 1
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.textSecondaryLight,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text('Calendar'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'person',
                              color: _tabController.index == 2
                                  ? AppTheme.lightTheme.primaryColor
                                  : AppTheme.textSecondaryLight,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text('Profile'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filter chips
            if (activeFilters.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: activeFilters
                        .map((filter) => FilterChipWidget(
                              label: filter,
                              count: travelRequests
                                  .where((req) => req['status'] == filter)
                                  .length,
                              onRemove: () => _removeFilter(filter),
                            ))
                        .toList(),
                  ),
                ),
              ),

            // Last sync time
            if (lastSyncTime.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  lastSyncTime,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Requests Tab
                  filteredRequests.isEmpty
                      ? EmptyStateWidget(
                          onCreateRequest: () {
                            Navigator.pushNamed(
                                context, '/new-travel-request-form');
                          },
                        )
                      : RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: _handleRefresh,
                          child: ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: filteredRequests.length,
                            itemBuilder: (context, index) {
                              final request = filteredRequests[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: TravelRequestCardWidget(
                                  request: request,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/travel-request-detail-view',
                                      arguments: request,
                                    );
                                  },
                                  onEdit: request['status'] == 'Draft'
                                      ? () {
                                          Navigator.pushNamed(
                                            context,
                                            '/new-travel-request-form',
                                            arguments: request,
                                          );
                                        }
                                      : null,
                                  onDuplicate: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/new-travel-request-form',
                                      arguments: {
                                        ...request,
                                        'id': null,
                                        'status': 'Draft'
                                      },
                                    );
                                  },
                                  onDelete: () {
                                    _showDeleteConfirmation(request);
                                  },
                                  onShare: () {
                                    _shareRequest(request);
                                  },
                                  onArchive: () {
                                    _archiveRequest(request);
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                  // Calendar Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color: AppTheme.textSecondaryLight,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Calendar View',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/travel-calendar');
                          },
                          child: Text('Open Full Calendar'),
                        ),
                      ],
                    ),
                  ),

                  // Profile Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.textSecondaryLight,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Profile Settings',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/profile-settings');
                          },
                          child: Text('Open Profile'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new-travel-request-form');
        },
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Request'),
        content: Text('Are you sure you want to delete this travel request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle delete
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Request deleted successfully')),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _shareRequest(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing request: ${request['tripName']}')),
    );
  }

  void _archiveRequest(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request archived: ${request['tripName']}')),
    );
  }
}
