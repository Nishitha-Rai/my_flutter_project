import 'package:employee_insight/constants/image_constants.dart';
import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/data/model/user_model.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:employee_insight/presentation/widgets/app_button.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:employee_insight/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldBody: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              vSpacingThirty,
              Center(
                child: Text(
                  StringConstants.welcomeText,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              vSpacingTen,
              Center(
                child: Text(
                  StringConstants.loginText,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppColor.primaryColor),
                ),
              ),
              vSpacingThirty,
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: SizedBox(
                  height: 0.3.sh,
                  width: 0.6.sw,
                  child: Image.asset(
                    ImageConstants.loginPng,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              vSpacingThirty,
              vSpacingTen,
              vSpacingTen,
              emailField,
              vSpacingThirty,
              passwordField,
              vSpacingTen,
              vSpacingTen,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(StringConstants.createAccount),
                  SizedBox(width: 5),
                  GestureDetector(
                    child: Text(
                      StringConstants.registration,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColor.darkPurple),
                    ),
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteConstants.signUpPath),
                  ),
                ],
              ),
              vSpacingThirty,
              AppButton(
                onPressed: _login,
                text: StringConstants.submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get vSpacingTen => const SizedBox(height: 10);

  Widget get vSpacingThirty => const SizedBox(height: 30);

  Widget get emailField => CustomTextField(
    controller: _emailController,
    labelText: StringConstants.email,
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return StringConstants.enterEmailId;
      }
      return null;
    },
  );

  Widget get passwordField => CustomTextField(
    controller: _passwordController,
    labelText: StringConstants.password,
    obscureText: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return StringConstants.enterPassword;
      }
      return null;
    },
  );

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      var box = Hive.box<User>('users');
      User? user = box.values.cast<User?>().firstWhere(
            (user) =>
        user?.email == _emailController.text &&
            user?.password == _passwordController.text,
        orElse: () => null,
      );
      if (user != null) {
        // Stores logged in email id
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loggedInUserEmail', user.email);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(StringConstants.loginSuccess)),
        );

        Navigator.of(context).pushNamed(RouteConstants.homePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(StringConstants.loginError)),
        );
      }
    }
  }
}