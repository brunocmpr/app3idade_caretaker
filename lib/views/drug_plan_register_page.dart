import 'package:app3idade_caretaker/models/drug.dart';
import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/models/patient.dart';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/drug_service.dart';
import 'package:app3idade_caretaker/services/patient_service.dart';
import 'package:flutter/material.dart';

class DrugPlanPage extends StatefulWidget {
  const DrugPlanPage({super.key});

  @override
  State<DrugPlanPage> createState() => DrugPlanPageState();
}

class DrugPlanPageState extends State<DrugPlanPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final drugService = DrugService();
  final patientService = PatientService();
  List<Patient>? _patients;
  List<Drug>? _drugs;
  Patient? _selectedPatient;
  Drug? _selectedDrug;

  final _title = 'Registrar plano de tratamento';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final List<List<Object>> results = await Future.wait([
      patientService.findAll(),
      drugService.findAll(),
    ]);
    setState(() {
      _patients = results[0] as List<Patient>;
      _selectedPatient = _patients![0];
      _drugs = results[1] as List<Drug>;
      _selectedDrug = _drugs![0];
    });
  }

  DrugPlan buildDrugPlan(Patient patient, Drug drug, PosologyType type) {
    return DrugPlan.newPlan(patient, drug, type);
  }

  @override
  Widget build(BuildContext context) {
    var patientDropDownItems = _patients
        ?.map((patient) => DropdownMenuItem<Patient>(value: patient, child: Text(patient.preferredName)))
        .toList();
    var drugDropDownItems =
        _drugs?.map((drug) => DropdownMenuItem<Drug>(value: drug, child: Text(drug.nameAndStrength))).toList();
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Selecione um paciente'),
              DropdownButtonFormField<Patient>(
                items: patientDropDownItems,
                value: _selectedPatient,
                onChanged: (patient) => setState(() {
                  _selectedPatient = patient;
                }),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Selecione um medicamento'),
              DropdownButtonFormField<Drug>(
                items: drugDropDownItems,
                value: _selectedDrug,
                onChanged: (drug) => setState(() {
                  _selectedDrug = drug;
                }),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelStyle: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.5),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var drugPlan = buildDrugPlan(_selectedPatient!, _selectedDrug!, PosologyType.uniform);
                    Navigator.pushNamed(context, Routes.createUniformPosology, arguments: drugPlan);
                  }
                },
                child: const Text('Registrar cronograma uniforme'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var drugPlan = buildDrugPlan(_selectedPatient!, _selectedDrug!, PosologyType.weekly);
                    Navigator.pushNamed(context, Routes.createWeeklyPosology, arguments: drugPlan);
                  }
                },
                child: const Text('Registrar cronograma semanal'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var drugPlan = buildDrugPlan(_selectedPatient!, _selectedDrug!, PosologyType.custom);
                    Navigator.pushNamed(context, Routes.createCustomPosology, arguments: drugPlan);
                  }
                },
                child: const Text('Registrar cronograma customizado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
