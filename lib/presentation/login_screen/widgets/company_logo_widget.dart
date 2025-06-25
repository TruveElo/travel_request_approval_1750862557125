import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompanyLogoWidget extends StatelessWidget {
  const CompanyLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          // Logo Container
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryLight,
                  AppTheme.primaryLight.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'business_center',
              color: Colors.white,
              size: 10.w,
            ),
          ),

          SizedBox(height: 2.h),

          // Company Name
          Text(
            'TravelRequest',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryLight,
            ),
          ),

          SizedBox(height: 0.5.h),

          // Tagline
          Text(
            'Enterprise Travel Management',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
