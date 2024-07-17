import 'package:employee_insight/constants/image_constants.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.titleText,
    required this.scaffoldBody,
    this.appbarBottomWidget,
    this.showLogo,
    this.iconOnPressed,
  });

  final Widget scaffoldBody;
  final String titleText;
  final bool? showLogo;
  final PreferredSizeWidget? appbarBottomWidget;
  final VoidCallback? iconOnPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: Center(
          child: GestureDetector(
            child: Icon(
              Icons.keyboard_arrow_left,
              color: Theme.of(context).primaryColorDark,
              size: 28,
            ),
            onTap: () => onPressedAction(context),
          ),
        ),
        title: Text(titleText,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [
                  0.1,
                  0.8
                ],
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.75),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                ]),
          ),
        ),
        // actions: [
        //   (showLogo ?? false) == true
        //       ? Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Image.asset(ACSConstants.splashLogo),
        //   )
        //       : const SizedBox.shrink()
        // ],
        bottom: appbarBottomWidget ??
            const PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox.shrink(),
            ),
      ),
      body: Stack(
        children: [
          Image.asset(
            ImageConstants.backgroundJpg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          scaffoldBody,
        ],
      ),
    );
  }

  void onPressedAction(BuildContext context) {
    if (iconOnPressed != null) {
      iconOnPressed!();
    } else {
      Navigator.of(context).pop();
    }
  }
}
