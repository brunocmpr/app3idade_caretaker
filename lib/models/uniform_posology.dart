import 'dart:convert';

import 'package:app3idade_caretaker/models/drug_plan.dart';

class UniformPosology {
  int? id;
  late DrugPlan? drugPlan;
  DateTime startDateTime;
  DateTime? endDateTime;
  int timeLength;
  TimeUnit timeUnit;
  UniformPosology.newPosology(this.startDateTime, this.timeLength, this.timeUnit, [this.endDateTime, this.drugPlan]);
  UniformPosology(this.id, this.startDateTime, this.timeLength, this.timeUnit, [this.endDateTime, this.drugPlan]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDateTime': startDateTime.toIso8601String(),
      if (endDateTime != null) 'endDateTime': endDateTime!.toIso8601String(),
      'timeLength': timeLength,
      'timeUnit': timeUnit.name.toUpperCase()
    };
  }

  static UniformPosology fromMap(Map<String, dynamic> map) {
    DateTime? endDateTime;
    if (map['endDateTime'] != null) {
      endDateTime = DateTime.parse(map['endDateTime']);
    }
    return UniformPosology(
      map['id'] as int,
      DateTime.parse(map['startDateTime']),
      map['timeLength'] as int,
      TimeUnit.values.byName((map['timeUnit']).toLowerCase()),
      endDateTime,
    );
  }

  static List<UniformPosology> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) => UniformPosology.fromMap(maps[i]));
  }

  static UniformPosology fromJson(String json) => UniformPosology.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());

  static List<UniformPosology> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<UniformPosology>((map) => UniformPosology.fromMap(map)).toList();
  }
}

enum TimeUnit { minute, hour, day, week }

extension TimeUnitPtBr on TimeUnit {
  static Map<TimeUnit, String> map = {
    TimeUnit.minute: 'minutos',
    TimeUnit.hour: 'horas',
    TimeUnit.day: 'dias',
    TimeUnit.week: 'semanas',
  };
  String namePtBr() {
    return map[this] ?? toString();
  }

  TimeUnit? fromNamePtBr(String translation) {
    return map.entries.firstWhere((element) => element.value == translation).key;
  }
}
