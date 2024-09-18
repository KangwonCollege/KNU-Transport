import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/providers/initalize.dart';
import 'package:knu_transport/utilities/load_asset.dart';

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

    final station = ref.watch(dataStationInfoProvider);

    // PageView Component
    final pageViewerSize = Size(mediaQuery.size.width, 200);
    final nowTime = DateTime.now();

    // final timetable = ref.watch()

    return Scaffold(
        backgroundColor: Color(0xffefefff),
        body: () {
          if (!station.hasValue || station.value == null)
            return const CircularProgressIndicator();
          var stationInfo = station.value!;
          // _tabController = TabController(length: stations.length, vsync: vsync)

          return SizedBox(
              width: pageSize.width,
              height: pageSize.height,
              child: Column(
                children: [
                  SizedBox(
                    width: mapSize.width,
                    height: mapSize.height,
                    child: NaverMap(
                      options: NaverMapViewOptions(
                        initialCameraPosition: cameraPosition,
                      ),
                      onMapReady: mapOnReady,
                    ),
                  ),
                  SizedBox(
                      width: pageViewerSize.width,
                      height: pageViewerSize.height,
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: stationInfo.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        stationInfo[index].name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      index <= stationInfo.length - 2
                                          ? Text(
                                              "${stationInfo[index + 1].name} 방향",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xaa303030),
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                  const Spacer(flex: 1),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: const Text(
                                          "HH:MM 후 (N회차 버스) 도착 예정",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff1a1a1a),
                                          ),
                                        )
                                      )

                                  // HH:MM 분후 (N회차 버스) 도착 예정
                                  // [버튼] 역방향 정류장 표시
                                ],
                              ),
                            );
                          }))
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
            _textSize(station.name, style)  
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

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
