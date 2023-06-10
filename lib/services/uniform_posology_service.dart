import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/repository/uniform_posology_repository.dart';

class UniformPosologyService {
  final repository = UniformPosologyRepository();

  Future<DrugPlan> update(DrugPlan drugPlan) {
    return repository.update(drugPlan.id!, drugPlan.uniformPosology!);
  }
}
