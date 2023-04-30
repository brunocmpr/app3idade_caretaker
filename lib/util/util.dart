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

const Map<int, String> dayMap = {
  1: 'MONDAY',
  2: 'TUESDAY',
  3: 'WEDNESDAY',
  4: 'THURSDAY',
  5: 'FRIDAY',
  6: 'SATURDAY',
  7: 'SUNDAY'
};

const daysPtBr = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
