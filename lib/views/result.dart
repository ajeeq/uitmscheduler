// Import directives
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

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
var paddingTop = window.padding.top / window.devicePixelRatio;
var paddingBottom = window.padding.bottom / window.devicePixelRatio;

//Safe area in logical pixels
var safeWidth = logicalWidth - paddingLeft - paddingRight;
var safeHeight = logicalWidth - paddingTop - paddingBottom;

class Result extends ConsumerWidget {
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
        appBar: AppBar(
          title: const Text("UiTM Scheduler"),
          backgroundColor: AppColor.lightPrimary,
        ),
        /// TODO: update this view
        body: Container(
          color: AppColor.lightBackground,
          child: TimetableView(
            // laneEventsList: _buildLaneEvents(detailListState),
            // onEventTap: onEventTapCallBack,
            // timetableStyle: TimetableStyle(
            //   laneWidth: (safeWidth - 70) / 5
            // ),
            // onEmptySlotTap: onTimeSlotTappedCallBack,
        
            // laneEventsList: _buildLaneEvents(detailListState),
            laneEventsList: laneEvents,
            timetableStyle: TimetableStyle(
              // timeItemWidth: 40,
              laneHeight: 35,
              // timeItemHeight: 100,
              // responsive layout while providing little padding at the end
              laneWidth: (safeWidth - 70) / 5,
              startHour: startHour,
              endHour: endHour,
            ),
          ),
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

    int startHour = 10;
    int endHour = 17;

    // var lanes = dayColumn.map((day) {
    //   return Lane(
    //     name: day
    //   );
    // });

    // Create lane objects separately
    List<Lane> lanes = [];
    for (var i = 0; i < dayToCompare.length; i++) {
      lanes.add(Lane(
        name: dayColumn[i],
        // laneIndex: i,
      ));
    }
    

    // List<TableEvent> tableEvents = detailsList.map((e) {
      // var start = TableEventTime(
      //   hour: UtilsMain.getHourInt(e.start), 
      //   minute: UtilsMain.getMinuteInt(e.start)
      // );
      // var end = TableEventTime(
      //   hour: UtilsMain.getHourInt(e.end), 
      //   minute: UtilsMain.getHourInt(e.end)
      // );

      // if (start.hour < startHour) startHour = start.hour;
      // // print(start.hour);

      // if (end.hour > endHour) endHour = end.hour + 1;
      // // print(end.hour);

      
    //   return TableEvent(
    //     title: e.course,
    //     body: e.room,
    //     caption: e.start,
    //     startTime: TableEventTime(hour: start.hour, minute: start.minute),
    //     endTime: TableEventTime(hour: end.hour, minute: end.minute),
    //   );
    // });

      // Create events array lists separately
      List<LaneEvents> laneEvents = [];
      for (var i = 0; i < lanes.length; i++) {
        List<TableEvent> events = [];
        for (var j = 0; j < detailsList.length; j++) {
          var start = TableEventTime(
            hour: UtilsMain.getHourInt(detailsList[j].start), 
            minute: UtilsMain.getMinuteInt(detailsList[j].start)
          );
          var end = TableEventTime(
            hour: UtilsMain.getHourInt(detailsList[j].end), 
            minute: UtilsMain.getMinuteInt(detailsList[j].end)
          );

          // if (start.hour < startHour) startHour = start.hour;
          // print("start hour: ${start.hour}");

          // if (end.hour > endHour) endHour = end.hour + 1;
          // print("end hour: ${end.hour}");

          if (detailsList[j].day == dayToCompare[i]) {
            events.add(TableEvent(
              title: detailsList[j].course,
              // eventId: k + 1,
              startTime: TableEventTime(hour: start.hour, minute: start.minute),
              endTime: TableEventTime(hour: end.hour, minute: end.minute),
              // laneIndex: i,
            ));
            k++; // Increment eventId for each event
          }
        }

        laneEvents.add(LaneEvents(lane: lanes[i], events: events));
      }

    // return [
    //   for (var i=0; i<dayToCompare.length; i++) LaneEvents(
    //     lane: Lane(
    //       name: dayColumn[i],
    //       // laneIndex: i,
    //     ),
    //     events: 
    //     // [
    //     //   for (var j=0; j<detailsList.length; j++)
    //     //     if(detailsList[j].day == dayToCompare[i]) TableEvent(
    //     //       // title: detailsList[j].course,
    //     //       // body: detailsList[j].room,
    //     //       // caption: detailsList[j].start,
    //     //       // eventId: k+1,
    //     //       // startTime: TableEventTime(hour: UtilsMain.getHourInt(detailsList[j].start), minute: UtilsMain.getMinuteInt(detailsList[j].start)),
    //     //       // endTime: TableEventTime(hour: UtilsMain.getHourInt(detailsList[j].end), minute: UtilsMain.getHourInt(detailsList[j].end)),
    //     //       // laneIndex: i,

    //     //       title: detailsList[j].course,
    //     //       body: detailsList[j].room,
    //     //       caption: detailsList[j].start,
    //     //       startTime: TableEventTime(hour: start.hour, minute: start.minute),
    //     //       endTime: TableEventTime(hour: end.hour, minute: end.minute),
              
    //     //     )
    //     // ],
    //   ),
    // ];

    return laneEvents;

  }

  void onEventTapCallBack(TableEvent event) {
    // print("Event Clicked!! LaneIndex ${event.laneIndex} Title: ${event.title} StartHour: ${event.startTime.hour} EndHour: ${event.endTime.hour}");
  }

  void onTimeSlotTappedCallBack(
      int laneIndex, TableEventTime start, TableEventTime end) {
    // print("Empty Slot Clicked !! LaneIndex: $laneIndex StartHour: ${start.hour} EndHour: ${end.hour}");
  }
}
