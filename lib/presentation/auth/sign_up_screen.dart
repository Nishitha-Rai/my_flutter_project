import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/data/model/user_model.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:employee_insight/presentation/widgets/app_button.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:employee_insight/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _employeeIdController.dispose();
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
              vSpacingTwenty,
              vSpacingTen,
              Center(
                child: Text(
                  StringConstants.signUpText,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              vSpacingTen,
              Center(
                child: Text(
                  StringConstants.createAccountText,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppColor.primaryColor),
                ),
              ),
              vSpacingTwenty,
              vSpacingTen,
              firstNameField,
              vSpacingTwenty,
              lastNameField,
              vSpacingTwenty,
              emailField,
              vSpacingTwenty,
              employeeIdField,
              vSpacingTwenty,
              passwordField,
              vSpacingTwenty,
              confirmPasswordField,
              vSpacingTwenty,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(StringConstants.haveAccount),
                  const SizedBox(width: 5),
                  GestureDetector(
                    child: Text(
                      StringConstants.login,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColor.darkPurple),
                    ),
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteConstants.loginPath),
                  ),
                ],
              ),
              vSpacingTen,
              vSpacingTen,
              vSpacingTen,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: AppButton(
                  onPressed: _signUp,
                  text: StringConstants.submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get vSpacingTen => const SizedBox(height: 10);

  Widget get vSpacingTwenty => const SizedBox(height: 10);

  Widget get firstNameField => CustomTextField(
    controller: _firstNameController,
    labelText: StringConstants.firstName,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return StringConstants.enterFirstName;
      }
      return null;
    },
  );

  Widget get lastNameField => CustomTextField(
    controller: _lastNameController,
    labelText: StringConstants.lastName,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return StringConstants.enterLastName;
      }
      return null;
    },
  );

  Widget get emailField => CustomTextField(
    controller: _emailController,
    labelText: StringConstants.email,
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return StringConstants.enterEmail;
      }
      return null;
    },
  );

  Widget get employeeIdField => CustomTextField(
    controller: _employeeIdController,
    labelText: StringConstants.employeeId,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return StringConstants.enterEmployeeId;
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

  Widget get confirmPasswordField => CustomTextField(
    labelText: StringConstants.confirmPassword,
    obscureText: true,
    validator: (value) {
      if (value != _passwordController.text) {
        return StringConstants.passwordError;
      }
      return null;
    },
  );

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      var box = Hive.box<User>('users');
      var existingUser = box.values.firstWhere(
            (user) => user.email == _emailController.text,
        orElse: () => User(
          firstName: '',
          lastName: '',
          email: '',
          employeeId: '',
          password: '',
        ),
      );
      if (existingUser.email.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(StringConstants.emailExist)),
        );
      } else {
        var newUser = User(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          employeeId: _employeeIdController.text,
          password: _passwordController.text,
        );
        await box.add(newUser);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(StringConstants.signUpSuccess)),
        );

        Navigator.of(context).pushNamed(RouteConstants.loginPath);
      }
    }
  }
}