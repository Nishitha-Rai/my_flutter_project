import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/data/model/user_model.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:employee_insight/presentation/widgets/app_button.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:employee_insight/data/model/leave_model.dart';

class LeaveDetailsScreen extends StatefulWidget {
  const LeaveDetailsScreen({super.key});

  @override
  LeaveDetailsScreenState createState() => LeaveDetailsScreenState();
}

class LeaveDetailsScreenState extends State<LeaveDetailsScreen> {
  late LeaveModel leaveModel;
  late Box<LeaveModel> leaveBox;
  String? userId;
  String? selectedLeaveType;
  bool _isApplyingLeave = false;

  @override
  void initState() {
    super.initState();
    _initializeLeaveData();
  }

  // Initialize leave data for the logged-in user from Hive and Shared Preferences.
  Future<void> _initializeLeaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('loggedInUserEmail');

    // Open Hive box for leave details and fetch user's leave data
    leaveBox = await Hive.openBox<LeaveModel>('leave');

    leaveModel = leaveBox.values.firstWhere(
      (leave) => leave.userId == userId,
      orElse: () =>
          LeaveModel(userId: userId!, plLeaves: 10, slLeaves: 8, clLeaves: 12),
    );

    // Add default leave data if user's data is not found in Hive
    if (leaveModel.key == null) {
      leaveBox.add(leaveModel);
    }

    setState(() {}); // Update UI after data initialization
  }

  void _startApplyingLeave() {
    setState(() {
      _isApplyingLeave = true;
    });
  }

  Future<void> applyLeave() async {
    if (leaveModel.leaveReason.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringConstants.leaveAppliedError)),
      );
      return;
    }

    if (selectedLeaveType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringConstants.selectLeaveType)),
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

    if ((selectedLeaveType == StringConstants.pl &&
            leaveModel.plLeaves < days) ||
        (selectedLeaveType == StringConstants.sl &&
            leaveModel.slLeaves < days) ||
        (selectedLeaveType == StringConstants.cl &&
            leaveModel.clLeaves < days)) {
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
      if (selectedLeaveType == StringConstants.pl &&
          leaveModel.plLeaves >= days) {
        leaveModel.plLeaves -= days;
      }
      if (selectedLeaveType == StringConstants.sl &&
          leaveModel.slLeaves >= days) {
        leaveModel.slLeaves -= days;
      }
      if (selectedLeaveType == StringConstants.cl &&
          leaveModel.clLeaves >= days) {
        leaveModel.clLeaves -= days;
      }

      leaveModel.leaveReason = reason;
      leaveModel.leaveType = selectedLeaveType!;
      leaveModel.leavesApplied = days;
      leaveModel.save();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(StringConstants.leaveApplied)),
    );

    setState(() {
      _isApplyingLeave = false;
    });
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

      selectedLeaveType = null;
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
    if (userId == null) {
      return const AppScaffold(
        showBackArrow: true,
        titleText: StringConstants.leaveDetails,
        scaffoldBody: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    bool isLeaveApplied = leaveModel.leaveReason.isNotEmpty;

    return AppScaffold(
      showBackArrow: true,
      titleText: StringConstants.leaveDetails,
      scaffoldBody: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildEmployeeInfoCard(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLeaveCard(StringConstants.plLeave, leaveModel.plLeaves),
                  _buildLeaveCard(StringConstants.slLeave, leaveModel.slLeaves),
                  _buildLeaveCard(StringConstants.clLeave, leaveModel.clLeaves),
                ],
              ),
              const SizedBox(height: 20),
              if (!isLeaveApplied)
                Column(
                  children: [
                    if (!_isApplyingLeave)
                      Center(
                        child: AppButton(
                          onPressed: _startApplyingLeave,
                          text: StringConstants.applyForLeave,
                        ),
                      ),
                    if (_isApplyingLeave)
                      Column(
                        children: [
                          DropdownButton<String>(
                            dropdownColor: AppColor.colorWhite,
                            hint: Text(StringConstants.selectLeaveType,
                                style: Theme.of(context).textTheme.headlineSmall),
                            value: selectedLeaveType,
                            items: <String>[
                              StringConstants.pl,
                              StringConstants.sl,
                              StringConstants.cl
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedLeaveType = newValue;
                              });
                            },
                          ),
                          Center(
                            child: AppButton(
                              onPressed: applyLeave,
                              text: StringConstants.applyForLeave,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              if (leaveModel.leaveReason.isNotEmpty) _buildLeaveDetailsCard(),
              const SizedBox(height: 20),
              if (isLeaveApplied)
                Center(
                  child: AppButton(
                    onPressed: cancelLeave,
                    text: StringConstants.cancelLeave,
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveCard(String leaveType, int leaveCount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.4, 1.0],
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.75),
            Theme.of(context).colorScheme.secondary.withOpacity(0.9),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              leaveType,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColor.colorWhite,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              leaveCount.toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColor.colorWhite,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoCard() {
    var userBox = Hive.box<User>('users');

    final cardTextStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w500,
        );

    return Container(
      width: double.infinity,
      height: 130.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.2, 0.9],
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.75),
            Theme.of(context).colorScheme.secondary.withOpacity(0.7),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              '${StringConstants.name} ${userBox.values.first.firstName} ${userBox.values.first.lastName}',
              style: cardTextStyle,
            ),
            const SizedBox(height: 6),
            Text('${StringConstants.empId} ${userBox.values.first.employeeId}',
                style: cardTextStyle),
            const SizedBox(height: 6),
            Text(
              '${StringConstants.emailTexts} ${userBox.values.first.email}',
              style: cardTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveDetailsCard() {
    final leaveTextStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w500,
        );

    return Container(
      width: double.infinity,
      height: 130.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.4, 1.0],
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.75),
            Theme.of(context).colorScheme.secondary.withOpacity(0.9),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${StringConstants.leaveType}: ${leaveModel.leaveType}',
              style: leaveTextStyle,
            ),
            const SizedBox(height: 8),
            Text(
              '${StringConstants.numberOfLeaves}: ${leaveModel.leavesApplied}',
              style: leaveTextStyle,
            ),
            const SizedBox(height: 8),
            Text(
              '${StringConstants.reasonText}: ${leaveModel.leaveReason}',
              style: leaveTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
