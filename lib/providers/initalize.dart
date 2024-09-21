import 'package:flutter/material.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/models/timetable.dart';
import 'package:knu_transport/utilities/load_asset.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final dataStationInfoProvider = FutureProvider<List<StationInfo>>((ref) async {
  List<StationInfo> station = await loadAssets(
      "assets/data/inner_bus/station_info.json", StationInfo.fromJson);
  return station; 
});

final dataRouteInfoProvider = FutureProvider<List<List<double>>>((ref) async {
  List<List<double>> routeInfo =
        await loadJson("assets/data/inner_bus/routeInfo.json");
    return routeInfo;
});

final dataTimetableProvider = FutureProvider<List<List<Timetable>>>((ref) async {
  var timetableInfo = await loadJson<List<dynamic>>("assets/data/inner_bus/timetable.json");
  // print(timetableInfo);
  List<List<Timetable>> result = List.generate(timetableInfo[0].length, (i) => List.empty(growable: true));
  for(MapEntry<int, List<dynamic>> data1 in timetableInfo.cast<List<dynamic>>().asMap().entries) {
    for(MapEntry<int, Map<dynamic, dynamic>> data2 in data1.value.cast<Map<dynamic, dynamic>>().asMap().entries) {
      result[data2.key].add(Timetable.fromJson(data2.value.cast<String, int>(), data1.key));
    }
  }
  return result;
});
