
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InnerBusArrival extends StatelessWidget{
  const InnerBusArrival({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: <Widget>[
          Text("ㅇㅇ정류장 예정시간"),
          Text("00 분 후 도착 예정", textAlign: TextAlign.end)
        ],
      ),
    );
  }
}