import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/providers/initalize.dart';
import 'package:knu_transport/utilities/text_size.dart';

class RouteMap extends ConsumerStatefulWidget {
  final void Function(NaverMapController)? onMapReady;
  final void Function(NaverMapController, int)? onStationClick;

  const RouteMap({super.key, this.onMapReady, this.onStationClick});

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
      target: NLatLng(37.8670061, 127.7437401),
      zoom: 14.5,
      bearing: 0,
      tilt: 0,
    );

    return SizedBox(
      width: mapSize.width,
      height: mapSize.height,
      child: NaverMap(
        options: const NaverMapViewOptions(
          initialCameraPosition: cameraPosition,
        ),
        onMapReady: mapOnReady,
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
      controller.addOverlay(
        NPathOverlay(
          id: "inner_bus_route",
          coords: routeInfo.map((x) => NLatLng(x[0], x[1])).toList()
        )
      );
    });

    // Draw a station to map.
    final stationInfo = ref.watch(dataStationInfoProvider);
    stationInfo.whenData((stationInfo) {
      const TextStyle style = TextStyle(color: Color(0xff000000), fontSize: 16);
      Map<int, StationInfo> refinedStation = {};
      for (StationInfo station in stationInfo) {
        if (!refinedStation.containsKey(station.id)) {
          refinedStation[station.id] = station;
        } else {
          StationInfo reversedStation = refinedStation[station.id]!;
          final stationPosition = NLatLng(
              (reversedStation.posX + station.posX) / 2,
              (reversedStation.posY + station.posY) / 2);

          // Station Overlay
          final stationOverlay = NCircleOverlay(
              id: "inner_bus_station_${station.id}",
              center: stationPosition,
              radius: 8,
              outlineWidth: 2);
          controller.addOverlay(stationOverlay);

          // Station Text Overlay
          final Widget stationTextWidget = Text(station.name, style: style);
          NOverlayImage.fromWidget(
                  widget: stationTextWidget,
                  size: NSize.fromSize(getTextSize(station.name, style)),
                  context: context)
              .then((NOverlayImage overlay) {
            var marker = NMarker(
                id: "inner_bus_station_${station.id}_${station.direction}_text",
                position: stationPosition.offsetByMeter(
                    northMeter: station.direction == 1 ? -12 : 12),
                icon: overlay);
            if (widget.onStationClick != null) {
              marker.setOnTapListener(
                  (_) => widget.onStationClick!(controller, station.id));
            }
            controller.addOverlay(marker);
          });

          if (reversedStation.name != station.name) {
            final Widget reversedStationTextWidget = Text(station.name, style: style);
            NOverlayImage.fromWidget(
                    widget: reversedStationTextWidget,
                    size: NSize.fromSize(getTextSize(station.name, style)),
                    context: context)
                .then((NOverlayImage overlay) {
              var marker = NMarker(
                  id: "inner_bus_station_${station.id}_${station.direction}_text",
                  position: stationPosition.offsetByMeter(
                      northMeter: station.direction == 1 ? -12 : 12),
                  icon: overlay);
              if (widget.onStationClick != null) {
                marker.setOnTapListener(
                    (_) => widget.onStationClick!(controller, station.id));
              }
              controller.addOverlay(marker);
            });
          }
        }
      }
    });
  }
}
