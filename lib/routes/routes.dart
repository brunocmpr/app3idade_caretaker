import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/views/custom_posology_register_page.dart';
import 'package:app3idade_caretaker/views/custom_posology_update_page.dart';
import 'package:app3idade_caretaker/views/drug_register_page.dart';
import 'package:app3idade_caretaker/views/drug_update_page.dart';
import 'package:app3idade_caretaker/views/home_page.dart';
import 'package:app3idade_caretaker/views/login_page.dart';
import 'package:app3idade_caretaker/views/patient_register_page.dart';
import 'package:app3idade_caretaker/views/patient_update_page.dart';
import 'package:app3idade_caretaker/views/rich_text_editor.dart';
import 'package:app3idade_caretaker/views/uniform_posology_register_page.dart';
import 'package:app3idade_caretaker/views/uniform_posology_update.page.dart';
import 'package:app3idade_caretaker/views/user_register_page.dart';
import 'package:app3idade_caretaker/views/drug_plan_register_page.dart';
import 'package:app3idade_caretaker/views/weekly_posology_register_page.dart';
import 'package:app3idade_caretaker/views/weekly_posology_update_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const login = '/';
  static const homePage = '/homepage';
  static const createUser = '/create_user';
  static const createPatient = '/create_patient';
  static const updatePatient = '/update_patient';
  static const createDrug = '/create_drug';
  static const updateDrug = '/update_drug';
  static const createBaseDrugPlan = '/create_base_posology';
  static const createUniformPosology = '/create_uniform_posology';
  static const updateUniformPosology = '/update_uniform_posology';
  static const createCustomPosology = '/create_custom_posology';
  static const updateCustomPosology = '/update_custom_posology';
  static const createWeeklyPosology = '/create_weekly_posology';
  static const updateWeeklyPosology = '/update_weekly_posology';
  static const richTextEditor = '/rich_text_editor';

  static Map<String, Widget Function(BuildContext)> get routes => {
        login: (context) => const LoginPage(),
        homePage: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as String;
          return HomePage(token: arguments);
        },
        createUser: (context) => const UserRegisterPage(),
        createPatient: (context) => const PatientRegisterPage(),
        updatePatient: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as int;
          return PatientUpdatePage(patientId: arguments);
        },
        createDrug: (context) => const DrugRegisterPage(),
        updateDrug: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as int;
          return DrugUpdatePage(drugId: arguments);
        },
        updateCustomPosology: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as int;
          return CustomPosologyUpdatePage(drugPlanId: arguments);
        },
        createBaseDrugPlan: (context) => const DrugPlanPage(),
        createUniformPosology: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as DrugPlan;
          return UniformPosologyRegisterPage(drugPlan: arguments);
        },
        updateUniformPosology: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as int;
          return UniformPosologyUpdatePage(drugPlanId: arguments);
        },
        createCustomPosology: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as DrugPlan;
          return CustomPosologyRegisterPage(drugPlan: arguments);
        },
        createWeeklyPosology: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as DrugPlan;
          return WeeklyPosologyRegisterPage(drugPlan: arguments);
        },
        updateWeeklyPosology: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as int;
          return WeeklyPosologyUpdatePage(drugPlanId: arguments);
        },
        richTextEditor: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as String?;
          return RichTextEditor(initialHtml: arguments);
        },
      };
}
