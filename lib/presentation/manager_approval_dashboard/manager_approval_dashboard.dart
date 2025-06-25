import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/approval_request_card_widget.dart';
import './widgets/filter_chip_widget.dart';

class ManagerApprovalDashboard extends StatefulWidget {
  const ManagerApprovalDashboard({super.key});

  @override
  State<ManagerApprovalDashboard> createState() =>
      _ManagerApprovalDashboardState();
}

class _ManagerApprovalDashboardState extends State<ManagerApprovalDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Pending';
  bool _isMultiSelectMode = false;
  final Set<String> _selectedRequests = {};
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  // Mock data for travel requests
  final List<Map<String, dynamic>> _travelRequests = [
    {
      "id": "TR001",
      "requestorName": "Sarah Johnson",
      "requestorPhoto":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "tripSummary": "New York → San Francisco",
      "tripName": "Client Meeting",
      "departureDate": DateTime.now().add(Duration(days: 5)),
      "returnDate": DateTime.now().add(Duration(days: 8)),
      "estimatedCost": "\$2,450",
      "status": "Pending",
      "isUrgent": true,
      "businessJustification":
          "Critical client presentation for Q4 contract renewal",
      "submittedDate": DateTime.now().subtract(Duration(days: 2)),
      "department": "Sales"
    },
    {
      "id": "TR002",
      "requestorName": "Michael Chen",
      "requestorPhoto":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "tripSummary": "Chicago → Boston",
      "tripName": "Conference Attendance",
      "departureDate": DateTime.now().add(Duration(days: 15)),
      "returnDate": DateTime.now().add(Duration(days: 17)),
      "estimatedCost": "\$1,850",
      "status": "Pending",
      "isUrgent": false,
      "businessJustification":
          "Industry conference for professional development",
      "submittedDate": DateTime.now().subtract(Duration(days: 1)),
      "department": "Engineering"
    },
    {
      "id": "TR003",
      "requestorName": "Emily Rodriguez",
      "requestorPhoto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "tripSummary": "Los Angeles → Seattle",
      "tripName": "Team Workshop",
      "departureDate": DateTime.now().add(Duration(days: 7)),
      "returnDate": DateTime.now().add(Duration(days: 9)),
      "estimatedCost": "\$1,650",
      "status": "Pending",
      "isUrgent": true,
      "businessJustification": "Quarterly team alignment and strategy session",
      "submittedDate": DateTime.now().subtract(Duration(days: 3)),
      "department": "Marketing"
    },
    {
      "id": "TR004",
      "requestorName": "David Kim",
      "requestorPhoto":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "tripSummary": "Miami → Atlanta",
      "tripName": "Vendor Meeting",
      "departureDate": DateTime.now().add(Duration(days: 20)),
      "returnDate": DateTime.now().add(Duration(days: 22)),
      "estimatedCost": "\$1,200",
      "status": "Pending",
      "isUrgent": false,
      "businessJustification":
          "Vendor contract negotiation and relationship building",
      "submittedDate": DateTime.now().subtract(Duration(hours: 8)),
      "department": "Operations"
    },
    {
      "id": "TR005",
      "requestorName": "Lisa Thompson",
      "requestorPhoto":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "tripSummary": "Denver → Phoenix",
      "tripName": "Training Session",
      "departureDate": DateTime.now().add(Duration(days: 6)),
      "returnDate": DateTime.now().add(Duration(days: 8)),
      "estimatedCost": "\$1,450",
      "status": "Pending",
      "isUrgent": true,
      "businessJustification":
          "Mandatory compliance training for regional team",
      "submittedDate": DateTime.now().subtract(Duration(days: 4)),
      "department": "HR"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRequests {
    List<Map<String, dynamic>> filtered = _travelRequests;

    // Apply filter
    switch (_selectedFilter) {
      case 'Pending':
        filtered = filtered
            .where((request) => request['status'] == 'Pending')
            .toList();
        break;
      case 'Urgent':
        filtered =
            filtered.where((request) => request['isUrgent'] == true).toList();
        break;
      case 'All Requests':
        // Show all requests
        break;
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((request) {
        return (request['requestorName'] as String)
                .toLowerCase()
                .contains(searchTerm) ||
            (request['tripSummary'] as String)
                .toLowerCase()
                .contains(searchTerm) ||
            (request['department'] as String)
                .toLowerCase()
                .contains(searchTerm);
      }).toList();
    }

    return filtered;
  }

  int get _pendingCount {
    return _travelRequests
        .where((request) => request['status'] == 'Pending')
        .length;
  }

  int get _urgentCount {
    return _travelRequests
        .where((request) => request['isUrgent'] == true)
        .length;
  }

  void _handleApproval(String requestId, bool isApproved) {
    HapticFeedback.lightImpact();

    final request = _travelRequests.firstWhere((req) => req['id'] == requestId);
    final requestorName = request['requestorName'];
    final action = isApproved ? 'approved' : 'denied';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Travel request for $requestorName has been $action'),
        backgroundColor:
            isApproved ? AppTheme.approvedColor : AppTheme.rejectedColor,
        duration: Duration(seconds: 3),
      ),
    );

    setState(() {
      request['status'] = isApproved ? 'Approved' : 'Denied';
    });
  }

  void _handleBulkApproval() {
    if (_selectedRequests.isEmpty) return;

    HapticFeedback.mediumImpact();

    setState(() {
      for (String requestId in _selectedRequests) {
        final request =
            _travelRequests.firstWhere((req) => req['id'] == requestId);
        request['status'] = 'Approved';
      }
      _selectedRequests.clear();
      _isMultiSelectMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${_selectedRequests.length} requests approved successfully'),
        backgroundColor: AppTheme.approvedColor,
      ),
    );
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedRequests.clear();
      }
    });
  }

  void _toggleRequestSelection(String requestId) {
    setState(() {
      if (_selectedRequests.contains(requestId)) {
        _selectedRequests.remove(requestId);
      } else {
        _selectedRequests.add(requestId);
      }
    });
  }

  Future<void> _refreshRequests() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // In a real app, this would fetch fresh data from the server
    setState(() {
      // Refresh UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Manager Dashboard',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.elevationLevel1,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                }
              });
            },
            icon: CustomIconWidget(
              iconName: _isSearchVisible ? 'close' : 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          if (_isMultiSelectMode)
            IconButton(
              onPressed:
                  _selectedRequests.isNotEmpty ? _handleBulkApproval : null,
              icon: CustomIconWidget(
                iconName: 'check_circle',
                color: _selectedRequests.isNotEmpty
                    ? AppTheme.approvedColor
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                size: 24,
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'multi_select':
                  _toggleMultiSelect();
                  break;
                case 'profile':
                  Navigator.pushNamed(context, '/profile-settings');
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'multi_select',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: _isMultiSelectMode
                          ? 'check_box'
                          : 'check_box_outline_blank',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(_isMultiSelectMode
                        ? 'Exit Multi-Select'
                        : 'Multi-Select'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text('Profile Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_isSearchVisible ? 120 : 48),
          child: Column(
            children: [
              if (_isSearchVisible)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, destination, or department...',
                      prefixIcon: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Approvals'),
                        if (_pendingCount > 0) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.warningLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$_pendingCount',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Tab(text: 'Calendar'),
                  Tab(text: 'Reports'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildApprovalsTab(),
          _buildCalendarTab(),
          _buildReportsTab(),
        ],
      ),
    );
  }

  Widget _buildApprovalsTab() {
    return Column(
      children: [
        // Filter chips
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChipWidget(
                        label: 'Pending',
                        count: _pendingCount,
                        isSelected: _selectedFilter == 'Pending',
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Pending';
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChipWidget(
                        label: 'Urgent',
                        count: _urgentCount,
                        isSelected: _selectedFilter == 'Urgent',
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'Urgent';
                          });
                        },
                        isUrgent: true,
                      ),
                      SizedBox(width: 8),
                      FilterChipWidget(
                        label: 'All Requests',
                        count: _travelRequests.length,
                        isSelected: _selectedFilter == 'All Requests',
                        onTap: () {
                          setState(() {
                            _selectedFilter = 'All Requests';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Requests list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshRequests,
            child: _filteredRequests.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = _filteredRequests[index];
                      return ApprovalRequestCardWidget(
                        request: request,
                        isMultiSelectMode: _isMultiSelectMode,
                        isSelected: _selectedRequests.contains(request['id']),
                        onApprove: () => _handleApproval(request['id'], true),
                        onDeny: () => _handleApproval(request['id'], false),
                        onTap: () {
                          if (_isMultiSelectMode) {
                            _toggleRequestSelection(request['id']);
                          } else {
                            Navigator.pushNamed(
                                context, '/travel-request-detail-view');
                          }
                        },
                        onLongPress: () {
                          if (!_isMultiSelectMode) {
                            _toggleMultiSelect();
                            _toggleRequestSelection(request['id']);
                          }
                        },
                        onToggleSelection: () =>
                            _toggleRequestSelection(request['id']),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'inbox',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.4),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No requests found',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _selectedFilter == 'Pending'
                ? 'All travel requests have been processed'
                : 'Try adjusting your filters',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'calendar_today',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Travel Calendar',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Calendar view coming soon',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/travel-calendar');
            },
            child: Text('View Full Calendar'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'analytics',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Travel Reports',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Analytics and reporting features',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
