import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/providers/initalize.dart';
import 'package:knu_transport/utilities/text_size.dart';

class RouteMap extends ConsumerStatefulWidget {
  final void Function(NaverMapController)? onMapReady;
  final void Function(NaverMapController, int)? onStationClick;
  final Widget? floatingButton;

  const RouteMap(
      {super.key, this.onMapReady, this.onStationClick, this.floatingButton});

  @override
  _RouteMapState createState() => _RouteMapState();
}

class _RouteMapState extends ConsumerState<RouteMap> {
  late NaverMapController controller;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mapSize = Size(mediaQuery.size.width, mediaQuery.size.height - 200);
    const cameraPosition = NCameraPosition(
      target: NLatLng(37.867769, 127.744840),
      zoom: 14.5,
      bearing: 0,
      tilt: 0,
    );

    return SizedBox(
      width: mapSize.width,
      height: mapSize.height,
      child: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(
            initialCameraPosition: cameraPosition,
          ),
          onMapReady: mapOnReady,
        ),
        floatingActionButton: widget.floatingButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void mapOnReady(NaverMapController controller) {
    this.controller = controller;
    if (widget.onMapReady != null) {
      widget.onMapReady!(controller);
    }

    // Draw a bus route to map.
    final routeInfo = ref.watch(dataRouteInfoProvider);
    routeInfo.whenData((routeInfo) {
      controller.addOverlay(NPathOverlay(
          id: "inner_bus_route",
          coords: routeInfo.map((x) => NLatLng(x[0], x[1])).toList(),
          outlineWidth: 0,
          color: const Color(0xffaab9ff)));
    });

    // Draw a station to map.
    final stationInfo = ref.watch(dataStationInfoProvider);
    stationInfo.whenData((stationInfo) {
      const TextStyle style = TextStyle(color: Color(0xff000000), fontSize: 16);
      Map<int, StationInfo> refinedStation = {};
      for (StationInfo station in stationInfo) {
        if (refinedStation.containsKey(station.id)) {
          StationInfo reversedStation = refinedStation[station.id]!;
          NLatLng position = NLatLng((station.posX + reversedStation.posX) / 2,
              (station.posY + reversedStation.posY) / 2);

          StationInfo stationD0 =
              station.direction == 0 ? station : reversedStation;
          StationInfo stationD1 =
              station.direction == 1 ? station : reversedStation;

          final stationOverlay = NCircleOverlay(
              id: "inner_bus_station_${station.id}",
              center: position,
              radius: 8,
              outlineWidth: 2);
          stationOverlay.setGlobalZIndex(-9999);
          if (widget.onStationClick != null) {
            stationOverlay.setOnTapListener((_) => widget.onStationClick!(controller, station.id));
          }
          controller.addOverlay(stationOverlay);

          addTextOverlay(
            controller: controller,
            id: "inner_bus_station_${stationD0.id}_${stationD0.direction}_text",
            text: stationD0.name,
            style: style,
            position: position.offsetByMeter(northMeter: 15),
          );
          if (reversedStation.name != station.name) {
            addTextOverlay(
              controller: controller,
              id: "inner_bus_station_${stationD1.id}_${stationD1.direction}_text",
              text: stationD1.name,
              style: style,
              position: position.offsetByMeter(northMeter: 15),
            );
          }
        } else {
          refinedStation[station.id] = station;
        }
      }
    });
  }

  void addTextOverlay(
      {required NaverMapController controller,
      required String id,
      required String text,
      required TextStyle style,
      required NLatLng position,
      dynamic Function(NMarker)? onClick}) {
    final Widget textWidget = Text(text, style: style);
    NOverlayImage.fromWidget(
            widget: textWidget,
            size: NSize.fromSize(getTextSize(text, style)),
            context: context)
        .then((NOverlayImage overlay) {
      var marker = NMarker(id: id, position: position, icon: overlay);
      if (onClick != null) {
        marker.setOnTapListener(onClick);
      }
      controller.addOverlay(marker);
    });
  }
}
