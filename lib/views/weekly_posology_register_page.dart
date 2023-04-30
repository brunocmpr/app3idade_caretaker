import 'dart:core';

import 'package:app3idade_caretaker/models/drug_plan.dart';
import 'package:app3idade_caretaker/util/util.dart';
import 'package:flutter/material.dart';

class WeeklyPosologyRegisterPage extends StatefulWidget {
  const WeeklyPosologyRegisterPage({super.key, required this.drugPlan});
  final DrugPlan drugPlan;
  @override
  State<WeeklyPosologyRegisterPage> createState() => WeeklyPosologyRegisterPageState();
}

class WeeklyPosologyRegisterPageState extends State<WeeklyPosologyRegisterPage> {
  final Map<int, List<TimeOfDay>> _times = {};
  static const daysPtBr = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
  static const dayOfWeek = 'dayOfWeek';
  static const timeOfDay = 'timeOfDay';

  int _getNumberOfTimes() {
    if (_times.isEmpty) return 0;
    return _times.values.reduce((accumulatorList, localList) => [...accumulatorList, ...localList]).length;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> timeComponents = [];
    int numberOfTimes = _getNumberOfTimes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo cronograma semanal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
                'Tratamento de ${widget.drugPlan.drug.nameAndStrength} para ${widget.drugPlan.patient.preferredName}.'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                DayOfWeekTime? dayOfWeekTime = await showDayOfWeekTimePicker(context);
                if (dayOfWeekTime == null) return;
                consumeNewWeeklyTime(dayOfWeekTime);
              },
              child: const Text('Adicionar dia da semana e hora'),
            ),
            const SizedBox(height: 8),
            Text('$numberOfTimes data${numberOfTimes == 1 ? '' : 's'} selecionadas'),
            const SizedBox(height: 8),
            Column(children: timeComponents)
          ],
        ),
      ),
    );
  }

  void consumeNewWeeklyTime(DayOfWeekTime value) {
    int dayOfWeek = value.day;
    TimeOfDay time = value.time;
    if (_times[dayOfWeek] != null && _times[dayOfWeek]!.contains(time)) {
      return;
    }
    setState(() {
      _times[dayOfWeek] = [..._times[dayOfWeek] ?? [], time];
    });
  }
}
