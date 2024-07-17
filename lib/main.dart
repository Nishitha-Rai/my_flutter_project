import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';


import 'core/config/init.dart';
import 'data/model/leave_model.dart';
import 'data/model/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(LeaveModelAdapter());
  await Hive.openBox<User>('users');
  runApp(EmployeeInsightApp());
}

class EmployeeInsightApp extends StatelessWidget {
  const EmployeeInsightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return const InitRoot();
      },
    );
  }
}

