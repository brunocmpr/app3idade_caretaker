import 'package:app3idade_caretaker/models/patient.dart';
import 'package:app3idade_caretaker/repository/patient_repository.dart';

class PatientService {
  PatientRepository patientRepository = PatientRepository();

  Future<Patient> findById(int id) async {
    return patientRepository.deleteById(id);
  }

  Future<Patient> createPatient(Patient user) async {
    return patientRepository.create(user);
  }

  Future<Patient> createUpdateUser(Patient user) async {
    return patientRepository.update(user);
  }

  Future<Patient> deleteUserById(int id) async {
    return patientRepository.deleteById(id);
  }

  Future<List<Patient>> findAll() {
    //TODO IMPLEMENT
    // return Future.value(List<Patient>.empty());
    return Future.value([
      Patient(1, 'Sônia', 'Campera', 'Dona Sônia'),
      Patient(2, 'Geraldo', 'Campera', 'Seu Geraldo'),
    ]);
  }
}
