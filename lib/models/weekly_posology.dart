import 'dart:convert';

import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/models/weekly_posology_date_time.dart';
import 'package:app3idade_caretaker/util/util.dart';

class WeeklyPosology {
  int? id;
  DrugPlan? drugPlan;
  DateTime startDateTime;
  DateTime? endDateTime;

  List<WeeklyPosologyDateTime> weeklyPosologyDateTimes;
  WeeklyPosology.newPosology(this.startDateTime, this.endDateTime, this.weeklyPosologyDateTimes, [this.drugPlan]);
  WeeklyPosology(this.id, this.startDateTime, this.endDateTime, this.weeklyPosologyDateTimes, [this.drugPlan]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDateTime': formatDateTime(startDateTime),
      'endDateTime': formatDateTime(endDateTime!),
      'weeklyPosologyDateTimes': weeklyPosologyDateTimes.map((posology) => posology.toMap()).toList(),
    };
  }

  static WeeklyPosology fromMap(Map<String, dynamic> map) {
    DateTime? endDateTime;
    if (map['endDateTime'] != null) {
      endDateTime = DateTime.parse(map['endDateTime']);
    }
    return WeeklyPosology(
      map['id'] as int,
      DateTime.parse(map['startDateTime']),
      endDateTime,
      WeeklyPosologyDateTime.fromJsonList(map['weeklyPosologyDateTimes']),
    );
  }

  static List<WeeklyPosology> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) => WeeklyPosology.fromMap(maps[i]));
  }

  static WeeklyPosology fromJson(String json) => WeeklyPosology.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());

  static List<WeeklyPosology> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<WeeklyPosology>((map) => WeeklyPosology.fromMap(map)).toList();
  }
}
