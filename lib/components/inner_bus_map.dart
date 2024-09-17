
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class InnerBusMap extends StatelessWidget{
  const InnerBusMap({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final componentSize = Size(mediaQuery.size.width - 32, mediaQuery.size.height - 300);

    return SizedBox(
        width: componentSize.width,
        height: componentSize.height,
        child: const Card(
          child: NaverMap()
        )
    );
  }
}