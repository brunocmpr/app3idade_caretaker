import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final String label;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime? firstDate;
  final DateTime? initialDate;

  const DateTimePicker(
      {Key? key, required this.label, required this.onDateTimeChanged, this.firstDate, this.initialDate})
      : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _initialDate;
  late DateTime _firstDate;
  late TimeOfDay _initialTime;
  final maxYear = 2100;
  @override
  void initState() {
    super.initState();
    resetState();
  }

  void resetState() {
    _initialDate = widget.initialDate ?? DateTime.now();
    _firstDate = widget.firstDate ?? DateTime.now();
    _initialTime = TimeOfDay.fromDateTime(_initialDate);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var dateTime = await _selectDateTime(context);
        if (dateTime == null) return;
        widget.onDateTimeChanged(dateTime);
      },
      child: Text(widget.label),
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: _firstDate,
      lastDate: DateTime(maxYear),
    );
    if (pickedDate == null || !mounted) {
      resetState();
      return null;
    }
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _initialTime,
    );
    if (pickedTime == null) {
      resetState();
      return null;
    }
    _initialDate = pickedDate;
    _initialTime = pickedTime;
    final DateTime combinedDateTime =
        DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
    return combinedDateTime;
  }
}
