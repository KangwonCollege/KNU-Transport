import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_transport/models/timetable.dart';
import 'package:knu_transport/providers/initalize.dart';
import 'package:knu_transport/widgets/text_skeleton.dart';

class RouteCard extends ConsumerStatefulWidget {
  final CarouselSliderController pageController;
  final void Function(int index)? onPageChanged;

  const RouteCard({
    super.key,
    required this.pageController,
    this.onPageChanged
  });

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends ConsumerState<RouteCard> {
  bool skeleton = true;
  Timer? _timer;
  late TimeOfDay now;
  late int currentPage = 0;

  Widget titleText(String name) {
    const style = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xff000000),
    );
    if (skeleton) {
      return SkeletonText.fromText(text: name, style: style);
    }
    return Text(
      name,
      style: style,
    );
  }

  Widget subtitleText(String direction) {
    const style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xaa303030),
    );
    if (skeleton) {
      return SkeletonText.fromText(text: "${direction} 방향", style: style);
    }
    return Text(
      "${direction} 방향",
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  Widget description(String text) {
    const style = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xff585858),
    );
    return Container(
        alignment: Alignment.centerRight,
        child: skeleton
            ? SkeletonText.fromText(text: text, style: style)
            : Text(
                text,
                textAlign: TextAlign.end,
                style: style,
              ));
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    currentPage = 0;
    now = TimeOfDay.now();
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        now = TimeOfDay.now();
      });
    });
  }

  String timetableFormat(Timetable timetable, [TimeOfDay? now]) {
    now = now ?? TimeOfDay.now();
    int nowTotalMinute = now.hour * 60 + now.minute;
    int timetableTotalMinute = timetable.totalMinute();
    if (timetableTotalMinute - nowTotalMinute <= 1) {
      return "곧";
    } else if (timetableTotalMinute - nowTotalMinute <= 60) {
      return "${timetableTotalMinute - nowTotalMinute}분 후";
    } else {
      return "${(timetableTotalMinute - nowTotalMinute) ~/ 60} 시간 ${(timetableTotalMinute - nowTotalMinute) % 60}분 후";
    }
  }

  Widget item(BuildContext context, int index, int realIndex) {
    final timetable = ref.watch(dataTimetableProvider);
    final station = ref.watch(dataStationInfoProvider);

    if (index != -1 && widget.onPageChanged != null && currentPage != index) {
      widget.onPageChanged!(index);
    }
    currentPage = index;

    // title
    final name = station.value?[index].name ?? "새롬관(회차)";
    final direction = index + 2 < (station.value?.length ?? 0)
        ? "${station.value?[index + 1].name}, ${station.value?[index + 2].name}"
        : (index + 1 < (station.value?.length ?? 0)
            ? "${station.value?[index + 1].name}, ${station.value?[0].name}"
            : "${station.value?[0].name}");

    // description
    var currentTimetable = timetable.hasValue
        ? timetable.value![index]
            .where((element) => element.compareTo(now) >= 0)
            .toList()
        : List.empty();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              titleText(name),
              const SizedBox(width: 3),
              subtitleText(direction)
            ],
          ),
          const Spacer(flex: 1),
          currentTimetable.isNotEmpty
              ? description(
                  "${timetableFormat(currentTimetable[0])} (${currentTimetable[0].sessionIndex + 1}회차 버스) 출발 예정")
              : description("운행 종료"),
          currentTimetable.length > 1
              ? description(
                  "${timetableFormat(currentTimetable[1])} (${currentTimetable[1].sessionIndex + 1}회차 버스) 출발 예정")
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pageViewerSize = Size(mediaQuery.size.width, 200);
    final timetable = ref.watch(dataTimetableProvider);
    final station = ref.watch(dataStationInfoProvider);

    skeleton = !(station.hasValue && timetable.hasValue);

    return SizedBox(
        width: pageViewerSize.width,
        height: pageViewerSize.height,
        child: skeleton
            ? item(context, -1, -1)
            : CarouselSlider.builder(
                carouselController: widget.pageController,
                options: CarouselOptions(viewportFraction: 1.0),
                itemCount: station.value!.length,
                itemBuilder: item));
  }
}
