import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knu_transport/models/station_info.dart';
import 'package:knu_transport/providers/initalize.dart';
import 'package:knu_transport/widgets/text_skeleton.dart';


class RouteCard extends ConsumerStatefulWidget {
  final PageController pageController;

  const RouteCard({super.key, required this.pageController});

  @override
  _RouteCardState createState() => _RouteCardState();
}

class _RouteCardState extends ConsumerState<RouteCard> {
  bool skeleton = true;

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
      style: style,
    );
  }

  Widget description(String text) {
    const style = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xff1a1a1a),
    );
    return Container(
      alignment: Alignment.centerRight,
      child: skeleton ? 
        SkeletonText.fromText(text: text, style: style) : 
        Text(
          // "${currentTimetable[0].hour}:${currentTimetable[0].minute} 후 (${currentTimetable[0].sessionIndex}회차 버스) 출발 예정",
          text,
          textAlign: TextAlign.end,
          style: style,
        )
      );
  }

  Widget item(BuildContext context, int index) {
    final timetable = ref.watch(dataTimetableProvider);
    final station = ref.watch(dataStationInfoProvider);

    // title
    final name = station.value?[index].name ?? "새롬관(회차)";
    final direction = index + 2 < (station.value?.length ?? 0) ?
      "${station.value?[index + 1].name}, ${station.value?[index + 2].name}" : (
        index + 1 < (station.value?.length ?? 0) ? 
        station.value![index + 1].name : 
        null
      );

    // description
    TimeOfDay now = TimeOfDay.now();
    var currentTimetable = timetable.hasValue ?
     timetable.value![index].where((element) => element.compareTo(now) >= 0).toList() : 
     List.empty();
    


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
              direction != null ? subtitleText(direction) : const SizedBox.shrink()
            ],
          ),
          const Spacer(flex: 1),
          currentTimetable.isNotEmpty ? description("${currentTimetable[0].format(context)} 후 (${currentTimetable[0].sessionIndex}회차 버스) 출발 예정") : description("운행 종료"),
          currentTimetable.length > 1 ? description("${currentTimetable[1].format(context)} 후 (${currentTimetable[1].sessionIndex}회차 버스) 출발 예정") : const SizedBox.shrink(),
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
  
    return 
      SizedBox(
        width: pageViewerSize.width,
        height: pageViewerSize.height,
        child: skeleton
           ? item(context, -1)
           : PageView.builder(
              controller: widget.pageController,
              itemCount: station.value!.length,
              itemBuilder: item
            )
      );
  }
}
 