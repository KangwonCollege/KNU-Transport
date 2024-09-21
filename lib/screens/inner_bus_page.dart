import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/providers/initalize.dart';
import 'package:knu_transport/utilities/load_asset.dart';
import 'package:knu_transport/utilities/text_size.dart';
import 'package:knu_transport/widgets/inner_bus/route_card.dart';
import 'package:knu_transport/widgets/inner_bus/route_map.dart';

class InnerBusPage extends ConsumerStatefulWidget {
  const InnerBusPage({super.key});

  @override
  _InnerBusPageState createState() => _InnerBusPageState();
}

class _InnerBusPageState extends ConsumerState<InnerBusPage> {
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  late PageController _pageController;
  late TabController _tabController;
  late NaverMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pageSize = Size(mediaQuery.size.width, mediaQuery.size.height);

    final routeInfo = ref.watch(dataRouteInfoProvider);
    routeInfo.whenData((routeInfo) {
      print(routeInfo);
    });
    if (routeInfo.hasError) {
      print(routeInfo.error.toString());
    }

    return Scaffold(
        backgroundColor: Color(0xffefefff),
        body: () {
          // _tabController = TabController(length: stations.length, vsync: vsync)

          return SizedBox(
              width: pageSize.width,
              height: pageSize.height,
              child: Column(
                children: [
                  // RouteMap(onMapReady: (controller) {
                  //   _mapController = controller;
                  // }),
                  RouteCard(pageController: _pageController)
                ],
              ));
        }());
  }
}
