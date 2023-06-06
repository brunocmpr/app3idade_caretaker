import 'package:app3idade_caretaker/models/drug.dart';
import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/models/patient.dart';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/auth_service.dart';
import 'package:app3idade_caretaker/services/drug_plan_service.dart';
import 'package:app3idade_caretaker/services/drug_service.dart';
import 'package:app3idade_caretaker/services/patient_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDestinationIndex = 0;
  List<Drug>? _drugs;
  List<Patient>? _patients;
  List<DrugPlan>? _drugPlans;
  final drugService = DrugService();
  final drugPlanService = DrugPlanService();
  final patientService = PatientService();

  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _loadDrugs();
    _loadPatients();
    _loadDrugPlans();
  }

  Future<void> _loadDrugPlans() async {
    final drugPlans = await drugPlanService.findAll();
    setState(() {
      _drugPlans = drugPlans;
    });
  }

  Future<void> _loadPatients() async {
    final patients = await patientService.findAll();
    setState(() {
      _patients = patients;
    });
  }

  Future<void> _loadDrugs() async {
    final drugs = await drugService.findAll();
    setState(() {
      _drugs = drugs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem vindo ao Terceira Idade Fácil!'),
        actions: [
          IconButton(
            onPressed: () {
              authService.logoutAndGoToLogin(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedDestinationIndex,
        onDestinationSelected: (value) => setState(() {
          _selectedDestinationIndex = value;
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Cronogramas',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_liquid),
            label: 'Medicamentos',
          ),
          NavigationDestination(
            icon: Icon(Icons.elderly),
            label: 'Pacientes',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var createEntityAndReturn = [
            () => Navigator.pushNamed(context, Routes.createBaseDrugPlan),
            () => Navigator.pushNamed(context, Routes.createDrug),
            () => Navigator.pushNamed(context, Routes.createPatient)
          ][_selectedDestinationIndex];
          await createEntityAndReturn();
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
      body: <Widget>[
        Column(
          children: [
            DrugPlanListView(
              _drugPlans,
              refreshRequested: (_) => _loadData(),
              drugPlanService: drugPlanService,
            ),
          ],
        ),
        Column(
          children: [
            DrugListView(
              _drugs,
              refreshRequested: (_) => _loadData(),
              drugService: drugService,
            ),
          ],
        ),
        Column(
          children: [
            PatientListView(
              _patients,
              refreshRequested: (_) => _loadData(),
              patientService: patientService,
            ),
          ],
        )
      ][_selectedDestinationIndex],
    );
  }
}

class PatientListView extends StatelessWidget {
  final List<Patient>? _patients;
  final ValueChanged<void> refreshRequested;
  final PatientService patientService;
  const PatientListView(this._patients, {Key? key, required this.refreshRequested, required this.patientService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_patients == null) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    } else if (_patients!.isEmpty) {
      return const Expanded(child: Center(child: Text('Nenhum paciente cadastrado.')));
    }
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => refreshRequested(null),
        child: ListView.builder(
          itemCount: _patients?.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(_patients![index].preferredName),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      onTap: () async {
                        var messenger = ScaffoldMessenger.of(context);
                        await patientService.deleteUserById(_patients![index].id!);
                        refreshRequested(null);
                        messenger.showSnackBar(
                          const SnackBar(content: Text("Paciente removido com sucesso.")),
                        );
                      },
                      child: const Text('Excluir'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Navigator.of(context).pushNamed(Routes.editPatient, arguments: _patients![index]);
                    } else if (value == 'delete') {}
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DrugPlanListView extends StatelessWidget {
  final List<DrugPlan>? _drugPlans;
  final ValueChanged<void> refreshRequested;
  final DrugPlanService drugPlanService;
  const DrugPlanListView(this._drugPlans, {Key? key, required this.refreshRequested, required this.drugPlanService})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (_drugPlans == null) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    } else if (_drugPlans!.isEmpty) {
      return const Expanded(child: Center(child: Text('Nenhum paciente cadastrado.')));
    }
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => refreshRequested(null),
        child: ListView.builder(
          itemCount: _drugPlans?.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(_drugPlans![index].drug.name),
                subtitle: Text(_drugPlans![index].patient.preferredName),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Excluir'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Navigator.of(context).pushNamed(Routes.editDrugPlan, arguments: _drugPlans![index]);
                    } else if (value == 'delete') {}
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DrugListView extends StatelessWidget {
  final List<Drug>? _drugs;
  final ValueChanged<void> refreshRequested;
  final DrugService drugService;
  const DrugListView(this._drugs, {Key? key, required this.refreshRequested, required this.drugService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_drugs == null) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    } else if (_drugs!.isEmpty) {
      return const Expanded(child: Center(child: Text('Nenhum medicamento cadastrado.')));
    }
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => refreshRequested(null),
        child: ListView.builder(
          itemCount: _drugs?.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(_drugs![index].name),
                subtitle: Text(_drugs![index].strength),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Editar'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Excluir'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Navigator.of(context).pushNamed(Routes.editDrug, arguments: _drugs![index]);
                    } else if (value == 'delete') {}
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
