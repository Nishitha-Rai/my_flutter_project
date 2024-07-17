import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/data/model/user_model.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:employee_insight/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants.changePassword),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CustomTextField(
                labelText: StringConstants.oldPassword,
                obscureText: true,
                controller: _oldPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterOldPassword;
                  }
                  return null;
                },
              ),
              CustomTextField(
                labelText: StringConstants.newPassword,
                obscureText: true,
                controller: _newPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterNewPassword;
                  }
                  return null;
                },
              ),
              CustomTextField(
                labelText: StringConstants.confirmPassword,
                obscureText: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return StringConstants.passwordError;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var box = Hive.box<User>('users');
                    User? user = box.values.cast<User?>().firstWhere(
                          (user) => user?.email == loggedInEmail,
                      orElse: () => null,
                    );
                    print("user password is..${user?.password}");
                    if (user != null && user.password == _oldPasswordController.text) {

                      user.password = _newPasswordController.text;
                      box.put(user.email, user);  // Use the email as the key to save the updated user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(StringConstants.passwordChangeSuccess)),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(StringConstants.oldPasswordIncorrect)),
                      );
                    }
                  }
                },
                child: const Text(StringConstants.submit, style: TextStyle(color: AppColor.colorWhite)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
