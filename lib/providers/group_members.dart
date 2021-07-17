import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/member.dart';

class Members with ChangeNotifier {
  static List<Member> _members = [];

  List<Member> get items {
    return [..._members];
  }

  Future<void> fetch() async {
    try {
      final url = Uri.https(
          'nursing-support-default-rtdb.firebaseio.com', '/members.json');
      final response = await http.get(url);
      final decodedJSON = jsonDecode(response.body);

      final extractedData =
          decodedJSON != null ? decodedJSON as Map<String, dynamic> : {};
      final List<Member> loadedMembers = [];
      extractedData.forEach((memberId, memberData) {
        loadedMembers.add(Member(
          id: memberId,
          name: memberData['name'],
          seniorityLevel: memberData['seniorityLevel'],
          groupId: memberData['groupId'],
        ));
      });

      _members = loadedMembers;

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addMember(member) async {
    try {
      final url = Uri.https(
          'nursing-support-default-rtdb.firebaseio.com', '/members.json');
      final response = await http.post(
        url,
        body: json.encode({
          'name': member.name,
          'seniorityLevel': member.seniorityLevel,
        }),
      );
      final newMember = Member(
        name: member.name,
        seniorityLevel: member.seniorityLevel,
        groupId: member.groupId,
        id: json.decode(response.body)['name'],
      );
      _members.add(newMember);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeMember(memberId) async {
    final memberIndex = _members.indexWhere((member) => member.id == memberId);
    if (memberIndex >= 0) {
      final _url = Uri.https('nursing-support-default-rtdb.firebaseio.com',
          '/members/$memberId.json');
      http.patch(_url,
          body: json.encode({
            'groupId': null,
          }));
      _members[memberIndex].groupId = null;

      notifyListeners();
    }
  }

  Future<void> assignGroup(String groupId, String memberId) async {
    final memberIndex = _members.indexWhere((member) => member.id == memberId);
    if (memberIndex >= 0) {
      final _url = Uri.https('nursing-support-default-rtdb.firebaseio.com',
          '/members/$memberId.json');
      http.patch(_url,
          body: json.encode({
            'groupId': groupId,
          }));
      _members[memberIndex].groupId = groupId;

      notifyListeners();
    }
  }
}
