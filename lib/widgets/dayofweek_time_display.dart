import 'package:app3idade_caretaker/widgets/dayofweek_time.dart';
import 'package:flutter/material.dart';

class DayOfWeekTimeDisplay extends StatelessWidget {
  final Map<int, List<TimeOfDay>> timeMap;
  final ValueChanged<DayOfWeekTime> onDayOfWeekTimeRemoved;
  final List<String> dayOfWeekNames;

  const DayOfWeekTimeDisplay(
      {super.key, required this.timeMap, required this.dayOfWeekNames, required this.onDayOfWeekTimeRemoved});

  @override
  Widget build(BuildContext context) {
    late List<Widget> texts;
    if (timeMap.isEmpty) {
      texts = [];
    } else {
      // texts = timeMap.entries.map((entry) {
      //   int day = entry.key;
      //   List<TimeOfDay> times = entry.value;
      //   List<Widget> timeWidgets = times.map((time) => Text(time.toString())).toList();
      //   // return Column(
      //   //   children: [
      //   //     Text(daysPtBr[day - 1]),
      //   //     ...timeWidgets,
      //   //   ],
      //   // );
      //   return <Widget>[Text(daysPtBr[day - 1]), ...timeWidgets];
      // }).reduce((accumulatorList, localList) {
      //   return [...accumulatorList, ...localList];
      // });
      texts = timeMap.entries.map((entry) {
        int day = entry.key;
        List<TimeOfDay> times = entry.value;
        List<Widget> timeWidgets = times
            .map((time) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(time.format(context)),
                    ElevatedButton(
                        onPressed: () => onDayOfWeekTimeRemoved(DayOfWeekTime(day, time)),
                        child: const Text('Remover')),
                  ],
                ))
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(alignment: Alignment.centerLeft, child: Text('${dayOfWeekNames[day - 1]}:')),
            const SizedBox(height: 4),
            ...timeWidgets,
          ],
        );
      }).toList();
    }
    return Column(
      children: texts,
    );
  }
}
