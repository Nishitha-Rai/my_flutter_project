import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_routes.dart';

class InitRoot extends StatefulWidget {
  const InitRoot({Key? key}) : super(key: key);

  @override
  State<InitRoot> createState() => _InitRootState();
}

class _InitRootState extends State<InitRoot> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes().generateRoute,
      initialRoute: RouteConstants.signUpPath,
      themeMode: ThemeMode.light,
      darkTheme: CustomThemeData.darkTheme,
      theme: CustomThemeData.lightTheme,
    );
  }
}
