import 'dart:io';

import 'package:app3idade_caretaker/models/drug.dart';
import 'package:app3idade_caretaker/repository/drug_repository.dart';

class DrugService {
  DrugRepository drugRepository = DrugRepository();

  Future<Drug> createDrug(Drug drug, List<File>? images) {
    return drugRepository.create(drug, images);
  }

  Future<List<Drug>> findAll() {
    //TODO IMPLEMENT
    return Future.value([
      Drug(1, 'Paracetamol', '500mg', []),
      Drug(2, 'Citalopram', '10 mg', []),
    ]);
  }
}
