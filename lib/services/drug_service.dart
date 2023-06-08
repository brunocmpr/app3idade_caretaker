import 'dart:io';

import 'package:app3idade_caretaker/models/drug.dart';
import 'package:app3idade_caretaker/repository/drug_repository.dart';

class DrugService {
  DrugRepository drugRepository = DrugRepository();

  Future<Drug> createDrug(Drug drug, List<File>? images) {
    return drugRepository.create(drug, images);
  }

  Future<List<Drug>> findAll() {
    return drugRepository.findAll();
  }

  Future<Drug> deleteDrugById(int id) async {
    return drugRepository.deleteById(id);
  }

  Future<Drug> findById(int id) async {
    return drugRepository.findById(id);
  }

  Future<Drug> update(Drug drug, List<File>? images) {
    return drugRepository.update(drug, images);
  }
}
