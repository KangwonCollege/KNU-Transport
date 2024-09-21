import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:knu_transport/providers/initalize.dart';
import 'package:knu_transport/widgets/inner_bus/route_card.dart';
import 'package:knu_transport/widgets/inner_bus/route_map.dart';
import 'package:knu_transport/widgets/multi_floating_button.dart';

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
                RouteMap(
                  onMapReady: (controller) {
                    _mapController = controller;
                  },
                  floatingButton: MultiFloatingButton(
                    icon: const [Icons.navigation, Icons.my_location],
                      onClickListener: (index) {
                        if (index == 0) followStationEvent();
                        if (index == 1) getLocationEvnet();
                      })),
                RouteCard(pageController: _pageController)
              ],
            )));
  }

  void getLocationEvnet() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Fluttertoast.showToast(
        msg: "위치 설정을 확인해주세요."
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Fluttertoast.showToast(
          msg: "위치 권한을 허용해주세요."
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Fluttertoast.showToast(
        msg: "설정에서 애플리케이션의 위치 권한을 허용해주세요."
      );
      return;
    }
    print(permission);

    Position position = await Geolocator.getCurrentPosition();
    await Fluttertoast.showToast(
      msg: "${position.latitude} ${position.longitude}"
    );
  }

  void followStationEvent() {

  }
}
