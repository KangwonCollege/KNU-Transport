import 'dart:async';
import 'package:flutter/material.dart';
import 'package:knu_transport/components/inner_bus_map.dart';
import 'package:knu_transport/components/inner_bus_arrival.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          "교내 순환버스",
          style: TextStyle(
              color: Color(0xff000000), decoration: TextDecoration.none),
          textAlign: TextAlign.start,
        ),
        FutureBuilder<List<List<StationInfo>>>(
          future: Future.wait([loadStationInfo()]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return Column(
              children: [
                const InnerBusMap(), // 지도
                InnerBusArrival(
                  stations: (snapshot.data[0]),
                  controller: _pageController,
                )
              ],
            );
          },
        )
      ],
    );
  }

  Future<List<StationInfo>> loadStationInfo() async {
    List<StationInfo> station = await loadAssets(
        "assets/data/inner_bus/station_info.json", StationInfo.fromJson);
    return station;
  }
}
