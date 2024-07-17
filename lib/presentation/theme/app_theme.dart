import 'package:flutter/material.dart';
import 'app_color.dart';

class CustomThemeData {
  static ThemeData lightTheme = ThemeData(
      fontFamily: 'OpenSans',
      primaryColorDark: AppColor.colorBlack,
      primaryColorLight: AppColor.colorWhite,
      scaffoldBackgroundColor: AppColor.lightScaffoldBackgroundColor,
      cardColor: AppColor.containerColor,
      dividerColor: AppColor.lighterGrey,
      disabledColor: AppColor.transparent,
      focusColor: AppColor.borderGrey,
      hintColor: AppColor.fontGrey,
      hoverColor: AppColor.lightGrey,
      indicatorColor: AppColor.lighterGrey,
      canvasColor: AppColor.buttonBackgroundColor,
      highlightColor: AppColor.successGreen,
      buttonTheme:
          const ButtonThemeData(buttonColor: AppColor.buttonBackgroundColor),
      colorScheme: const ColorScheme.light(
        primary: AppColor.primaryColor,
        secondary: AppColor.secondaryColor,
        primaryContainer: AppColor.containerColor,
        error: AppColor.errorRed,
        tertiary: AppColor.selectionRedColor,
      ),
      iconTheme: const IconThemeData(color: AppColor.primaryColor),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColor.fontBlackColor,
          fontSize: 36, //57
          fontWeight: FontWeight.w600,
        ),
        displayMedium: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 27, //45
            fontWeight: FontWeight.w600),
        displaySmall: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 24, //36
            fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 20, //32
            fontWeight: FontWeight.w400),
        headlineMedium: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 18, //28
            fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 16, //24
            fontWeight: FontWeight.w400),
        titleLarge: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 14, //22
            fontWeight: FontWeight.w400),
        titleMedium: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 12, //16
            fontWeight: FontWeight.w400),
        titleSmall: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 10, //14
            fontWeight: FontWeight.w400),
        labelLarge: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        labelMedium: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
        labelSmall: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 11,
            fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
            color: AppColor.fontBlackColor,
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
          backgroundColor:
              MaterialStateProperty.all(AppColor.buttonBackgroundColor),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.lightGrey,
        backgroundColor: AppColor.colorWhite,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(AppColor.colorBlack),
      ));

  static ThemeData darkTheme = ThemeData.dark().copyWith(
      unselectedWidgetColor: Colors.grey,
      colorScheme: const ColorScheme.dark(
        primary: AppColor.primaryColor,
        secondary: AppColor.secondaryColor,
        primaryContainer: AppColor.colorWhite,
        tertiary: AppColor.colorWhite,
        tertiaryContainer: AppColor.colorWhite,
      ),
      iconTheme: const IconThemeData(color: AppColor.primaryColor),
      cardColor: AppColor.containerColor,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            color: AppColor.colorWhite,
            fontSize: 36,
            fontWeight: FontWeight.w600),
        displayMedium: TextStyle(
            color: AppColor.colorWhite,
            fontSize: 27,
            fontWeight: FontWeight.w600),
        displaySmall: TextStyle(
            color: AppColor.colorWhite,
            fontSize: 24,
            fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(
            color: AppColor.colorWhite,
            fontSize: 14,
            fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(
            color: AppColor.colorWhite,
            fontSize: 12,
            fontWeight: FontWeight.w400),
        titleLarge: TextStyle(
            color: AppColor.colorWhite,
            fontSize: 10,
            fontWeight: FontWeight.w400),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          )),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.lightGrey,
        backgroundColor: AppColor.colorWhite,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(AppColor.colorBlack),
      ));
}
