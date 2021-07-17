import 'dart:convert';

import '../models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/duty.dart';
import 'package:http/http.dart' as http;

class MyDuty with ChangeNotifier {
  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  static const colors = <Color>[
    Color(0xFFEF9A9A),
    Colors.blue,
    Colors.green,
    Color(0xFFFDD835),
    Colors.orange,
    Colors.pink,
    Colors.red,
    Colors.brown,
    Colors.purple,
    Colors.black,
  ];

  static List<Duty> _dutyItems = [
    // Duty(
    //   id: '1',
    //   dutyName: 'Morning',
    //   dutyAbbreviation: 'MG',
    //   dutyColor: Colors.lightBlueAccent,
    //   dutyStartTime: TimeOfDay(hour: 6, minute: 00),
    //   dutyEndTime: TimeOfDay(hour: 12, minute: 00),
    // ),
    // Duty(
    //   id: '2',
    //   dutyName: 'Day',
    //   dutyColor: Colors.yellow,
    //   dutyStartTime: TimeOfDay(hour: 10, minute: 00),
    //   dutyEndTime: TimeOfDay(hour: 16, minute: 00),
    // ),
    // Duty(
    //   id: '3',
    //   dutyName: 'Afternoon',
    //   // dutyColor: Colors.orange,
    //   dutyStartTime: TimeOfDay(hour: 12, minute: 00),
    //   dutyEndTime: TimeOfDay(hour: 20, minute: 00),
    // ),
    // Duty(
    //   id: '4',
    //   dutyName: 'Night',
    //   dutyColor: Colors.purple,
    //   dutyStartTime: TimeOfDay(hour: 20, minute: 00),
    //   dutyEndTime: TimeOfDay(hour: 6, minute: 00),
    // ),
    // Duty(
    //   id: '5',
    //   dutyName: 'Night Off',
    //   dutyColor: Colors.pinkAccent,
    //   dutyStartTime: TimeOfDay(hour: 20, minute: 00),
    //   dutyEndTime: TimeOfDay(hour: 06, minute: 00),
    // ),
    // Duty(
    //   id: '6',
    //   dutyName: 'Day Off',
    //   dutyColor: Colors.redAccent,
    //   dutyStartTime: TimeOfDay(hour: 6, minute: 00),
    //   dutyEndTime: TimeOfDay(hour: 20, minute: 00),
    // ),
    // Duty(
    //   id: '7',
    //   dutyName: 'Leave',
    //   dutyColor: Colors.green,
    // ),
  ];

  final url =
      Uri.https('nursing-support-default-rtdb.firebaseio.com', '/duties.json');
  List<Duty> get items {
    return [..._dutyItems];
  }

  Duty findById(String id) {
    return _dutyItems.firstWhere((duty) => duty.id == id);
  }

  Future<void> fetch() async {
    try {
      final response = await http.get(url);
      final decodedJSON = jsonDecode(response.body);

      final extractedData =
          decodedJSON != null ? decodedJSON as Map<String, dynamic> : {};
      final List<Duty> loadedDuties = [];
      extractedData.forEach((dutyId, dutyData) {
        loadedDuties.add(
          Duty(
            id: dutyId,
            dutyName: dutyData['name'],
            dutyAbbreviation: dutyData['abbreviation'],
            dutyColor: Color(int.parse(dutyData['color'])).withOpacity(1),
            dutyStartTime: stringToTimeOfDay(dutyData['startTime']),
            dutyEndTime: stringToTimeOfDay(dutyData['endTime']),
          ),
        );
      });

      _dutyItems = loadedDuties;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addDuty(duty, context) async {
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'name': duty.dutyName,
          'abbreviation': duty.dutyAbbreviation,
          'color': duty.dutyColor.value.toString(),
          'startTime': duty.dutyStartTime.format(context),
          'endTime': duty.dutyEndTime.format(context),
        }),
      );
      final newDuty = Duty(
        dutyName: duty.dutyName,
        dutyAbbreviation: duty.dutyAbbreviation,
        dutyColor: duty.dutyColor,
        dutyStartTime: duty.dutyStartTime,
        dutyEndTime: duty.dutyEndTime,
        id: json.decode(response.body)['name'],
      );

      _dutyItems.add(newDuty);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateDuty(id, Duty duty) async {
    final dutyIndex = _dutyItems.indexWhere((element) => element.id == id);
    if (dutyIndex >= 0) {
      final _url = Uri.https(
          'nursing-support-default-rtdb.firebaseio.com', '/duties/$id.json');
      http.patch(_url,
          body: json.encode({
            'name': duty.dutyName,
            'abbreviation': duty.dutyAbbreviation,
            'color': duty.dutyColor.value.toString(),
            'startTime': duty.dutyStartTime.toString(),
            'endTime': duty.dutyEndTime.toString(),
          }));
      _dutyItems[dutyIndex] = duty;
      _dutyItems[dutyIndex].id = id;

      notifyListeners();
    }
  }

  Future<void> deleteDuty(id) async {
    final _url = Uri.https(
        'nursing-support-default-rtdb.firebaseio.com', '/duties/$id.json');
    final existingDutyIndex =
        _dutyItems.indexWhere((element) => element.id == id);
    var existingDuty = _dutyItems[existingDutyIndex];
    notifyListeners();
    final respose = await http.delete(_url);
    if (respose.statusCode >= 400) {
      _dutyItems.insert(existingDutyIndex, existingDuty);
      notifyListeners();
      throw HttpException("Could not delete");
    }

    existingDuty = Duty(dutyName: '', id: '');
    _dutyItems.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
