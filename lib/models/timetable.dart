
class Timetable {
  final int hour;
  final int minute;
  int? stationId;
  int? sessionIndex; 

  Timetable({
    required this.hour,
    required this.minute,
    this.stationId,
    this.sessionIndex
  });

  Timetable.fromJson(Map<String, int> json, int? _stationId, int? _sessionIndex) 
    : hour = json['h'] as int,
    minute = json['m'] as int,
    stationId = _stationId,
    sessionIndex = _sessionIndex;

  DateTime toDateTime(DateTime? date) {
    date ??= DateTime.now();
    return DateTime(
      date.year, 
      date.month,
      date.day,
      hour,
      minute
    );
  }
}


