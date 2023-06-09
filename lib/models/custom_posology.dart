import 'dart:convert';

import 'package:app3idade_caretaker/models/drug_plan.dart';

class CustomPosology {
  int? id;
  late DrugPlan? drugPlan;
  DateTime dateTime;
  CustomPosology.newPosology(this.dateTime, [this.drugPlan]);
  CustomPosology(this.id, this.dateTime, [this.drugPlan]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static CustomPosology fromMap(Map<String, dynamic> map) {
    return CustomPosology(
      map['id'] as int,
      DateTime.parse(map['dateTime']),
    );
  }

  static List<CustomPosology> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) => CustomPosology.fromMap(maps[i]));
  }

  static List<CustomPosology> fromDynamics(List<dynamic> dynamics) {
    return fromMaps(dynamics.cast<Map<String, dynamic>>());
  }

  static toJsonList(List<CustomPosology> customPosologies) =>
      jsonEncode(customPosologies.map((e) => e.toMap()).toList());

  static CustomPosology fromJson(String json) => CustomPosology.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());

  static List<CustomPosology> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<CustomPosology>((map) => CustomPosology.fromMap(map)).toList();
  }
}
