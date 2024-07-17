import 'package:employee_insight/constants/route_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/data/model/user_model.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:employee_insight/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants.registration),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CustomTextField(
                controller: _firstNameController,
                labelText: StringConstants.firstName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterFirstName;
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _lastNameController,
                labelText: StringConstants.lastName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterLastName;
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _phoneController,
                labelText: StringConstants.mobileNumber,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterMobileNumber;
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _emailController,
                labelText: StringConstants.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterEmail;
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: _employeeIdController,
                labelText: StringConstants.employeeId,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringConstants.enterEmployeeId;
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
              CustomTextField(
                labelText: StringConstants.confirmPassword,
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return StringConstants.passwordError;
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(StringConstants.haveAccount),
                  SizedBox(width: 5),
                  GestureDetector(
                    child: Text(
                      StringConstants.login,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColor.blueColor),
                    ),
                    onTap: () => Navigator.of(context)
                        .pushNamed(RouteConstants.loginPath),
                  )
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var box = Hive.box<User>('users');
                    print("the box is..${box.values}");
                    var existingUser = box.values.firstWhere(
                      (user) => user.email == _emailController.text,
                      orElse: () => User(
                        firstName: '',
                        lastName: '',
                        phone: '',
                        email: '',
                        employeeId: '',
                        password: '',
                      ),
                    );
                    if (existingUser.email.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(StringConstants.emailExist)),
                      );
                    } else {
                      var newUser = User(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phone: _phoneController.text,
                        email: _emailController.text,
                        employeeId: _employeeIdController.text,
                        password: _passwordController.text,
                      );
                      await box.add(newUser);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(StringConstants.signUpSuccess)),
                      );

                      Navigator.of(context).pushNamed(RouteConstants.loginPath);
                    }
                  }
                },
                child: const Text(StringConstants.submit,
                    style: TextStyle(color: AppColor.colorWhite)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
