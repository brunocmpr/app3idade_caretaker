import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/repository/weekly_posology_repository.dart';

class WeeklyPosologyService {
  final weeklyPosologyRepository = WeeklyPosologyRepository();

  Future<DrugPlan> update(DrugPlan drugPlan) {
    return weeklyPosologyRepository.update(drugPlan.id!, drugPlan.weeklyPosology!);
  }
}
