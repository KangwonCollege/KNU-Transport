import 'package:flutter/material.dart';

class Timetable extends TimeOfDay {
  int? sessionIndex;

  Timetable({required super.hour, required super.minute, this.sessionIndex});

  Timetable.fromJson(Map<String, int> json, int? _sessionIndex)
      : sessionIndex = _sessionIndex as int,
        super(hour: json['h'] as int, minute: json['m'] as int);

  int totalMinute() {
    return hour * 60 + minute;
  }

  int compareTo(TimeOfDay other) {
    int thisTotalMinute = totalMinute();
    int otherTotalMinute = other.hour * 60 + other.minute;
    return thisTotalMinute.compareTo(otherTotalMinute);
  }
}
