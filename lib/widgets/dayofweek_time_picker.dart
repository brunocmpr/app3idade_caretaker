import 'package:app3idade_caretaker/widgets/dayofweek_time.dart';
import 'package:flutter/material.dart';

Future<DayOfWeekTime?> showDayOfWeekTimePicker(BuildContext context, List<String> dayNames) async {
  final List<DropdownMenuItem<int>> daysDropDownItems = dayNames
      .map((day) => DropdownMenuItem<int>(
            value: (1 + dayNames.indexOf(day)),
            child: Text(day),
          ))
      .toList();

  int? selectedDay;
  return await showModalBottomSheet<DayOfWeekTime>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
        int defaultDay = 1;
        return SizedBox(
          height: 180,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Selecione um dia e um horário'),
                    SizedBox(width: 16),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<int>(
                      value: selectedDay ?? defaultDay,
                      items: daysDropDownItems,
                      onChanged: (int? value) {
                        if (value == null) return;
                        setState(() {
                          selectedDay = value;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        var navigator = Navigator.of(context);
                        TimeOfDay? timePicked = await showTimePicker(context: context, initialTime: selectedTime);
                        if (!navigator.mounted || timePicked == null) return;
                        selectedTime = timePicked;

                        DayOfWeekTime valuesPicked = DayOfWeekTime(selectedDay ?? defaultDay, timePicked);

                        navigator.pop(valuesPicked);
                      },
                      child: const Text('Selecionar horário'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
    },
  );
}
