import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: userData["profileImage"] as String,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.cardColor,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData["name"] as String,
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    userData["email"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userData["department"] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
