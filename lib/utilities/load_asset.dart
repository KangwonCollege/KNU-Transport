import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:knu_transport/models/station_info.dart';

Future<T> loadJson<T>(String location) async {
  String source = await rootBundle.loadString(location);
  return (jsonDecode(source) as T);
}

Future<T> loadAsset<T>(
    String location, T Function(Map<String, dynamic>) parsingFunction) async {
  var source = await loadJson<Map<String, dynamic>>(location);
  return parsingFunction(source);
}

Future<List<T>> loadAssets<T>(
    String location, T Function(Map<String, dynamic>) parsingFunction) async {
  var source = await loadJson<List<dynamic>>(location);
  return source.map((e) => parsingFunction(e)).toList();
}
