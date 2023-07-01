import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/repository/custom_posology_repository.dart';

class CustomPosologyService {
  final customPosologyRepository = CustomPosologyRepository();

  Future<DrugPlan> replaceAll(DrugPlan drugPlan) {
    return customPosologyRepository.replaceAll(drugPlan.id!, drugPlan.customPosologies!);
  }
}
