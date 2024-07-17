import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:employee_insight/data/model/leave_model.dart';

class LeaveDetailsScreen extends StatefulWidget {
  @override
  LeaveDetailsScreenState createState() => LeaveDetailsScreenState();
}

class LeaveDetailsScreenState extends State<LeaveDetailsScreen> {
  late LeaveModel leaveModel;
  late Box<LeaveModel> leaveBox;
  String? userId;

  @override
  void initState() {
    super.initState();
    _initializeLeaveData();
  }

  Future<void> _initializeLeaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('loggedInUserEmail');

    leaveBox = await Hive.openBox<LeaveModel>('leave');

    leaveModel = leaveBox.values.firstWhere(
      (leave) => leave.userId == userId,
      orElse: () =>
          LeaveModel(userId: userId!, plLeaves: 10, slLeaves: 8, clLeaves: 12),
    );

    if (leaveModel.key == null) {
      leaveBox.add(leaveModel);
    }

    setState(() {});
  }

  Future<void> applyLeave(String leaveType) async {
    if (leaveModel.leaveReason.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringConstants.leaveAppliedError)),
      );
      return;
    }

    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked == null) return;

    int days = picked.duration.inDays + 1;

    if ((leaveType == StringConstants.pl && leaveModel.plLeaves < days) ||
        (leaveType == StringConstants.sl && leaveModel.slLeaves < days) ||
        (leaveType == StringConstants.cl && leaveModel.clLeaves < days)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${StringConstants.noLeaveBalance} $days ${StringConstants.days}')),
      );
      return;
    }

    String? reason = await _showReasonDialog();
    if (reason == null || reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringConstants.enterReason)),
      );
      return;
    }

    setState(() {
      if (leaveType == StringConstants.pl && leaveModel.plLeaves >= days) {
        leaveModel.plLeaves -= days;
      }
      if (leaveType == StringConstants.sl && leaveModel.slLeaves >= days) {
        leaveModel.slLeaves -= days;
      }
      if (leaveType == StringConstants.cl && leaveModel.clLeaves >= days) {
        leaveModel.clLeaves -= days;
      }

      leaveModel.leaveReason = reason;
      leaveModel.leaveType = leaveType;
      leaveModel.leavesApplied = days;
      leaveModel.save();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(StringConstants.leaveApplied)),
    );
  }

  Future<void> cancelLeave() async {
    setState(() {
      if (leaveModel.leaveType == StringConstants.pl) {
        leaveModel.plLeaves += leaveModel.leavesApplied;
      }
      if (leaveModel.leaveType == StringConstants.sl) {
        leaveModel.slLeaves += leaveModel.leavesApplied;
      }
      if (leaveModel.leaveType == StringConstants.cl) {
        leaveModel.clLeaves += leaveModel.leavesApplied;
      }

      leaveModel.leaveReason = '';
      leaveModel.leaveType = '';
      leaveModel.leavesApplied = 0;
      leaveModel.save();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(StringConstants.leaveCancel)),
    );
  }

  Future<String?> _showReasonDialog() async {
    final TextEditingController reasonController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringConstants.reason),
          content: TextField(
            controller: reasonController,
            decoration: InputDecoration(
              labelText: StringConstants.reasonText,
              errorText: reasonController.text.isEmpty
                  ? StringConstants.reasonRequired
                  : null,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (reasonController.text.isEmpty) {
                  setState(() {});
                } else {
                  Navigator.pop(context, reasonController.text);
                }
              },
              child: const Text(StringConstants.submit),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .headlineMedium
        ?.copyWith(color: AppColor.colorWhite);

    if (userId == null) {
      return const AppScaffold(
        titleText: StringConstants.leaveDetails,
        scaffoldBody: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    bool isLeaveApplied = leaveModel.leaveReason.isNotEmpty;

    return AppScaffold(
      titleText: StringConstants.leaveDetails,
      scaffoldBody: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${StringConstants.plLeave}: ${leaveModel.plLeaves}'),
            Text('${StringConstants.slLeave}: ${leaveModel.slLeaves}'),
            Text('${StringConstants.clLeave}: ${leaveModel.clLeaves}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => applyLeave(StringConstants.pl),
              child: Text(
                StringConstants.applyPl,
                style: buttonTextStyle,
              ),
            ),
            ElevatedButton(
              onPressed: () => applyLeave(StringConstants.sl),
              child: Text(
                StringConstants.applySl,
                style: buttonTextStyle,
              ),
            ),
            ElevatedButton(
              onPressed: () => applyLeave(StringConstants.cl),
              child: Text(
                StringConstants.applyCl,
                style: buttonTextStyle,
              ),
            ),
            if (isLeaveApplied)
              ElevatedButton(
                onPressed: cancelLeave,
                child: Text(
                  StringConstants.cancelLeave,
                  style: buttonTextStyle,
                ),
              ),
            SizedBox(height: 20),
            if (leaveModel.leaveReason.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${StringConstants.leaveType}: ${leaveModel.leaveType}'),
                  Text(
                      '${StringConstants.numberOfLeaves}: ${leaveModel.leavesApplied}'),
                  Text(
                      '${StringConstants.reasonText}: ${leaveModel.leaveReason}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
