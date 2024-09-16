import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/utilities/load_asset.dart';

class InnerBusArrival extends StatelessWidget {
  InnerBusArrival({super.key, required List<StationInfo> stations});

  final List<StationInfo> stations = List.empty();

  Widget card(StationInfo stationInfo) {
    final DateTime nowTime = DateTime.now();

    return const Card(
      child: Column(
        children: <Widget>[
          // [UX] 특정 버튼을 누르면 반댓편 정류장을 알 수 있도록
          // [TEXT] MM분 후 출발 / 곧 도착 / 운행 종료
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);

    return PageView.builder(
        itemCount: stations.length, // 정류장의 갯수
        controller: pageController, // 사용자의 위치를 기준으로 가장 가까운 정류소를 위치 시킬 예정
        itemBuilder: (BuildContext context, int index) {
          return card(stations[index]);
        });
  }
}
