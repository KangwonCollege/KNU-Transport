
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InnerBusArrival extends StatelessWidget{
  const InnerBusArrival({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 0, // 정류장의 갯수
      controller: PageController(initialPage: 0), // 사용자의 위치를 기준으로 가장 가까운 정류소를 위치 시킬 예정
      itemBuilder: (BuildContext context, int index) {
        return const Card(
          child: Column(
            children: <Widget>[
              // [UX] 특정 버튼을 누르면 반댓편 정류장을 알 수 있도록
              // [TEXT] MM분 후 출발 / 곧 도착 / 운행 종료
            ],
          ),
        );
      }
    );
  }
}