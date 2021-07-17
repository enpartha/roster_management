import 'package:flutter/foundation.dart';

class Group with ChangeNotifier {
  String groupName;
  String? hospitalName;
  String? departmentName;
  String? id;
  int memberCount;
  List<dynamic> memberList;
  String? adminId;
  // List<Member> groupMembers;

  Group({
    this.groupName = '',
    this.hospitalName = '',
    this.departmentName = '',
    this.id,
    this.memberCount = 0,
    this.memberList = const [],
    this.adminId,

// this.groupMembers,
  });
}
