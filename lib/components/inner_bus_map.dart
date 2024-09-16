
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class InnerBusMap extends StatelessWidget{
  const InnerBusMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: <Widget>[
          // NaverMap()
        ], // 네이버 맵을 활용하여 버스의 노선도를 그려줄 예정, 
        // inner_bus_arriaval의 pageCount를 이용하여 그 정류장으로 지도의 카메라를 조정하려고 함. 
      ),
    );
  }
}