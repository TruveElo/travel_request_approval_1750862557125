import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/calendar_grid_widget.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/filter_toggle_widget.dart';
import './widgets/travel_bar_widget.dart';
import './widgets/trip_detail_bottom_sheet.dart';

class TravelCalendar extends StatefulWidget {
  const TravelCalendar({super.key});

  @override
  State<TravelCalendar> createState() => _TravelCalendarState();
}

class _TravelCalendarState extends State<TravelCalendar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  DateTime _selectedDate = DateTime.now();
  bool _showMyTrips = true;
  bool _isLoading = false;
  String _searchQuery = '';
  DateTime _lastSyncTime = DateTime.now();

  // Mock data for travel requests
  final List<Map<String, dynamic>> _travelData = [
    {
      "id": 1,
      "title": "Client Meeting NYC",
      "destination": "New York",
      "origin": "San Francisco",
      "startDate": DateTime.now().add(Duration(days: 5)),
      "endDate": DateTime.now().add(Duration(days: 7)),
      "requestor": "John Smith",
      "status": "approved",
      "cost": "\$2,500",
      "attendees": ["Sarah Johnson", "Mike Wilson"],
      "purpose": "Client presentation and contract negotiation",
      "color": AppTheme.lightTheme.primaryColor,
    },
    {
      "id": 2,
      "title": "Conference LA",
      "destination": "Los Angeles",
      "origin": "Seattle",
      "startDate": DateTime.now().add(Duration(days: 12)),
      "endDate": DateTime.now().add(Duration(days: 14)),
      "requestor": "Emily Davis",
      "status": "approved",
      "cost": "\$1,800",
      "attendees": ["Tom Brown"],
      "purpose": "Tech conference attendance and networking",
      "color": AppTheme.successLight,
    },
    {
      "id": 3,
      "title": "Training Boston",
      "destination": "Boston",
      "origin": "Chicago",
      "startDate": DateTime.now().add(Duration(days: 20)),
      "endDate": DateTime.now().add(Duration(days: 22)),
      "requestor": "Alex Chen",
      "status": "approved",
      "cost": "\$1,200",
      "attendees": ["Lisa Wang"],
      "purpose": "Professional development training",
      "color": AppTheme.warningLight,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _pageController = PageController(initialPage: 0);
    _loadTravelData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadTravelData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      _lastSyncTime = DateTime.now();
    });
  }

  Future<void> _refreshData() async {
    await _loadTravelData();
  }

  void _navigateToMonth(int direction) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + direction,
        1,
      );
    });
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  void _showTripDetails(Map<String, dynamic> trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TripDetailBottomSheet(trip: trip),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Search Trips',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search by destination, date, or person...',
            prefixIcon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _searchQuery = '';
              });
            },
            child: Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTrips() {
    List<Map<String, dynamic>> filtered = _travelData;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((trip) {
        return (trip["destination"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (trip["requestor"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (trip["title"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_showMyTrips) {
      filtered = filtered
          .where((trip) => (trip["requestor"] as String) == "John Smith")
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Travel Calendar',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        actions: [
          IconButton(
            onPressed: _showSearchDialog,
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile-settings'),
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'dashboard',
                color: AppTheme.lightTheme.tabBarTheme.unselectedLabelColor,
                size: 20,
              ),
              text: 'Dashboard',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.lightTheme.tabBarTheme.labelColor,
                size: 20,
              ),
              text: 'Calendar',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'approval',
                color: AppTheme.lightTheme.tabBarTheme.unselectedLabelColor,
                size: 20,
              ),
              text: 'Approvals',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, '/travel-requests-dashboard');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/manager-approval-dashboard');
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              )
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Calendar Header with Month Navigation
                    CalendarHeaderWidget(
                      selectedDate: _selectedDate,
                      onPreviousMonth: () => _navigateToMonth(-1),
                      onNextMonth: () => _navigateToMonth(1),
                      onTodayPressed: _goToToday,
                      lastSyncTime: _lastSyncTime,
                    ),

                    // Filter Toggle
                    FilterToggleWidget(
                      showMyTrips: _showMyTrips,
                      onToggle: (value) {
                        setState(() {
                          _showMyTrips = value;
                        });
                      },
                    ),

                    // Calendar Grid
                    CalendarGridWidget(
                      selectedDate: _selectedDate,
                      travelData: _getFilteredTrips(),
                      onTripTap: _showTripDetails,
                      onDateTap: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),

                    // Travel Bars Section
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming Trips',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          SizedBox(height: 12),
                          _getFilteredTrips().isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _getFilteredTrips().length,
                                  itemBuilder: (context, index) {
                                    final trip = _getFilteredTrips()[index];
                                    return TravelBarWidget(
                                      trip: trip,
                                      onTap: () => _showTripDetails(trip),
                                      onLongPress: () => _showContextMenu(trip),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/new-travel-request-form'),
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'flight_takeoff',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No trips scheduled',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start planning your next business trip!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/new-travel-request-form'),
            child: Text('Create Trip Request'),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> trip) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('View Full Details'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/travel-request-detail-view');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Add to Device Calendar'),
              onTap: () {
                Navigator.pop(context);
                // Add to device calendar functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share Trip'),
              onTap: () {
                Navigator.pop(context);
                // Share trip functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
