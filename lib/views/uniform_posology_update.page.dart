import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/models/uniform_posology.dart';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/drug_plan_service.dart';
import 'package:app3idade_caretaker/services/uniform_posology_service.dart';
import 'package:app3idade_caretaker/util/util.dart';
import 'package:app3idade_caretaker/widgets/datetime_picker.dart';
import 'package:flutter/material.dart';

class UniformPosologyUpdatePage extends StatefulWidget {
  const UniformPosologyUpdatePage({super.key, required this.drugPlanId});
  final int drugPlanId;
  @override
  State<StatefulWidget> createState() => UniformPosologyUpdatePageState();
}

class UniformPosologyUpdatePageState extends State<UniformPosologyUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final DateTime today0h00 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime? _endDate;
  int? _timeLength = 8;
  TimeUnit _timeUnit = TimeUnit.hour;
  final _drugPlanService = DrugPlanService();
  late TextEditingController _timeLengthController;

  DrugPlan? _drugPlan;
  bool _isLoading = true;

  final _service = UniformPosologyService();

  @override
  void initState() {
    super.initState();
    _timeLengthController = TextEditingController(text: _timeLength.toString());
    _fetchData().then((_) => _isLoading = false);
  }

  Future<void> _fetchData() async {
    var navigator = Navigator.of(context);
    _drugPlan = await _drugPlanService.findById(widget.drugPlanId);
    if (_drugPlan == null) {
      navigator.pop();
      return;
    }
    setState(() {
      _startDate = _drugPlan!.uniformPosology!.startDateTime;
      _endDate = _drugPlan!.uniformPosology!.endDateTime;
      _timeLength = _drugPlan!.uniformPosology!.timeLength;
      _timeUnit = _drugPlan!.uniformPosology!.timeUnit;
      _timeLengthController = TextEditingController(text: _timeLength.toString());
    });
  }

  bool isReadyToSubmit() => formStateValid();
  bool formStateValid() =>
      _timeLength != null && !_timeLength!.isNegative && (_endDate == null || _startDate.compareTo(_endDate!) < 0);

  String get patientAndDrugDescription =>
      'Tratamento de ${_drugPlan?.drug.nameAndStrength} para ${_drugPlan?.patient.preferredName}.';

  Future<void> _submit() async {
    _drugPlan!.uniformPosology!.startDateTime = _startDate;
    _drugPlan!.uniformPosology!.endDateTime = _endDate;
    _drugPlan!.uniformPosology!.timeLength = _timeLength!;
    _drugPlan!.uniformPosology!.timeUnit = _timeUnit;

    try {
      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      await _service.update(_drugPlan!);
      navigator.popUntil(ModalRoute.withName(Routes.homePage));
      messenger.showSnackBar(
        const SnackBar(content: Text("Tratamento atualizado com sucesso")),
      );
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $exception")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String planDescription = 'Favor preencher todos os campos corretamente.';
    if (_endDate != null && formStateValid()) {
      int unitMultiplier = 1;
      switch (_timeUnit) {
        case TimeUnit.minute:
          unitMultiplier = 1;
          break;
        case TimeUnit.hour:
          unitMultiplier = 60;
          break;
        case TimeUnit.day:
          unitMultiplier = 60 * 24;
          break;
        case TimeUnit.week:
          unitMultiplier = 60 * 24 * 7;
          break;
      }

      int numberDoses = 1 + (_endDate!.difference(_startDate).inMinutes / (_timeLength! * unitMultiplier)).floor();
      DateTime lastDoseDate = _startDate.add(Duration(minutes: (numberDoses - 1) * _timeLength! * unitMultiplier));

      planDescription =
          '''Serão tomadas $numberDoses doses no total, a cada intervalo de $_timeLength ${_timeUnit.namePtBr()}.
A primeira dose ocorrerá em ${formatDateTime(_startDate)} e a última será tomada em ${formatDateTime(lastDoseDate)}.''';
    } else if (formStateValid()) {
      planDescription =
          'Inicia em ${formatDateTime(_startDate)}, com doses a cada $_timeLength ${_timeUnit.namePtBr()}, não tendo previsão de fim.';
    }
    var dropdownTimeUnitItems =
        TimeUnit.values.map((unit) => DropdownMenuItem(value: unit, child: Text(unit.namePtBr()))).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar cronograma uniforme'),
      ),
      floatingActionButton: Visibility(
        visible: isReadyToSubmit(),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: isReadyToSubmit() ? _submit : null,
          child: const Icon(Icons.done),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('1. Informe a data de início do uso do medicamento'),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: DateTimePicker(
                      label: 'Adicionar',
                      onDateTimeChanged: (dateTime) => setState(() => _startDate =
                          DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Início: ${formatDateTime(_startDate)}'),
                ],
              ),
              const SizedBox(height: 16),
              const Text('2. (Opcional) Informe a data de fim do uso do medicamento'),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: DateTimePicker(
                      label: 'Adicionar',
                      onDateTimeChanged: (dateTime) => setState(() => _endDate =
                          DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute)),
                      firstDate: _endDate ?? _startDate,
                      initialDate: _endDate ?? _startDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(_endDate != null ? 'Fim: ${formatDateTime(_endDate!)}' : 'Sem data prevista para fim'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: _endDate != null ? () => setState(() => _endDate = null) : null,
                      child: const Text('Descartar'),
                    ),
                  ),
                  const SizedBox()
                ],
              ),
              const SizedBox(height: 16),
              const Text('3. Informe a cada quanto tempo o medicamento deve ser tomado:'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _timeLengthController,
                      validator: _positiveNumberValidator,
                      onChanged: (String? value) {
                        if (value == null || int.tryParse(value) == null) {
                          return;
                        }
                        setState(() => _timeLength = (int.parse(value)));
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<TimeUnit>(
                      value: _timeUnit,
                      items: dropdownTimeUnitItems,
                      onChanged: (unit) => setState(() {
                        _timeUnit = unit ?? _timeUnit;
                      }),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              Text(patientAndDrugDescription, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                planDescription,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _positiveNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (int.parse(value) <= 0) {
      return 'Valor deve ser positivo';
    }
    return null;
  }
}
