// Import directives
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Import packages
import '../../packages/timetable_view/timetable_view.dart';

// Utils
import 'package:uitmscheduler/utils/utils_main.dart';

// Provider
import 'package:uitmscheduler/providers/detail_providers.dart';

class Result extends HookConsumerWidget {
  const Result({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // declaring riverpod state providers
    final detailListState = ref.watch(detailListProvider);

    var setStartDay = UtilsMain.setStartDay(detailListState);
    final dayColumn = setStartDay.elementAt(0);
    final dayToCompare = setStartDay.elementAt(1);
    int startHour = 10;
    int endHour = 17;
    List<LaneEvents> laneEvents = [];
    List<Lane> lanes = [];
    final isFullScreen = useState(false);

    var safeWidth = UtilsMain.logicalPixelSafeArea().elementAt(0);

    // Create lane objects separately
    for (var i = 0; i < dayToCompare.length; i++) {
      lanes.add(Lane(
        name: dayColumn[i],
        // laneIndex: i,
      ));
    }

    // Create events array lists separately
    for (var i = 0; i < lanes.length; i++) {
      List<TableEvent> events = [];
      for (var j = 0; j < detailListState.length; j++) {
        var start = TableEventTime(
          hour: UtilsMain.getHourInt(detailListState[j].start), 
          minute: UtilsMain.getMinuteInt(detailListState[j].start)
        );
        var end = TableEventTime(
          hour: UtilsMain.getHourInt(detailListState[j].end), 
          minute: UtilsMain.getMinuteInt(detailListState[j].end)
        );

        if (start.hour < startHour) startHour = start.hour;

        if (end.hour > endHour) endHour = end.hour + 1;

        if (detailListState[j].day == dayToCompare[i]) {
            events.add(TableEvent(
              title: detailListState[j].course,
              body: detailListState[j].room,
              caption: detailListState[j].start,
              // eventId: k + 1,
              startTime: TableEventTime(hour: start.hour, minute: start.minute),
              endTime: TableEventTime(hour: end.hour, minute: end.minute),
              // laneIndex: i,
            ));
            // k++; // Increment eventId for each event
          }
      }
      laneEvents.add(LaneEvents(lane: lanes[i], events: events));
    }

    try {
      return Scaffold(
        appBar: isFullScreen.value
          ? null
          : AppBar(
            title: const Text("UiTM Scheduler"),
            backgroundColor: AppColor.lightPrimary,
        ),
        /// TODO: update this view
        body: SafeArea(
          child: Container(
            color: AppColor.lightBackground,
            child: TimetableView(
              laneEventsList: laneEvents,
              timetableStyle: TimetableStyle(
                /// responsive layout while providing little padding at the end
                laneWidth: (safeWidth - 70) / 5,
                startHour: startHour,
                endHour: endHour,
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              tooltip: "Full screen",
              heroTag: "fullscreen",
              backgroundColor: AppColor.lightPrimary,
              child: isFullScreen.value 
                ? const Icon(Icons.fullscreen_exit) 
                : const Icon(Icons.fullscreen),
              onPressed: () => isFullScreen.value = !isFullScreen.value
            )
          ]
        )
      );
    }
    catch (e) {
      throw e;
    }
  }

  // void onEventTapCallBack(TableEvent event) {
  //   print("Event Clicked!! LaneIndex ${event.laneIndex} Title: ${event.title} StartHour: ${event.startTime.hour} EndHour: ${event.endTime.hour}");
  // }

  // void onTimeSlotTappedCallBack(
  //     int laneIndex, TableEventTime start, TableEventTime end) {
  //   print("Empty Slot Clicked !! LaneIndex: $laneIndex StartHour: ${start.hour} EndHour: ${end.hour}");
  // }
}
