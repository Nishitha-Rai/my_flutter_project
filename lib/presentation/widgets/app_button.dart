import 'package:flutter/material.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  AppButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .headlineLarge
        ?.copyWith(color: AppColor.colorWhite);

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColor.primaryColor),
      ),
      child: Text(text, style: buttonTextStyle),
    );
  }
}
