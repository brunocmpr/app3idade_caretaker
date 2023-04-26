import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) => DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
String formatDate(DateTime dateTime) => DateFormat('dd/MM/yyyy').format(dateTime);
