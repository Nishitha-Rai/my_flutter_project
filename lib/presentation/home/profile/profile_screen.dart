import 'package:employee_insight/constants/image_constants.dart';
import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/data/model/user_model.dart';
import 'package:employee_insight/presentation/widgets/app_button.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box<User>('users');

    final profileTextStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
      color: AppColor.darkPurple,
      fontWeight: FontWeight.w600,
    );

    Future<void> logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('loggedInUserEmail');

      Navigator.of(context).pushNamed(RouteConstants.loginPath);
    }

    return AppScaffold(
      titleText: StringConstants.yourProfile,
      showBackArrow: true,
      scaffoldBody: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              profileImage,
              vSpacingTen,
              userName(box, profileTextStyle),
              vSpacingTen,
              userEmail(box, profileTextStyle),
              vSpacingTen,
              userEmployeeId(box, profileTextStyle),
              const SizedBox(height: 80),
              logoutButton(logout),
            ],
          ),
        ),
      ),
    );
  }

  Widget get profileImage => Padding(
    padding: const EdgeInsets.only(left: 30),
    child: SizedBox(
      height: 0.3.sh,
      width: 0.6.sw,
      child: Image.asset(
        ImageConstants.profilePng,
        fit: BoxFit.contain,
      ),
    ),
  );

  Widget vSpacingTen = const SizedBox(height: 10);

  Widget userName(Box<User> box, TextStyle? style) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "${box.values.first.firstName} ",
        style: style,
      ),
      Text(
        box.values.first.lastName,
        style: style,
      ),
    ],
  );

  Widget userEmail(Box<User> box, TextStyle? style) => Text(
    "${box.values.first.email} ",
    style: style,
  );

  Widget userEmployeeId(Box<User> box, TextStyle? style) => Text(
    "${box.values.first.employeeId} ",
    style: style,
  );

  Widget logoutButton(Function() logout) => AppButton(
    text: StringConstants.logout,
    onPressed: () {
      logout();
    },
  );
}