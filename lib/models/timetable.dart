
class Timetable {
  final int hour;
  final int minute;
  int? sessionIndex; 

  Timetable({
    required this.hour,
    required this.minute,
    this.sessionIndex
  });

  Timetable.fromJson(Map<String, int> json, int? _sessionIndex) 
    : hour = json['h'] as int,
    minute = json['m'] as int,
    sessionIndex = _sessionIndex as int;


}


