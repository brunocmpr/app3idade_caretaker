import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/models/uniform_posology.dart';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/drug_plan_service.dart';
import 'package:app3idade_caretaker/util/util.dart';
import 'package:app3idade_caretaker/widgets/datetime_picker.dart';
import 'package:flutter/material.dart';

class UniformPosologyRegisterPage extends StatefulWidget {
  const UniformPosologyRegisterPage({super.key, required this.drugPlan});
  final DrugPlan drugPlan;
  @override
  State<StatefulWidget> createState() => UniformPosologyRegisterPageState();
}

class UniformPosologyRegisterPageState extends State<UniformPosologyRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final DateTime today0h00 = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime? _endDate;
  int? _timeLength = 8;
  TimeUnit _timeUnit = TimeUnit.hour;

  final _drugPlanService = DrugPlanService();

  late TextEditingController _timeLengthController;

  bool get formStateValid => _timeLength != null && !_timeLength!.isNegative;

  String get patientAndDrugDescription =>
      'Tratamento de ${widget.drugPlan.drug.nameAndStrength} para ${widget.drugPlan.patient.preferredName}.';

  Future<void> _submit() async {
    UniformPosology newPosology = UniformPosology.newPosology(_startDate, _timeLength!, _timeUnit, _endDate);
    widget.drugPlan.uniformPosology = newPosology;
    try {
      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      await _drugPlanService.createDrugPlan(widget.drugPlan);
      navigator.popUntil(ModalRoute.withName(Routes.homePage));
      messenger.showSnackBar(
        const SnackBar(content: Text("Tratamento criado com sucesso")),
      );
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $exception")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _timeLengthController = TextEditingController(text: _timeLength.toString());
  }

  @override
  Widget build(BuildContext context) {
    String planDescription = 'Favor preencher todos os campos';
    if (_endDate != null && formStateValid) {
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
    } else if (formStateValid) {
      planDescription =
          'Inicia em ${formatDateTime(_startDate)}, com doses a cada $_timeLength ${_timeUnit.namePtBr()}, não tendo previsão de fim.';
    }
    var dropdownTimeUnitItems =
        TimeUnit.values.map((unit) => DropdownMenuItem(value: unit, child: Text(unit.namePtBr()))).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo cronograma uniforme'),
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
                      label: 'Início',
                      onDateTimeChanged: (dateTime) => setState(() => _startDate =
                          DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(formatDateTime(_startDate))
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
                      label: 'Fim',
                      onDateTimeChanged: (dateTime) => setState(() => _endDate =
                          DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute)),
                      firstDate: _endDate ?? _startDate,
                      initialDate: _endDate ?? _startDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(_endDate != null ? formatDateTime(_endDate!) : 'Sem data prevista para fim'),
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
              Text(patientAndDrugDescription),
              Text(planDescription),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && formStateValid) {
                    _submit();
                  }
                },
                child: const Text('Criar'),
              )
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
