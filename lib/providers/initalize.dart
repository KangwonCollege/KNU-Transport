import 'package:knu_transport/models/station_info.dart';
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
