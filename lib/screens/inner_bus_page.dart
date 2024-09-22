import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:knu_transport/models/station_info.dart';
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
    currentPage = 0;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => getLocationEvnet(true)
    );
  }

  late CarouselSliderController _pageController;
  late int currentPage;
  late NaverMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pageSize = Size(mediaQuery.size.width, mediaQuery.size.height);

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
                  onStationClick: onStationOverlayClick,
                  floatingButton: MultiFloatingButton(
                    icon: const [Icons.navigation, Icons.my_location],
                      onClickListener: (index) {
                        if (index == 0) followStationEvent();
                        if (index == 1) getLocationEvnet();
                      })),
                RouteCard(
                  pageController: _pageController,
                  onPageChanged: (index) => currentPage = index,
                )
              ],
            )));
  }

  void onStationOverlayClick(NaverMapController controller, int stationId) {
    var stationInfo = ref.watch(dataStationInfoProvider);
    stationInfo.whenData((data) {
      int currentDirection = data[currentPage].direction;
      StationInfo station = data.where((e) => e.direction == currentDirection && e.id == stationId).first;
      int newIndex = data.indexOf(station);
      _pageController.animateToPage(newIndex);
    });
  }

  void getLocationEvnet([bool initalize = false]) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (initalize) {
        await Fluttertoast.showToast(
          msg: "위치 설정을 확인해주세요."
        );
      }
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
      if (initalize) {
        await Fluttertoast.showToast(
          msg: "설정에서 애플리케이션의 위치 권한을 허용해주세요."
        );
      }
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    var stationInfo = ref.watch(dataStationInfoProvider);
    stationInfo.whenData((List<StationInfo> info) {
      var newStationinfo = List<StationInfo>.from(info);
      newStationinfo.sort((a, b) {
        double p1 = Geolocator.distanceBetween(a.posX, a.posY, position.latitude, position.longitude);
        double p2 = Geolocator.distanceBetween(b.posX, b.posY, position.latitude, position.longitude);
        return p1.compareTo(p2);
      });

      int index = info.indexOf(newStationinfo[0]);
      _pageController.animateToPage(index);
    });
  }

  void followStationEvent() {
    var stationInfo = ref.watch(dataStationInfoProvider);
    stationInfo.whenData((List<StationInfo> info) {
      var cameraPosition = NCameraUpdate.withParams(
        target: NLatLng(info[currentPage].posX, info[currentPage].posY),
        zoom: 16
      );
      cameraPosition.setAnimation(
        animation: NCameraAnimation.easing,
        duration: const Duration(seconds: 2)
      );  
      _mapController.updateCamera(cameraPosition);
    });
  }
}
