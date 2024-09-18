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

final dataTimetableProvider = FutureProvider<List<List<DateTime>>>((ref) async {
  DateTime dt = DateTime.now();
  var originRouteInfo = await loadJson<List<List<Map<String, int>>>>("assets/data/inner_bus/timetable.json");
  var result = List<List<DateTime>>.filled(originRouteInfo[0].length, List.empty());
  for (var data1 in originRouteInfo.asMap().entries) {
    for(var data2 in data1.value.asMap().entries) {
      result[data2.key].add(
        Timetable.fromJson(data2.value, data2.key, data1.key)
          .toDateTime(dt)
      );
    }
  }
  return result;
});
