import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/views/drug_register_page.dart';
import 'package:app3idade_caretaker/views/home_page.dart';
import 'package:app3idade_caretaker/views/login_page.dart';
import 'package:app3idade_caretaker/views/patient_register_page.dart';
import 'package:app3idade_caretaker/views/uniform_posology_register_page.dart';
import 'package:app3idade_caretaker/views/user_register_page.dart';
import 'package:app3idade_caretaker/views/drug_plan_register_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const login = '/';
  static const homePage = '/homepage';
  static const createUser = '/create_user';
  static const createPatient = '/create_patient';
  static const createDrug = '/create_drug';
  static const createBaseDrugPlan = '/create_base_posology';
  static const createUniformPosology = '/create_custom_posology';

  static Map<String, Widget Function(BuildContext)> get routes => {
        login: (context) => const LoginPage(),
        homePage: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as String;
          return HomePage(token: arguments);
        },
        createUser: (context) => const UserRegisterPage(),
        createPatient: (context) => const PatientRegisterPage(),
        createDrug: (context) => const DrugRegisterPage(),
        createBaseDrugPlan: (context) => const DrugPlanPage(),
        createUniformPosology: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as DrugPlan;
          // return UniformPosologyRegisterPage(drugPlan: arguments);
          return UniformPosologyRegisterPage(drugPlan: arguments);
        },
      };
}
