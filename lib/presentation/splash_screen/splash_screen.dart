import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showRetryButton = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationToken(),
        _loadUserPermissions(),
        _fetchTravelPolicies(),
        _prepareCachedDrafts(),
      ]);

      // Minimum splash duration
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        _handleInitializationError();
      }
    }
  }

  Future<void> _checkAuthenticationToken() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadUserPermissions() async {
    // Simulate loading user permissions
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _fetchTravelPolicies() async {
    // Simulate fetching travel policies
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _prepareCachedDrafts() async {
    // Simulate preparing cached draft requests
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToNextScreen() {
    // Mock authentication status - in real app, check actual auth state
    final bool isAuthenticated = _mockAuthenticationCheck();
    final bool isFirstTime = _mockFirstTimeCheck();

    if (isFirstTime) {
      // Navigate to onboarding (using login as placeholder)
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    } else if (isAuthenticated) {
      // Navigate to dashboard
      Navigator.pushReplacementNamed(
          context, AppRoutes.travelRequestsDashboard);
    } else {
      // Navigate to login
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }

  bool _mockAuthenticationCheck() {
    // Mock logic - in real app, check stored tokens
    return DateTime.now().millisecond % 2 == 0;
  }

  bool _mockFirstTimeCheck() {
    // Mock logic - in real app, check if user has completed onboarding
    return DateTime.now().millisecond % 3 == 0;
  }

  void _handleInitializationError() {
    setState(() {
      _isLoading = false;
      _showRetryButton = true;
    });

    // Auto-retry after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted && _showRetryButton) {
        _retryInitialization();
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _isLoading = true;
      _showRetryButton = false;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                AppTheme.lightTheme.colorScheme.secondary,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: _buildLogo(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: _buildCompanyName(),
                          );
                        },
                      ),
                      const SizedBox(height: 64),
                      _buildLoadingSection(),
                    ],
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'flight_takeoff',
          color: AppTheme.lightTheme.primaryColor,
          size: 64,
        ),
      ),
    );
  }

  Widget _buildCompanyName() {
    return Column(
      children: [
        Text(
          'TravelRequest',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enterprise Travel Management',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    if (_showRetryButton) {
      return Column(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            'Connection timeout',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryInitialization,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.lightTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Retry',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return _isLoading
        ? Column(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Initializing...',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          Text(
            'Powered by Enterprise Solutions',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
