
class Timetable {
  final int hour;
  final int minute;

  const Timetable({
    required this.hour,
    required this.minute,
  });

  Timetable.fromJson(Map<String, dynamic> json) 
    : hour = json['h'] as int,
    minute = json['m'] as int;

  DateTime toDateTime(DateTime? date) {
    date ??= DateTime.now();
    return new DateTime(
      date.year, 
      date.month,
      date.day,
      hour,
      minute
    );
  }
}


