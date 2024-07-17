import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/presentation/widgets/app_button.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .headlineLarge
        ?.copyWith(color: AppColor.colorWhite);

    return AppScaffold(
      titleText: 'Employee Insight',
      scaffoldBody: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteConstants.leaveDetailsPath);
              },
              text: StringConstants.employeeLeave,
            ),
            SizedBox(height: 20),
            AppButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(RouteConstants.salaryDetailsPath);
              },
              text: StringConstants.employeeSalary,
            ),
          ],
        ),
      ),
    );
  }
}
