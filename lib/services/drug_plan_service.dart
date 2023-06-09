import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/repository/drug_plan_repository.dart';

class DrugPlanService {
  final drugPlanRepository = DrugPlanRepository();

  Future<DrugPlan> createDrugPlan(DrugPlan drugPlan) {
    return drugPlanRepository.createDrugPLan(drugPlan);
  }

  Future<List<DrugPlan>> findAll() {
    return drugPlanRepository.findAll();
  }

  Future<DrugPlan> deleteById(int id) async {
    return drugPlanRepository.delete(id);
  }

  findById(int drugPlanId) {
    return drugPlanRepository.findById(drugPlanId);
  }
}
