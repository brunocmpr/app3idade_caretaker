import 'dart:convert';

import 'package:app3idade_caretaker/models/uniform_posology.dart';

import 'patient.dart';
import 'drug.dart';

class DrugPlan {
  int? id;
  Patient patient;
  Drug drug;
  PosologyType type;
  UniformPosology? uniformPosology;
  // WeeklyPosology? weeklyPosology;
  // List<CustomPosology>? customPosologies;

  DrugPlan.newPlan(this.patient, this.drug, this.type);
  DrugPlan(
    this.id,
    this.patient,
    this.drug,
    this.type, [
    this.uniformPosology,
    /* this. weeklyPosology , this.customPosologies*/
  ]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patient.id,
      'drugId': drug.id,
      'posologyType': type.name.toUpperCase(),
      'uniformPosology': uniformPosology!.toMap(),
      // if(weeklyPosology!= null)'weeklyPosology': weeklyPosology!.toMap(),
      // if(customPosologies!= null)'customPosologies': customPosologies,
    };
  }

  static DrugPlan fromMap(Map<String, dynamic> map) {
    UniformPosology? uniformPosology;
    // WeeklyPosology? weeklyPosology;
    // List<CustomPosology>? customPosologies;
    if (map['uniformPosology'] != null) {
      uniformPosology = UniformPosology.fromMap(map['uniformPosology']);
    }
    return DrugPlan(
      map['id'],
      Patient.fromMap(map['patient']),
      Drug.fromMap(map['drug']),
      PosologyType.values.byName((map['posologyType'] as String).toLowerCase()),
      uniformPosology,
      // weeklyPosology,
      // customPosologies,
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
