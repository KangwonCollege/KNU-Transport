import 'dart:convert';

import 'package:flutter/services.dart';

Future<T> loadJson<T>(String location) async {
  var source = await rootBundle.loadString(location);
  return (jsonDecode(source) as T);
}

Future<T> loadAsset<T>(
    String location, T Function(Map<String, dynamic>) parsingFunction) async {
  var source = await loadJson<Map<String, dynamic>>(location);
  return parsingFunction(source);
}

Future<List<T>> loadAssets<T>(
    String location, T Function(Map<String, dynamic>) parsingFunction) async {
  var source = await loadJson<List<Map<String, dynamic>>>(location);
  return source.map(parsingFunction).toList();
}
