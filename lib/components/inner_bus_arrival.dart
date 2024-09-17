import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:knu_transport/models/station_info.dart';

class InnerBusArrival extends StatelessWidget {
  InnerBusArrival({super.key, required List<StationInfo> stations, required PageController controller})
      : this.station = stations,
        this.controller = controller;

  List<StationInfo> station = List.empty();
  late PageController controller;

  Widget card(StationInfo info) {
    // final DateTime nowTime = DateTime.now();
    return Card(
      child: Column(
        children: <Widget>[
          // [UX] 특정 버튼을 누르면 반댓편 정류장을 알 수 있도록
          // [TEXT] MM분 후 출발 / 곧 도착 / 운행 종료
          Text(info.name)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final componentSize = Size(mediaQuery.size.width - 32, 0);

    return SizedBox(
      width: componentSize.width,
      height: 100,
      child: PageView.builder(
        itemCount: station.length, // 정류장의 갯수
        controller: controller, // 사용자의 위치를 기준으로 가장 가까운 정류소를 위치 시킬 예정
        itemBuilder: (BuildContext context, int index) {
          return card(station[index]);
        })
    );
  }
}
