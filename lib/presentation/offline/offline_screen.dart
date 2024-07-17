import 'package:employee_insight/constants/string_constants.dart';
import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          StringConstants.connectInternet,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
