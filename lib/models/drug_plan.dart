import 'dart:convert';

import 'package:app3idade_caretaker/models/custom_posology.dart';
import 'package:app3idade_caretaker/models/uniform_posology.dart';
import 'package:app3idade_caretaker/models/weekly_posology.dart';

import 'patient.dart';
import 'drug.dart';

class DrugPlan {
  int? id;
  Patient patient;
  Drug drug;
  PosologyType type;
  UniformPosology? uniformPosology;
  List<CustomPosology>? customPosologies;
  WeeklyPosology? weeklyPosology;

  DrugPlan.newPlan(this.patient, this.drug, this.type);
  DrugPlan(this.id, this.patient, this.drug, this.type,
      [this.uniformPosology, this.customPosologies, this.weeklyPosology]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patient.id,
      'drugId': drug.id,
      'posologyType': type.name.toUpperCase(),
      if (uniformPosology != null) 'uniformPosology': uniformPosology!.toMap(),
      if (customPosologies != null) 'customPosologies': customPosologies!.map((posology) => posology.toMap()).toList(),
      if (weeklyPosology != null) 'weeklyPosology': weeklyPosology!.toMap(),
    };
  }

  static DrugPlan fromMap(Map<String, dynamic> map) {
    UniformPosology? uniformPosology;
    List<CustomPosology>? customPosologies;
    WeeklyPosology? weeklyPosology;
    if (map['uniformPosology'] != null) {
      uniformPosology = UniformPosology.fromMap(map['uniformPosology']);
    }
    if (map['customPosology'] != null) {
      customPosologies = CustomPosology.fromDynamics(map['customPosology'] as List<dynamic>);
    }
    if (map['weeklyPosology'] != null) {
      weeklyPosology = WeeklyPosology.fromMap(map['weeklyPosology']);
    }
    return DrugPlan(
      map['id'],
      Patient.fromMap(map['patient']),
      Drug.fromMap(map['drug']),
      PosologyType.values.byName((map['posologyType'] as String).toLowerCase()),
      uniformPosology,
      customPosologies,
      weeklyPosology,
    );
  }

  String toJson() => jsonEncode(toMap());

  static DrugPlan fromJson(String json) => DrugPlan.fromMap(jsonDecode(json));

  static List<DrugPlan> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<DrugPlan>((map) => DrugPlan.fromMap(map)).toList();
  }
}

enum PosologyType { uniform, weekly, custom }
