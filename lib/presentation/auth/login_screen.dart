import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/data/model/user_model.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:employee_insight/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CustomTextField(
                controller: _emailController,
                labelText: StringConstants.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterEmailId;
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: StringConstants.password,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterPassword;
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text(StringConstants.createAccount),
                  SizedBox(width: 5),
                  GestureDetector(
                    child: Text(
                      StringConstants.registration,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColor.blueColor),
                    ),
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteConstants.signUpPath),
                  )
                ],
              ),
              SizedBox(height: 10,),
              GestureDetector(
                child: Text(
                  StringConstants.changePassword,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColor.blueColor),
                ),
                onTap: () => Navigator.of(context)
                    .pushNamed(RouteConstants.changePasswordPath),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
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
                          SnackBar(content: Text(StringConstants.loginSuccess)),
                        );

                        Navigator.of(context).pushNamed(RouteConstants.homePath);

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(StringConstants.loginError)),
                        );
                      }
                    }
                  },
                  child: Text(StringConstants.submit,
                    style: TextStyle(color: AppColor.colorWhite),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
