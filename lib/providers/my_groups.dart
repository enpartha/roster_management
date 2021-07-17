import 'dart:convert';

import '../models/http_exception.dart';

import '../providers/group_members.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/group.dart';

class Groups with ChangeNotifier {
  static List<Group> _groupItems = [];

  final url =
      Uri.https('nursing-support-default-rtdb.firebaseio.com', '/groups.json');
  List<Group> get items {
    return [..._groupItems];
  }

  Group findById(String id) {
    return _groupItems.firstWhere((group) => group.id == id);
  }

  Future<void> fetch() async {
    try {
      final response = await http.get(url);
      final decodedJSON = jsonDecode(response.body);

      final extractedData =
          decodedJSON != null ? decodedJSON as Map<String, dynamic> : {};
      final List<Group> loadedGroups = [];
      extractedData.forEach((groupId, groupData) {
        loadedGroups.add(Group(
          id: groupId,
          groupName: groupData['name'],
          hospitalName: groupData['hospital'],
          departmentName: groupData['department'],
          adminId: groupData['adminId'],
          memberList:
              groupData['memberList'] != null ? groupData['memberList'] : [],
          memberCount: groupData['memberList'] == null
              ? 0
              : groupData['memberList'].length,
        ));
      });

      _groupItems = loadedGroups;

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addGroup(group) async {
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'name': group.groupName,
          'hospital': group.hospitalName,
          'department': group.departmentName,
        }),
      );
      final newGroup = Group(
        groupName: group.groupName,
        hospitalName: group.hospitalName,
        departmentName: group.departmentName,
        id: json.decode(response.body)['name'],
      );
      _groupItems.add(newGroup);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateGroup(id, Group group) async {
    final groupIndex = _groupItems.indexWhere((element) => element.id == id);
    if (groupIndex >= 0) {
      final _url = Uri.https(
          'nursing-support-default-rtdb.firebaseio.com', '/groups/$id.json');
      http.patch(_url,
          body: json.encode({
            'name': group.groupName,
            'hospital': group.hospitalName,
            'department': group.departmentName,
          }));
      _groupItems[groupIndex] = group;
      _groupItems[groupIndex].id = id;
      notifyListeners();
    }
  }

  Future<void> updateAdmin(id, String adminId) async {
    final groupIndex = _groupItems.indexWhere((element) => element.id == id);
    if (groupIndex >= 0) {
      final _url = Uri.https(
          'nursing-support-default-rtdb.firebaseio.com', '/groups/$id.json');
      http.patch(_url,
          body: json.encode({
            'adminId': adminId,
          }));
      _groupItems[groupIndex].adminId = adminId;

      notifyListeners();
    }
  }

  Future<void> removeGroupMember(groupId, String memberId) async {
    final groupIndex =
        _groupItems.indexWhere((element) => element.id == groupId);
    if (groupIndex >= 0) {
      print(_groupItems[groupIndex].memberList);
      final members =
          Members().items.where((member) => member.groupId == groupId).toList();
      // final memberIndex =
      //     members.indexWhere((element) => element.id == memberId);

      members.removeWhere((member) => member.id == memberId);
      var memberList =
          List<String>.generate(members.length, (i) => members[i].id);
      final _url = Uri.https('nursing-support-default-rtdb.firebaseio.com',
          '/groups/$groupId.json');
      http.patch(_url,
          body: json.encode({
            'memberList': memberList,
          }));

      _groupItems[groupIndex].memberList = memberList;

      notifyListeners();
    }
  }

  Future<void> addGroupMember(groupId, String memberId) async {
    final groupIndex =
        _groupItems.indexWhere((element) => element.id == groupId);
    if (groupIndex >= 0) {
      _groupItems[groupIndex].memberList.add(memberId);

      final _url = Uri.https('nursing-support-default-rtdb.firebaseio.com',
          '/groups/$groupId.json');
      http.patch(_url,
          body: json.encode({
            'memberList': _groupItems[groupIndex].memberList,
          }));
      print('group updated: ' + _groupItems[groupIndex].memberList.toString());

      notifyListeners();
    }
  }

  Future<void> deleteGroup(id) async {
    final _url = Uri.https(
        'nursing-support-default-rtdb.firebaseio.com', '/groups/$id.json');
    final existingGroupIndex =
        _groupItems.indexWhere((element) => element.id == id);
    var existingGroup = _groupItems[existingGroupIndex];
    _groupItems.removeAt(existingGroupIndex);
    // print('deleted');
    notifyListeners();
    final response = await http.delete(_url);
    if (response.statusCode >= 400) {
      _groupItems.insert(existingGroupIndex, existingGroup);
      notifyListeners();
      throw HttpException('Could not delete.');
    }
    existingGroup = Group();
  }
}
