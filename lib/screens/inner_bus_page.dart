import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class InnerBusPage extends StatelessWidget {
  const InnerBusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text("테스트"),
          NaverMap()
        ],
      ),
    );
  }
}