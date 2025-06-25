import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/company_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/sso_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final bool _rememberMe = false;
  String? _errorMessage;

  // Mock credentials for enterprise authentication
  final Map<String, String> _mockCredentials = {
    'admin@company.com': 'Admin123!',
    'manager@company.com': 'Manager456!',
    'employee@company.com': 'Employee789!',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate credentials
    if (_mockCredentials.containsKey(email) &&
        _mockCredentials[email] == password) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        // Navigate to dashboard
        Navigator.pushReplacementNamed(context, '/travel-requests-dashboard');
      }
    } else {
      setState(() {
        _errorMessage =
            'Invalid email or password. Please check your credentials and try again.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Password Reset',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Please contact your IT administrator or visit the corporate self-service portal to reset your password.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleSSOLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'SSO Authentication',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Redirecting to corporate identity provider...',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8.h),

                    // Company Logo
                    CompanyLogoWidget(),

                    SizedBox(height: 6.h),

                    // Welcome Text
                    Text(
                      'Welcome Back',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Sign in to access your travel requests',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 4.h),

                    // Error Message
                    _errorMessage != null
                        ? Container(
                            margin: EdgeInsets.only(bottom: 2.h),
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.errorLight.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMedium),
                              border: Border.all(
                                color:
                                    AppTheme.errorLight.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'error_outline',
                                  color: AppTheme.errorLight,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.errorLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),

                    // Login Form
                    LoginFormWidget(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      emailFocusNode: _emailFocusNode,
                      passwordFocusNode: _passwordFocusNode,
                      isPasswordVisible: _isPasswordVisible,
                      isLoading: _isLoading,
                      onTogglePasswordVisibility: _togglePasswordVisibility,
                      onLogin: _handleLogin,
                      onForgotPassword: _handleForgotPassword,
                    ),

                    SizedBox(height: 3.h),

                    // SSO Button
                    SSOButtonWidget(
                      onPressed: _isLoading ? null : _handleSSOLogin,
                    ),

                    SizedBox(height: 4.h),

                    // Biometric Authentication
                    BiometricPromptWidget(),

                    SizedBox(height: 4.h),

                    // Security Indicator
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'security',
                            color: AppTheme.successLight,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Secure encrypted connection',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.successLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
