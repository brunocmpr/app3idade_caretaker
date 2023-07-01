import 'dart:convert';

import 'package:app3idade_caretaker/models/weekly_posology.dart';
import 'package:app3idade_caretaker/util/util.dart';
import 'package:flutter/material.dart';

class WeeklyPosologyDateTime {
  int? id;
  WeeklyPosology? weeklyPosology;
  int dayOfWeek;
  TimeOfDay time;

  WeeklyPosologyDateTime.newDateTime(this.dayOfWeek, this.time, [this.weeklyPosology]);
  WeeklyPosologyDateTime(this.id, this.dayOfWeek, this.time, [this.weeklyPosology]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayOfWeek': weekdayStringFromInteger(dayOfWeek),
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
    };
  }

  static WeeklyPosologyDateTime fromMap(Map<String, dynamic> map) {
    return WeeklyPosologyDateTime(
      map['id'] as int,
      weekdayIntegerFromString(map['dayOfWeek'] as String)!,
      TimeOfDay(
        hour: int.parse(map['time'].split(":")[0]),
        minute: int.parse(map['time'].split(":")[1]),
      ),
    );
  }

  static List<WeeklyPosologyDateTime> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) => WeeklyPosologyDateTime.fromMap(maps[i]));
  }

  static List<WeeklyPosologyDateTime> fromDynamics(List<dynamic> dynamics) {
    return fromMaps(dynamics.cast<Map<String, dynamic>>());
  }

  static WeeklyPosologyDateTime fromJson(String json) => WeeklyPosologyDateTime.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());

  static List<WeeklyPosologyDateTime> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<WeeklyPosologyDateTime>((map) => WeeklyPosologyDateTime.fromMap(map)).toList();
  }
}
