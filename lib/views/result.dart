// Import directives
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import packages
import '../../packages/timetable_view/timetable_view.dart';

// Utils
import 'package:uitmscheduler/utils/utils_main.dart';

// Provider
import 'package:uitmscheduler/providers/detail_providers.dart';

var pixelRatio = window.devicePixelRatio;

//Size in logical pixels
var logicalScreenSize = window.physicalSize / pixelRatio;
var logicalWidth = logicalScreenSize.width;

//Padding in physical pixels
var padding = window.padding;

//Safe area paddings in logical pixels
var paddingLeft = window.padding.left / window.devicePixelRatio;
var paddingRight = window.padding.right / window.devicePixelRatio;

//Safe area in logical pixels
var safeWidth = logicalWidth - paddingLeft - paddingRight;

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
          timetableStyle: TimetableStyle(
            laneWidth: (safeWidth - 70) / 5
          ),
          onEmptySlotTap: onTimeSlotTappedCallBack,
        ),
      );
    }
    catch (e) {
      throw e;
    }
  }

  List<LaneEvents> _buildLaneEvents(detailsList) {
    var setStartDay = UtilsMain.setStartDay(detailsList);
    final dayColumn = setStartDay.elementAt(0);
    final dayToCompare = setStartDay.elementAt(1);

    int k = 10;

    return [
      for (var i=0; i<dayToCompare.length; i++) LaneEvents(
        lane: Lane(
          name: dayColumn[i],
          laneIndex: i,
        ),
        events: [
          for (var j=0; j<detailsList.length; j++)
            if(detailsList[j].day == dayToCompare[i]) TableEvent(
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
