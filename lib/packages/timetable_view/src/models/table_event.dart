import 'package:flutter/material.dart';
import 'package:uitmscheduler/packages/timetable_view/src/models/table_event_time.dart';
import 'package:uitmscheduler/constants/colors.dart';

class TableEvent {
  /// course code. eg: STA577
  final String title;

  /// room. eg: BK1-01
  final String? body;

  /// start time and end time. eg: 10.00-12.00
  final String? caption;

  /// Id to uniquely identify event. Used mainly in callbacks
  // final int eventId;

  /// Id to uniquely identify the lane an event falls under. Used mainly in callbacks
  // final int laneIndex;

  /// Optional. Preferably abbreviate string to less than 5 characters
  // final String location;

  final TableEventTime startTime;

  final TableEventTime endTime;

  final EdgeInsets padding;

  final EdgeInsets? margin;

  // //Todo:: Determine if Event ID needs to be passed to callback
  // final void Function(
  //         int laneIndex, String title, TableEventTime start, TableEventTime end)
  //     onTap;
  final VoidCallback? onTap;

  final BoxDecoration? decoration;

  final Color backgroundColor;

  final TextStyle textStyle;

  TableEvent({
    required this.title,
    this.body,
    this.caption,
    // required this.eventId,
    // required this.laneIndex,
    // this.location = '',
    required this.startTime,
    required this.endTime,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.all(1),
    this.onTap,
    this.decoration,
    this.backgroundColor = AppColor.lightPrimary,
    this.textStyle = const TextStyle(color: Colors.white),
  }) : assert(endTime.isAfter(startTime));
}
