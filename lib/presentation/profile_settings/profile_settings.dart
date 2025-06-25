import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/account_section_widget.dart';
import './widgets/app_settings_section_widget.dart';
import './widgets/notifications_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/travel_preferences_section_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@company.com",
    "department": "Marketing",
    "manager": "Michael Rodriguez",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    "defaultOriginCity": "New York",
    "preferredAirlines": ["Delta", "American Airlines", "United"],
    "accommodationPreference": "Business Hotel",
    "expenseCategories": ["Meals", "Transportation", "Lodging", "Other"],
    "biometricEnabled": true,
    "offlineSync": true,
    "dataUsage": "WiFi Only",
    "notifications": {
      "approvalUpdates": true,
      "deadlineReminders": true,
      "teamNotifications": false
    }
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.cardColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Profile Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Edit profile functionality
            },
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.primaryColor,
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
                color: _tabController.index == 0
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Dashboard',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'flight_takeoff',
                color: _tabController.index == 1
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Requests',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'calendar_today',
                color: _tabController.index == 2
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Calendar',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'person',
                color: _tabController.index == 3
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              text: 'Profile',
            ),
          ],
          onTap: (index) {
            if (index != 3) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(
                      context, '/travel-requests-dashboard');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(
                      context, '/travel-requests-dashboard');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, '/travel-calendar');
                  break;
              }
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(), // Dashboard placeholder
          Container(), // Requests placeholder
          Container(), // Calendar placeholder
          _buildProfileContent(),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderWidget(userData: userData),
          SizedBox(height: 24),
          AccountSectionWidget(userData: userData),
          SizedBox(height: 24),
          TravelPreferencesSectionWidget(userData: userData),
          SizedBox(height: 24),
          NotificationsSectionWidget(userData: userData),
          SizedBox(height: 24),
          AppSettingsSectionWidget(userData: userData),
          SizedBox(height: 32),
          _buildLogoutSection(),
          SizedBox(height: 24),
          _buildFooterSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'logout',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: Text(
                'Logout',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.errorLight,
                ),
              ),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support & Information',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text(
                'Help & Support',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              onTap: () {
                // Open support chat
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text(
                'App Version',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              subtitle: Text(
                'Version 1.0.0 (Build 100)',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CustomIconWidget(
                iconName: 'contact_support',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text(
                'Contact Support',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              subtitle: Text(
                'support@company.com',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              onTap: () {
                // Open email client
              },
            ),
          ],
        ),
      ),
    );
  }
}
