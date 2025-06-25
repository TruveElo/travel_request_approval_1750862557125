import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class BiometricPromptWidget extends StatefulWidget {
  const BiometricPromptWidget({super.key});

  @override
  State<BiometricPromptWidget> createState() => _BiometricPromptWidgetState();
}

class _BiometricPromptWidgetState extends State<BiometricPromptWidget> {
  bool _isBiometricAvailable = true;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    // Simulate biometric availability check
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isBiometricAvailable = true;
        _isBiometricEnabled = true;
      });
    }
  }

  Future<void> _handleBiometricAuth() async {
    try {
      // Simulate biometric authentication
      HapticFeedback.lightImpact();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Biometric Authentication',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Touch the fingerprint sensor or look at the camera to authenticate.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                    context, '/travel-requests-dashboard');
              },
              child: const Text('Use PIN'),
            ),
          ],
        ),
      );

      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(context);
        HapticFeedback.heavyImpact();
        Navigator.pushReplacementNamed(context, '/travel-requests-dashboard');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Biometric authentication failed. Please try again.'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable || !_isBiometricEnabled) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Divider
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
                'Quick Access',
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

        // Biometric Button
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.borderLight,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handleBiometricAuth,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusLarge),
                      ),
                      child: CustomIconWidget(
                        iconName: 'fingerprint',
                        color: AppTheme.primaryLight,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Use Biometric',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Touch ID / Face ID',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}