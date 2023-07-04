import 'dart:core';
import 'dart:developer';

import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/models/weekly_posology.dart';
import 'package:app3idade_caretaker/models/weekly_posology_date_time.dart';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/drug_plan_service.dart';
import 'package:app3idade_caretaker/services/weekly_posology_service.dart';
import 'package:app3idade_caretaker/util/util.dart';
import 'package:app3idade_caretaker/widgets/datetime_picker.dart';
import 'package:app3idade_caretaker/widgets/dayofweek_time.dart';
import 'package:app3idade_caretaker/widgets/dayofweek_time_display.dart';
import 'package:app3idade_caretaker/widgets/dayofweek_time_picker.dart';
import 'package:flutter/material.dart';

class WeeklyPosologyUpdatePage extends StatefulWidget {
  const WeeklyPosologyUpdatePage({super.key, required this.drugPlanId});
  final int drugPlanId;
  @override
  State<WeeklyPosologyUpdatePage> createState() => WeeklyPosologyUpdatePageState();
}

class WeeklyPosologyUpdatePageState extends State<WeeklyPosologyUpdatePage> {
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime? _endDate;
  final Map<int, List<TimeOfDay>> _timeMap = {};

  DrugPlan? _drugPlan;
  bool _isLoading = true;
  final weeklyPosologyService = WeeklyPosologyService();

  final _drugPlanService = DrugPlanService();

  Future<void> _fetchData() async {
    var navigator = Navigator.of(context);
    _drugPlan = await _drugPlanService.findById(widget.drugPlanId);
    if (_drugPlan == null) {
      navigator.pop();
      return;
    }
    setState(() {
      _startDate = _drugPlan!.weeklyPosology!.startDateTime;
      _endDate = _drugPlan!.weeklyPosology!.endDateTime;
    });
    for (var element in _drugPlan!.weeklyPosology!.weeklyPosologyDateTimes) {
      assignNewWeeklyTime(DayOfWeekTime(element.dayOfWeek, element.time));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData().then((_) => _isLoading = false);
  }

  Future<void> _submit() async {
    try {
      List<WeeklyPosologyDateTime> weeklyPosologyDateTimes = _timeMap.entries
          .map((entry) => entry.value.map((times) => WeeklyPosologyDateTime.newDateTime(entry.key, times)))
          .reduce((accumulator, list) => [...accumulator, ...list])
          .toList();
      _drugPlan!.weeklyPosology!.weeklyPosologyDateTimes = weeklyPosologyDateTimes;
      _drugPlan!.weeklyPosology!.startDateTime = _startDate;
      _drugPlan!.weeklyPosology!.endDateTime = _endDate;

      var navigator = Navigator.of(context);
      var messenger = ScaffoldMessenger.of(context);
      bool? operationConfirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Atenção'),
          content: const Text('Confirma atualização do cronograma?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sim'),
            ),
          ],
        ),
      );
      if (operationConfirmed == null || !operationConfirmed) return;
      setState(() {
        _isLoading = true;
      });
      await weeklyPosologyService.update(_drugPlan!);
      navigator.popUntil(ModalRoute.withName(Routes.homePage));
      messenger.showSnackBar(
        const SnackBar(content: Text("Tratamento criado com sucesso")),
      );
    } on Exception catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $exception")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _getNumberOfTimes() {
    if (_timeMap.isEmpty) return 0;
    return _timeMap.values.reduce((accumulatorList, localList) => [...accumulatorList, ...localList]).length;
  }

  void removeDayOfWeekTime(DayOfWeekTime obj) {
    List<TimeOfDay>? times = _timeMap[obj.day];
    if (times == null || times.isEmpty) return;
    times.remove(obj.time);
    if (times.isEmpty) {
      setState(() {
        _timeMap.remove(obj.day);
      });
    } else {
      setState(() {
        _timeMap[obj.day] = times;
      });
    }
  }

  void assignNewWeeklyTime(DayOfWeekTime value) {
    int dayOfWeek = value.day;
    TimeOfDay time = value.time;
    if (_timeMap[dayOfWeek] != null && _timeMap[dayOfWeek]!.contains(time)) {
      return;
    }
    setState(() {
      _timeMap[dayOfWeek] = [..._timeMap[dayOfWeek] ?? [], time];
    });
  }

  bool isReadyToSubmit([int? numberOfTimes]) {
    numberOfTimes = numberOfTimes ?? _getNumberOfTimes();
    return (_endDate == null || _startDate.compareTo(_endDate!) < 0) && numberOfTimes > 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> timeComponents = [];
    int numberOfTimes = _getNumberOfTimes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar cronograma semanal'),
      ),
      floatingActionButton: Visibility(
        visible: isReadyToSubmit(),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: isReadyToSubmit() ? _submit : null,
          child: const Icon(Icons.done),
        ),
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: _isLoading,
            child: Opacity(
              opacity: _isLoading ? 0.5 : 1.0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
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
                    const SizedBox(height: 8),
                    const Text('3. Adicione um ou mais horários semanais'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        DayOfWeekTime? dayOfWeekTime = await showDayOfWeekTimePicker(context, daysPtBr);
                        if (dayOfWeekTime == null) return;
                        assignNewWeeklyTime(dayOfWeekTime);
                      },
                      child: const Text('Adicionar dia da semana e hora'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tratamento de ${_drugPlan?.drug.nameAndStrength} para ${_drugPlan?.patient.preferredName}.',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        '$numberOfTimes horario${numberOfTimes == 1 ? '' : 's'} semana${numberOfTimes == 1 ? 'l' : 'is'} selecionado${numberOfTimes == 1 ? '' : 's'}:'),
                    const SizedBox(height: 8),
                    DayOfWeekTimeDisplay(
                        timeMap: _timeMap, dayOfWeekNames: daysPtBr, onDayOfWeekTimeRemoved: removeDayOfWeekTime),
                    const SizedBox(height: 8),
                    Column(children: timeComponents),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
