import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/repository/drug_plan_repository.dart';

class DrugPlanService {
  final drugPlanRepository = DrugPlanRepository();

  Future<DrugPlan> createDrugPlan(DrugPlan drugPlan) {
    return drugPlanRepository.createDrugPLan(drugPlan);
  }
}
