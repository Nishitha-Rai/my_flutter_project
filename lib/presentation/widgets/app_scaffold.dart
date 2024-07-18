import 'package:employee_insight/constants/image_constants.dart';
import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.titleText,
    required this.scaffoldBody,
    this.appbarBottomWidget,
    this.showBackArrow = false,
    this.showDrawerIcon = false,
  });

  final Widget scaffoldBody;
  final String? titleText;
  final PreferredSizeWidget? appbarBottomWidget;
  final bool showBackArrow;
  final bool showDrawerIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: titleText != null ? buildAppBar(context) : null,
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
      drawer: showDrawerIcon ? buildDrawer(context) : null,
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      leading: showBackArrow
          ? GestureDetector(
        child: Icon(
          Icons.keyboard_arrow_left,
          color: Theme.of(context).primaryColorDark,
          size: 30,
        ),
        onTap: () => onPressedAction(context),
      )
          : Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text(
        titleText ?? StringConstants.empty,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.8],
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.75),
              Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ],
          ),
        ),
      ),
      bottom: appbarBottomWidget ??
          const PreferredSize(
            preferredSize: Size.zero,
            child: SizedBox.shrink(),
          ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    final drawerTextStyle = Theme.of(context).textTheme.headlineMedium;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.1, 0.8],
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.75),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child:  Text(
                StringConstants.menu,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColor.colorWhite
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              StringConstants.profile,
              style: drawerTextStyle,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(RouteConstants.profilePath);
            },
          ),
          ListTile(
            title: Text(
              StringConstants.changePassword,
              style: drawerTextStyle,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(RouteConstants.changePasswordPath);
            },
          ),
          ListTile(
            title: Text(
              StringConstants.logout,
              style: drawerTextStyle,
            ),
            onTap: () {
              logout();
              Navigator.of(context).pushNamed(RouteConstants.loginPath);
            },
          ),
        ],
      ),
    );
  }

  void onPressedAction(BuildContext context) {
    Navigator.of(context).pushNamed(RouteConstants.homePath);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserEmail');
  }
}