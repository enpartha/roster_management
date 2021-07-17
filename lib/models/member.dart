import 'package:flutter/foundation.dart';

class Member with ChangeNotifier {
  String name;
  String id;
  String? groupId;
  String? profilePhoto;
  String seniorityLevel;

  Member({
    this.name = 'My Member',
    this.id = '',
    this.groupId,
    this.seniorityLevel = '',
  });
}
