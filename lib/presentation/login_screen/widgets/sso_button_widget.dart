import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SSOButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const SSOButtonWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.borderLight,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.borderLight,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // SSO Button
        SizedBox(
          height: 6.h,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppTheme.borderLight,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomIconWidget(
                    iconName: 'business',
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Sign in with SSO',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.textPrimaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // SSO Info Text
        Text(
          'Use your corporate identity provider',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
