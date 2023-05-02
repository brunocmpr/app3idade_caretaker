import 'dart:core';

import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/models/weekly_posology.dart';
import 'package:app3idade_caretaker/models/weekly_posology_date_time.dart';
import 'package:app3idade_caretaker/routes/routes.dart';
import 'package:app3idade_caretaker/services/drug_plan_service.dart';
import 'package:app3idade_caretaker/util/util.dart';
import 'package:app3idade_caretaker/widgets/datetime_picker.dart';
import 'package:app3idade_caretaker/widgets/dayofweek_time.dart';
import 'package:app3idade_caretaker/widgets/dayofweek_time_display.dart';
import 'package:app3idade_caretaker/widgets/dayofweek_time_picker.dart';
import 'package:flutter/material.dart';

class WeeklyPosologyRegisterPage extends StatefulWidget {
  const WeeklyPosologyRegisterPage({super.key, required this.drugPlan});
  final DrugPlan drugPlan;
  @override
  State<WeeklyPosologyRegisterPage> createState() => WeeklyPosologyRegisterPageState();
}

class WeeklyPosologyRegisterPageState extends State<WeeklyPosologyRegisterPage> {
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime? _endDate;
  final Map<int, List<TimeOfDay>> _timeMap = {};

  final _drugPlanService = DrugPlanService();

  Future<void> _submit() async {
    List<WeeklyPosologyDateTime> weeklyPosologyDateTimes = _timeMap.entries
        .map((entry) => entry.value.map((times) => WeeklyPosologyDateTime.newDateTime(entry.key, times)))
        .reduce((accumulator, list) => [...accumulator, ...list])
        .toList();
    WeeklyPosology weeklyPosology = WeeklyPosology.newPosology(_startDate, _endDate, weeklyPosologyDateTimes);
    widget.drugPlan.weeklyPosology = weeklyPosology;
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
        title: const Text('Novo cronograma semanal'),
      ),
      floatingActionButton: Visibility(
        visible: isReadyToSubmit(),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: isReadyToSubmit() ? _submit : null,
          child: const Icon(Icons.done),
        ),
      ),
      body: Padding(
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
                'Tratamento de ${widget.drugPlan.drug.nameAndStrength} para ${widget.drugPlan.patient.preferredName}.'),
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
    );
  }
}
