import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/travel_requests_dashboard/travel_requests_dashboard.dart';
import '../presentation/travel_calendar/travel_calendar.dart';
import '../presentation/travel_request_detail_view/travel_request_detail_view.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/manager_approval_dashboard/manager_approval_dashboard.dart';
import '../presentation/new_travel_request_form/new_travel_request_form.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String travelRequestsDashboard = '/travel-requests-dashboard';
  static const String newTravelRequestForm = '/new-travel-request-form';
  static const String travelRequestDetailView = '/travel-request-detail-view';
  static const String travelCalendar = '/travel-calendar';
  static const String managerApprovalDashboard = '/manager-approval-dashboard';
  static const String profileSettings = '/profile-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    travelRequestsDashboard: (context) => const TravelRequestsDashboard(),
    newTravelRequestForm: (context) => const NewTravelRequestForm(),
    travelRequestDetailView: (context) => const TravelRequestDetailView(),
    travelCalendar: (context) => const TravelCalendar(),
    managerApprovalDashboard: (context) => const ManagerApprovalDashboard(),
    profileSettings: (context) => const ProfileSettings(),
  };
}
