import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) => DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
String formatDate(DateTime dateTime) => DateFormat('dd/MM/yyyy').format(dateTime);

String? weekdayStringFromInteger(int dayValue) {
  String? weekdayString;
  if (dayMap.containsKey(dayValue)) weekdayString = dayMap[dayValue];
  return weekdayString;
}

int? weekdayIntegerFromString(String dayValue) {
  int? weekdayInteger;
  if (dayMap.containsValue(dayValue)) weekdayInteger = dayMap.keys.firstWhere((key) => dayMap[key] == dayValue);
  return weekdayInteger;
}

Map<int, String> dayMap = {
  1: 'MONDAY',
  2: 'TUESDAY',
  3: 'WEDNESDAY',
  4: 'THURSDAY',
  5: 'FRIDAY',
  6: 'SATURDAY',
  7: 'SUNDAY'
};

Future<DayOfWeekTime?> showDayOfWeekTimePicker(BuildContext context) async {
  const daysPtBr = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
  final List<DropdownMenuItem<int>> daysDropDownItems = daysPtBr
      .map((day) => DropdownMenuItem<int>(
            value: (1 + daysPtBr.indexOf(day)),
            child: Text(day),
          ))
      .toList();

  return await showModalBottomSheet<DayOfWeekTime>(
    context: context,
    builder: (BuildContext context) {
      TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
      int selectedDay = 1;
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
                    value: selectedDay,
                    items: daysDropDownItems,
                    onChanged: (int? value) {
                      if (value == null) return;
                      selectedDay = value;
                    },
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      var navigator = Navigator.of(context);
                      TimeOfDay? timePicked = await showTimePicker(context: context, initialTime: selectedTime);
                      if (!navigator.mounted || timePicked == null) return;
                      selectedTime = timePicked;

                      DayOfWeekTime valuesPicked = DayOfWeekTime(selectedDay, timePicked);

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
    },
  );
}

class DayOfWeekTime {
  final int day;
  final TimeOfDay time;
  const DayOfWeekTime(this.day, this.time);
}
