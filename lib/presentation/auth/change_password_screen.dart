import 'package:employee_insight/constants/image_constants.dart';
import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/data/model/user_model.dart';
import 'package:employee_insight/presentation/widgets/app_button.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:employee_insight/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? loggedInEmail;

  @override
  void initState() {
    super.initState();
    _loadLoggedInEmail();
  }

  Future<void> _loadLoggedInEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInEmail = prefs.getString('loggedInUserEmail');
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: StringConstants.changePassword,
      showBackArrow: true,
      scaffoldBody: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              vSpacingTen,
              vSpacingTen,
              changePasswordImage,
              vSpacingTen,
              vSpacingTen,
              oldPasswordField,
              vSpacingTen,
              newPasswordField,
              vSpacingTen,
              confirmPasswordField,
              const SizedBox(height: 40),
              submitButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get vSpacingTen => const SizedBox(height: 10);

  Widget get changePasswordImage => Padding(
    padding: const EdgeInsets.only(left: 30),
    child: SizedBox(
      height: 0.3.sh,
      width: 0.6.sw,
      child: Image.asset(
        ImageConstants.changePasswordPng,
        fit: BoxFit.contain,
      ),
    ),
  );

  Widget get oldPasswordField => CustomTextField(
    labelText: StringConstants.oldPassword,
    obscureText: true,
    controller: _oldPasswordController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return StringConstants.enterOldPassword;
      }
      return null;
    },
  );

  Widget get newPasswordField => CustomTextField(
    labelText: StringConstants.newPassword,
    obscureText: true,
    controller: _newPasswordController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return StringConstants.enterNewPassword;
      }
      return null;
    },
  );

  Widget get confirmPasswordField => CustomTextField(
    labelText: StringConstants.confirmPassword,
    obscureText: true,
    controller: _confirmPasswordController,
    validator: (value) {
      if (value != _newPasswordController.text) {
        return StringConstants.passwordError;
      }
      return null;
    },
  );

  Widget get submitButton => AppButton(
    onPressed: () async {
      if (_formKey.currentState!.validate()) {
        var box = Hive.box<User>('users');
        User? user = box.values.cast<User?>().firstWhere(
              (user) => user?.email == loggedInEmail,
          orElse: () => null,
        );
        if (user != null && user.password == _oldPasswordController.text) {
          user.password = _newPasswordController.text;
          // Used email as the key to save the updated user
          box.put(user.email, user);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(StringConstants.passwordChangeSuccess)),
          );
          Navigator.of(context).pushNamed(RouteConstants.loginPath);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(StringConstants.oldPasswordIncorrect)),
          );
        }
      }
    },
    text: StringConstants.submit,
  );
}
