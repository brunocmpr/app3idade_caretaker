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
    loadData().then((_) => checkMissingResources(context));
  }

  Future<void> loadData() async {
    final List<List<Object>> results = await Future.wait([
      patientService.findAll(),
      drugService.findAll(),
    ]);
    setState(() {
      _patients = results[0] as List<Patient>;
      _selectedPatient = _patients != null && _patients!.isNotEmpty ? _patients![0] : null;
      _drugs = results[1] as List<Drug>;
      _selectedDrug = _drugs != null && _drugs!.isNotEmpty ? _drugs![0] : null;
    });
  }

  void checkMissingResources(BuildContext context) {
    if (_patients == null || _patients!.isEmpty) {
      showResourceMissingDialog(
          'É necessário registrar ao menos um paciente.', 'Registrar paciente', Routes.createPatient, context);
    } else if (_drugs == null || _drugs!.isEmpty) {
      showResourceMissingDialog(
          'É necessário registrar ao menos um medicamento.', 'Registrar medicamento', Routes.createDrug, context);
    }
  }

  Future<void> showResourceMissingDialog(
      String errorMessage, String okText, String routeToNavigateTo, BuildContext context) async {
    await showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, routeToNavigateTo);
            },
            child: Text(okText),
          ),
        ],
      ),
    );
  }

  DrugPlan buildDrugPlan(Patient patient, Drug drug, PosologyType type) {
    return DrugPlan.newPlan(patient, drug, type);
  }

  bool get _isFormStateValid => _patients != null && _patients!.isNotEmpty && _drugs != null && _drugs!.isNotEmpty;

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
              const Text('1. Selecione um paciente'),
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
              const Text('2. Selecione um medicamento'),
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
              const Text('3. Escolha um tipo de cronograma'),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.info_outlined),
                  SizedBox(width: 4),
                  Expanded(
                    child:
                        Text('Cronograma uniforme para que o medicamento tenha que ser tomado em intervalos regulares '
                            'como a cada 45 minutos, ou a cada 8 horas, ou a cada 2 dias.'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isFormStateValid
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          var drugPlan = buildDrugPlan(_selectedPatient!, _selectedDrug!, PosologyType.uniform);
                          Navigator.pushNamed(context, Routes.createUniformPosology, arguments: drugPlan);
                        }
                      }
                    : null,
                child: const Text('Escolher cronograma uniforme'),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.info_outlined),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                        'Cronograma semanal para que o medicamento tenha que ser tomado apenas em certos dias da semana.'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isFormStateValid
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          var drugPlan = buildDrugPlan(_selectedPatient!, _selectedDrug!, PosologyType.weekly);
                          Navigator.pushNamed(context, Routes.createWeeklyPosology, arguments: drugPlan);
                        }
                      }
                    : null,
                child: const Text('Escolher cronograma semanal'),
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.info_outlined),
                  SizedBox(width: 4),
                  Expanded(
                    child:
                        Text('Cronograma customizado para que você possa selecionar individualmente datas e horários.'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isFormStateValid
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          var drugPlan = buildDrugPlan(_selectedPatient!, _selectedDrug!, PosologyType.custom);
                          Navigator.pushNamed(context, Routes.createCustomPosology, arguments: drugPlan);
                        }
                      }
                    : null,
                child: const Text('Escolher cronograma customizado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
