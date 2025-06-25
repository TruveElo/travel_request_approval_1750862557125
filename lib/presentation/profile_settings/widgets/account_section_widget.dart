import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AccountSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const AccountSectionWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Information',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              icon: 'person',
              label: 'Full Name',
              value: userData["name"] as String,
            ),
            Divider(height: 24),
            _buildInfoRow(
              icon: 'email',
              label: 'Email Address',
              value: userData["email"] as String,
            ),
            Divider(height: 24),
            _buildInfoRow(
              icon: 'business',
              label: 'Department',
              value: userData["department"] as String,
            ),
            Divider(height: 24),
            _buildInfoRow(
              icon: 'supervisor_account',
              label: 'Manager',
              value: userData["manager"] as String,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
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
              SizedBox(height: 2),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        CustomIconWidget(
          iconName: 'lock',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
      ],
    );
  }
}
