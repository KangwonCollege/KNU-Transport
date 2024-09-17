import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/utilities/load_asset.dart';

class InnerBusPage extends StatefulWidget {
  const InnerBusPage({super.key});

  @override
  _InnerBusPageState createState() => _InnerBusPageState();
}

class _InnerBusPageState extends State<InnerBusPage> {
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  late PageController _pageController;
  late TabController _tabController;
  late NaverMapController _mapController;

  late var initalizeConfiguration =
      Future.wait([loadStationInfo(), loadRouteInfo()]);
  late List<StationInfo> stationInfo;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pageSize = Size(mediaQuery.size.width, mediaQuery.size.height);
    final pageViewerSize = Size(mediaQuery.size.width, 200);
    final mapSize = Size(mediaQuery.size.width, mediaQuery.size.height - 200);

    // Map Options
    const cameraPosition = NCameraPosition(
      target: NLatLng(37.8670061, 127.7437401),
      zoom: 14.5,
      bearing: 0,
      tilt: 0,
    );

    initalizeConfiguration.then((result) {
      setState(() {
        stationInfo = result[0] as List<StationInfo>;
      });
    });

    return Scaffold(
        backgroundColor: Color(0xffefefff),
        body: () {
          if (stationInfo.isEmpty) return const CircularProgressIndicator();

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
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        stationInfo[index].name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      index <= stationInfo.length - 2
                                          ? Text(
                                              "${stationInfo[index + 1].name} 방향",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xaa303030),
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),

                                  Container(
                                      alignment: Alignment.centerRight,
                                      child: const Text(
                                          "HH:MM 후 (N회차 버스) 도착 예정",
                                          textAlign: TextAlign.end))

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
    loadRouteInfo().then((routeInfo) {
      controller.addOverlay(NPathOverlay(
          id: "inner_bus_route",
          coords: routeInfo.map((x) => NLatLng(x[0], x[1])).toList()));
    });

    // final circleOverlay = NCircleOverlay(id: "test", center: NLatLng(37.86552754326239, 127.74261278090911), radius: 20);
    // circleOverlay.setOnTapListener((NCircleOverlay overlay) {
    //   final infoWindow = NInfoWindow.onMap(id: "test", position: NLatLng(37.86552754326239, 127.74261278090911), text: "인포윈도우 텍스트");
    //   controller.addOverlay(infoWindow);
    // });
    // controller.addOverlay(circleOverlay);

    const Widget text =
        Text("테스트", style: TextStyle(color: Color(0xff000000), fontSize: 20));
    NOverlayImage.fromWidget(
            widget: text,
            size: NSize.fromSize(_textSize(
                "테스트", TextStyle(color: Color(0xff000000), fontSize: 20))),
            context: context)
        .then((NOverlayImage result) {
      var marker = NMarker(
          id: "icon_test",
          position: const NLatLng(37.86552754326239, 127.74261278090911),
          icon: result);
      controller.addOverlay(marker);
    });
  }

  Future<List<StationInfo>> loadStationInfo() async {
    List<StationInfo> station = await loadAssets(
        "assets/data/inner_bus/station_info.json", StationInfo.fromJson);
    return station;
  }

  Future<List<List<double>>> loadRouteInfo() async {
    List<List<double>> routeInfo =
        await loadJson("assets/data/inner_bus/routeInfo.json");
    return routeInfo;
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
