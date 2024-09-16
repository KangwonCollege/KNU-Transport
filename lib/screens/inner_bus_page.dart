import 'dart:async';
import 'package:flutter/material.dart';
import 'package:knu_transport/components/inner_bus_map.dart';
import 'package:knu_transport/components/inner_bus_arrival.dart';
import 'package:knu_transport/models/initalization.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/utilities/load_asset.dart';

class InnerBusPage extends StatefulWidget {
  const InnerBusPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InnerBusPageState();
  }
}

class _InnerBusPageState extends State<InnerBusPage> {
  Future<List<StationInfo>> loadStationInfo() async {
    List<StationInfo> station = await loadAssets(
        "assets/data/inner_bus/station_info.json", StationInfo.fromJson);
    return station;
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Text(
          "교내 순환버스",
          style: TextStyle(
              color: Color(0xff000000), decoration: TextDecoration.none),
          textAlign: TextAlign.start,
        ),
        FutureBuilder(
          future: Future.wait([this.loadStationInfo]),
          builder: (BuildContext context, AsyncSnapshot<List<List<StationInfo>> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return Column(
              children: [
                InnerBusMap(), // 지도
                InnerBusArrival(
                    stations: (snapshot.data as Initalization).stations)
              ],
            );
          },
        )
      ],
    );
  }
}
