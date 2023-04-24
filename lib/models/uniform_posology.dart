class UniformPosology {}

enum TimeUnit { minute, hour, day, week }

extension TimeUnitPtBr on TimeUnit {
  static Map<TimeUnit, String> map = {
    TimeUnit.minute: 'minutos',
    TimeUnit.hour: 'horas',
    TimeUnit.day: 'dias',
    TimeUnit.week: 'semanas',
  };
  String namePtBr() {
    return map[this] ?? toString();
  }

  TimeUnit? fromNamePtBr(String translation) {
    return map.entries.firstWhere((element) => element.value == translation).key;
  }
}
