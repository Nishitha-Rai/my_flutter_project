import 'package:hive/hive.dart';

part 'leave_model.g.dart';

@HiveType(typeId: 1)
class LeaveModel extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  int plLeaves;

  @HiveField(2)
  int slLeaves;

  @HiveField(3)
  int clLeaves;

  @HiveField(4)
  String leaveReason;

  @HiveField(5)
  String leaveType;

  @HiveField(6)
  int leavesApplied;

  LeaveModel({
    required this.userId,
    required this.plLeaves,
    required this.slLeaves,
    required this.clLeaves,
    this.leaveReason = '',
    this.leaveType = '',
    this.leavesApplied = 0,
  });
}
