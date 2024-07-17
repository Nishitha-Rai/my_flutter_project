import 'dart:async';
import 'package:employee_insight/constants/image_constants.dart';
import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getInitRoute();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            ImageConstants.backgroundJpg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 100),
            child: Column(
              children: [
                SizedBox(
                  height: 0.5.sh,
                  width: 0.8.sw,
                  child: Image.asset(
                    ImageConstants.splashImageGif,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Text(
                  StringConstants.title,
                  style: Theme.of(context).textTheme.displaySmall,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void getInitRoute() {
    Timer(const Duration(seconds: 7), () {
      Navigator.of(context).pushReplacementNamed(
        RouteConstants.loginPath,
      );
    });
  }
}
