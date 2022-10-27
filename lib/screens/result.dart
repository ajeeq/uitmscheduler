// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../timetable_view.dart';

// Utils
import 'package:uitmscheduler/utils/utils_main.dart';

// Provider
import 'package:uitmscheduler/providers/detail_providers.dart';

class Result extends ConsumerWidget {
  const Result({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // declaring riverpod state providers
    final detailListState = ref.watch(detailListProvider);

    try {
      return Scaffold(
        appBar: AppBar(
          title: const Text("UiTM Scheduler"),
        ),
        body: TimetableView(
          laneEventsList: _buildLaneEvents(detailListState),
          onEventTap: onEventTapCallBack,
          timetableStyle: const TimetableStyle(),
          onEmptySlotTap: onTimeSlotTappedCallBack,
        ),
      );
    }
    catch (e) {
      throw e;
    }
  }

  List<LaneEvents> _buildLaneEvents(detailsList) {
    final dates = {
      "mon": <String>['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'],
      "sun": <String>['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY'],
    };

    int k = 10;

    return [
      for (var i=0; i<dates["mon"]!.length; i++) LaneEvents(
        lane: Lane(name: dates["mon"]![i], laneIndex: i),
        events: [
          for (var j=0; j<detailsList.length; j++)
            if(detailsList[j].day == dates["mon"]![i]) TableEvent(
              title: detailsList[j].course,
              eventId: k+1,
              startTime: TableEventTime(hour: UtilsMain.getHourInt(detailsList[j].start), minute: UtilsMain.getMinuteInt(detailsList[j].start)),
              endTime: TableEventTime(hour: UtilsMain.getHourInt(detailsList[j].end), minute: UtilsMain.getHourInt(detailsList[j].end)),
              laneIndex: i,
            )
        ],
      ),
    ];
  }

  void onEventTapCallBack(TableEvent event) {
    // print("Event Clicked!! LaneIndex ${event.laneIndex} Title: ${event.title} StartHour: ${event.startTime.hour} EndHour: ${event.endTime.hour}");
  }

  void onTimeSlotTappedCallBack(
      int laneIndex, TableEventTime start, TableEventTime end) {
    // print("Empty Slot Clicked !! LaneIndex: $laneIndex StartHour: ${start.hour} EndHour: ${end.hour}");
  }
}
