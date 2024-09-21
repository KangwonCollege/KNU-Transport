import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
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
    _pageController = CarouselSliderController();
  }

  late CarouselSliderController _pageController;
  late TabController _tabController;
  late NaverMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pageSize = Size(mediaQuery.size.width, mediaQuery.size.height);

    final routeInfo = ref.watch(dataRouteInfoProvider);

    return Scaffold(
        backgroundColor: Color(0xffefefff),
        body: SizedBox(
              width: pageSize.width,
              height: pageSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RouteMap(onMapReady: (controller) {
                    _mapController = controller;
                  }, floatingButton: Stack(
                    children: [
                      Align(
                        alignment: Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y - 0.4),
                        child: FloatingActionButton.small(
                          onPressed: () {},
                          child: const Icon(
                            Icons.refresh,
                            size: 30,
                          )
                        ),
                      ), Align(
                        alignment: Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y - 0.2),
                        child: FloatingActionButton.small(
                          onPressed: () {},
                          child: const Icon(
                            Icons.location_on,
                            size: 30,
                          )
                        ),
                      ), Align(
                        alignment: Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y),
                        child: FloatingActionButton.small(
                          onPressed: () {},
                          child: const Icon(
                            Icons.location_on,
                            size: 30,
                          )
                        ),
                      ),
                    ],
                  )),
                  RouteCard(pageController: _pageController)
                ],
              )
        )
    );
  }
}
