import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/providers/initalize.dart';
import 'package:knu_transport/utilities/load_asset.dart';
import 'package:knu_transport/utilities/text_size.dart';
import 'package:knu_transport/widgets/inner_bus/route_card.dart';

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

    // Map Component
    final mapSize = Size(mediaQuery.size.width, mediaQuery.size.height - 200);
    const cameraPosition = NCameraPosition(
      target: NLatLng(37.8670061, 127.7437401),
      zoom: 14.5,
      bearing: 0,
      tilt: 0,
    );

    return Scaffold(
        backgroundColor: Color(0xffefefff),
        body: () {
          // _tabController = TabController(length: stations.length, vsync: vsync)

          return SizedBox(
              width: pageSize.width,
              height: pageSize.height,
              child: Column(
                children: [
                  // SizedBox(
                  //   width: mapSize.width,
                  //   height: mapSize.height,
                  //   child: NaverMap(
                  //     options: NaverMapViewOptions(
                  //       initialCameraPosition: cameraPosition,
                  //     ),
                  //     onMapReady: mapOnReady,
                  //   ),
                  // ),
                  RouteCard(pageController: _pageController)
                ],
              ));
        }());
  }

  void mapOnReady(NaverMapController controller) {
    _mapController = controller;

    // Draw a bus route to map.
    final routeInfo = ref.watch(dataRouteInfoProvider);
    routeInfo.whenData((routeInfo) {
      controller.addOverlay(NPathOverlay(
          id: "inner_bus_route",
          coords: routeInfo.map((x) => NLatLng(x[0], x[1])).toList()));
    });

    // Draw a station to map.
    final stationInfo = ref.watch(dataStationInfoProvider);
    stationInfo.whenData((stationInfo) {
      for (StationInfo station in stationInfo) {
        // if (station.direction == 1) continue;
        final stationPosition = NLatLng(station.posX, station.posY);
        final stationOverlay = NCircleOverlay(
          id: "inner_bus_station_${station.id}",
          center: stationPosition,
          radius: 10
        );

        const TextStyle style = TextStyle(
            color: Color(0xff000000),
            fontSize: 16
        );
        final Widget stationTextWidget = Text(
          station.name,
          style: style
        );
        NOverlayImage.fromWidget(
          widget: stationTextWidget,
          size: NSize.fromSize(
            getTextSize(station.name, style)  
          ),
          context: context
        ).then((NOverlayImage overlay) {
          var marker = NMarker(
            id: "inner_bus_station_${station.id}_text",
            position: stationPosition.offsetByMeter(northMeter:-10),
            icon: overlay
          );
          controller.addOverlay(marker);
        });
        controller.addOverlay(stationOverlay);
      }
    });
  }
}
