import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AppSettingsSectionWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AppSettingsSectionWidget({
    super.key,
    required this.userData,
  });

  @override
  State<AppSettingsSectionWidget> createState() =>
      _AppSettingsSectionWidgetState();
}

class _AppSettingsSectionWidgetState extends State<AppSettingsSectionWidget> {
  late bool biometricEnabled;
  late bool offlineSync;
  late String dataUsage;

  final List<String> dataUsageOptions = [
    'WiFi Only',
    'WiFi + Cellular',
    'Always Ask'
  ];

  @override
  void initState() {
    super.initState();
    biometricEnabled = widget.userData["biometricEnabled"] as bool;
    offlineSync = widget.userData["offlineSync"] as bool;
    dataUsage = widget.userData["dataUsage"] as String;
  }

  String _getBiometricType() {
    // Mock biometric type detection
    return 'Face ID'; // Could be 'Touch ID', 'Fingerprint', etc.
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
              'App Settings',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            _buildBiometricToggle(),
            Divider(height: 24),
            _buildOfflineSyncToggle(),
            Divider(height: 24),
            _buildDataUsageSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricToggle() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'fingerprint',
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Biometric Authentication',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              SizedBox(height: 2),
              Text(
                'Use ${_getBiometricType()} to secure app access',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Switch(
          value: biometricEnabled,
          onChanged: (value) {
            setState(() {
              biometricEnabled = value;
            });
            _showConfirmationSnackBar(
                'Biometric authentication ${value ? 'enabled' : 'disabled'}');
          },
        ),
      ],
    );
  }

  Widget _buildOfflineSyncToggle() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'sync',
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Offline Sync',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              SizedBox(height: 2),
              Text(
                'Sync data for offline access',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Switch(
          value: offlineSync,
          onChanged: (value) {
            setState(() {
              offlineSync = value;
            });
            _showConfirmationSnackBar(
                'Offline sync ${value ? 'enabled' : 'disabled'}');
          },
        ),
      ],
    );
  }

  Widget _buildDataUsageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'data_usage',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Usage',
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Control when app uses cellular data',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dataUsage,
              isExpanded: true,
              items: dataUsageOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    dataUsage = newValue;
                  });
                  _showConfirmationSnackBar('Data usage set to $newValue');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showConfirmationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
