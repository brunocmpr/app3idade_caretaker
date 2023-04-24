class UniformPosology {}

enum TimeUnit { minutes, hours, days, weeks }

extension TimeUnitPtBr on TimeUnit {
  static Map<TimeUnit, String> map = {
    TimeUnit.minutes: 'minutos',
    TimeUnit.hours: 'horas',
    TimeUnit.days: 'dias',
    TimeUnit.weeks: 'semanas',
  };
  String namePtBr() {
    return map[this] ?? toString();
  }

  TimeUnit? fromNamePtBr(String translation) {
    return map.entries.firstWhere((element) => element.value == translation).key;
  }
}
