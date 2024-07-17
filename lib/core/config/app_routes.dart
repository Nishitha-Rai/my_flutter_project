import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/presentation/auth/change_password_screen.dart';
import 'package:employee_insight/presentation/auth/login_screen.dart';
import 'package:employee_insight/presentation/auth/sign_up_screen.dart';
import 'package:employee_insight/presentation/home/home_screen.dart';
import 'package:employee_insight/presentation/home/leave/leave_details_screen.dart';
import 'package:employee_insight/presentation/home/profile/profile_screen.dart';
import 'package:employee_insight/presentation/home/salary/salary_details_screen.dart';
import 'package:employee_insight/presentation/offline/offline_screen.dart';
import 'package:employee_insight/presentation/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class AppRoutes {  Route generateRoute(RouteSettings routeSettings) {

    return MaterialPageRoute(
        builder: (_) => OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivityResult, Widget child) {
                final bool connected =
                    connectivityResult != ConnectivityResult.none;
                if (!connected) {
                  return const OfflineScreen();
                }
                return getScreen(routeSettings);
              },
              child: const SizedBox.shrink(),
            ),
        settings: routeSettings);
  }

  Widget getScreen(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouteConstants.signUpPath:
        return const SignUpScreen();
      case RouteConstants.loginPath:
        return const LoginScreen();
      case RouteConstants.changePasswordPath:
        return const ChangePasswordScreen();
      case RouteConstants.homePath:
        return const HomeScreen();
      case RouteConstants.leaveDetailsPath:
        return const LeaveDetailsScreen();
      case RouteConstants.salaryDetailsPath:
        return const SalaryDetailsScreen();
      case RouteConstants.profilePath:
        return ProfileScreen();
      case RouteConstants.splashPath:
        return const SplashScreen();

      default:
        return const SplashScreen();
    }
  }
}
