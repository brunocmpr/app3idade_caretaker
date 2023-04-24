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
}

enum PosologyType { uniform, weekly, custom }
