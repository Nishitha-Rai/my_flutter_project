import 'package:employee_insight/constants/image_constants.dart';
import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeCardText = Theme.of(context)
        .textTheme
        .headlineLarge
        ?.copyWith(fontWeight: FontWeight.w600);

    return AppScaffold(
      titleText: StringConstants.title,
      showDrawerIcon: true,
      scaffoldBody: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            SizedBox(
              height: 0.5.sh,
              width: 0.8.sw,
              child: Image.asset(
                ImageConstants.officePng,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RouteConstants.leaveDetailsPath);
              },
              child: Container(
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.2, 0.9],
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.75),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                    ],
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Text(
                    StringConstants.employeeLeave,
                    style: employeeCardText,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(RouteConstants.salaryDetailsPath);
              },
              child: Container(
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.2, 0.9],
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.75),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                    ],
                  ),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Center(
                  child: Text(
                    StringConstants.employeeSalary,
                    style: employeeCardText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
