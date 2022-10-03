// Import directives
// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../timetable_view.dart';

// Provider
import 'package:uitmscheduler/providers/detail_providers.dart';

class Result extends ConsumerWidget {
  const Result({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // declaring riverpod state providers
    final detailListState = ref.watch(detailListProvider);
    bool clashed = false;

    try {
      for (var i=0; i<detailListState.length; i++) {
        for (var j=i+1; j<detailListState.length; j++) {
          if(detailListState[i].day == detailListState[j].day) {
            if(detailListState[i].end > detailListState[j].start && detailListState[i].start < detailListState[j].end) {
            	// print(detailListState[i].course + "(" + detailListState[i].start.toString() + "-" + detailListState[i].end.toString() + ")" + " clashed with " + detailListState[j].course + "(" + detailListState[j].start.toString() + "-" + detailListState[j].end.toString() + ")");
              clashed = true;
              return Scaffold(
                appBar: AppBar(
                  title: const Text("UiTM Scheduler"),
                ),
                body: Text("${detailListState[i].course}(${detailListState[i].start}-${detailListState[i].end}) clashed with ${detailListState[j].course}(${detailListState[j].start}-${detailListState[j].end})")
              );
            }
          }
        }
      }

      return Scaffold(
        appBar: AppBar(
          title: Text("Timetable"),
        ),
        body: TimetableView(
          laneEventsList: _buildLaneEvents(detailListState),
          onEventTap: onEventTapCallBack,
          timetableStyle: const TimetableStyle(),
          onEmptySlotTap: onTimeSlotTappedCallBack,
        ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              tooltip: "Add course",
              heroTag: "add",
              backgroundColor: Colors.lightBlue,
              child: const Icon(Icons.add),
              onPressed: () {},
            ),
    
            SizedBox(height: 16),
    
            FloatingActionButton(
              tooltip: "Fetch Details",
              heroTag: "fetch",
              backgroundColor: Colors.lightBlue,
              child: const Icon(Icons.find_in_page),
              onPressed: () async {},
            ),

            SizedBox(height: 16),

            FloatingActionButton(
              tooltip: "Debug that shown in Snackbar",
              heroTag: "snack",
              backgroundColor: Colors.lightBlue,
              child: const Icon(Icons.miscellaneous_services),
              onPressed: () async {},
            ),
          ],
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
              startTime: TableEventTime(hour: detailsList[j].start, minute: 0),
              endTime: TableEventTime(hour: detailsList[j].end, minute: 0),
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
