import 'package:flutter/material.dart';
import 'package:knu_transport/components/inner_bus_map.dart';
import 'package:knu_transport/components/inner_bus_arrival.dart';

class InnerBusPage extends StatelessWidget {
  const InnerBusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Text(
          "교내 순환버스",
           style: TextStyle(
            color: Color(0xff000000),
            decoration: TextDecoration.none
          ),
           textAlign: TextAlign.start,
        ),
        InnerBusMap(), // 지도
        InnerBusArrival()
      ],
    );
  }
}