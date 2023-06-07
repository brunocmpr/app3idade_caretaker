import 'dart:io';

import 'package:app3idade_caretaker/models/patient.dart';
import 'package:app3idade_caretaker/repository/patient_repository.dart';

class PatientService {
  PatientRepository patientRepository = PatientRepository();

  Future<Patient> findById(int id) async {
    return patientRepository.findById(id);
  }

  Future<List<Patient>> findAll() {
    return patientRepository.findAll();
  }

  Future<Patient> createPatient(Patient user, List<File>? images) async {
    return patientRepository.create(user, images);
  }

  Future<Patient> updatePatient(Patient user) async {
    return patientRepository.update(user);
  }

  Future<Patient> deletePatientById(int id) async {
    return patientRepository.deleteById(id);
  }
}
