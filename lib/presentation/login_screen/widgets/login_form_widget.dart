import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onLogin,
    required this.onForgotPassword,
  });

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Corporate email is required';
    }

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid corporate email address';
    }

    // Corporate domain validation
    if (!value.contains('@company.com') && !value.contains('@corp.com')) {
      return 'Please use your corporate email domain';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Corporate password requirements
    if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
        .hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, number and special character';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          TextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !isLoading,
            validator: _validateEmail,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            decoration: InputDecoration(
              labelText: 'Corporate Email',
              hintText: 'Enter your corporate email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Password Field
          TextFormField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            obscureText: !isPasswordVisible,
            textInputAction: TextInputAction.done,
            enabled: !isLoading,
            validator: _validatePassword,
            onFieldSubmitted: (_) => onLogin(),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: isLoading ? null : onTogglePasswordVisibility,
                icon: CustomIconWidget(
                  iconName: isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.textSecondaryLight,
                  size: 20,
                ),
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading ? null : onForgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Sign In Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Signing In...',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Sign In',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
