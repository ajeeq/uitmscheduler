import 'package:flutter/material.dart';
import 'package:uitmscheduler/constants/colors.dart';

class TimetableStyle {
  final int startHour;

  final int endHour;

  final Color laneColor;

  final Color cornerColor;

  final Color timeItemTextColor;

  final Color timelineColor;

  final Color timelineItemColor;

  final Color mainBackgroundColor;

  final Color timelineBorderColor;

  final Color decorationLineBorderColor;

  final double laneWidth;

  final double laneHeight;

  final double timeItemHeight;

  final double timeItemWidth;

  final double decorationLineHeight;

  final double decorationLineDashWidth;

  final double decorationLineDashSpaceWidth;

  final bool visibleTimeBorder;

  final bool visibleDecorationBorder;

  final Alignment timeItemAlignment; // Aligns timeItem

  /// If the time should be displayed as 24 hours or 12 hour (Am & PM)
  final bool showTimeAsAMPM;

  const TimetableStyle(
      {this.startHour: 0,
      this.endHour: 24,
      this.laneColor: AppColor.lightBackground,
      this.cornerColor: AppColor.lightBackground,
      this.timelineColor: AppColor.lightBackground,
      this.timelineItemColor: AppColor.lightBackground,
      this.mainBackgroundColor: AppColor.lightBackground,
      this.decorationLineBorderColor: const Color(0x1A000000),
      this.timelineBorderColor: const Color(0x1A000000),
      this.timeItemTextColor: AppColor.lightPrimary,
      this.laneWidth: 300,
      this.laneHeight: 35,
      this.timeItemHeight: 75,
      this.timeItemWidth: 70,
      this.decorationLineHeight: 20,
      this.decorationLineDashWidth: 9,
      this.decorationLineDashSpaceWidth: 4,
      this.visibleTimeBorder: true,
      this.visibleDecorationBorder: false,
      this.timeItemAlignment: Alignment.center,
      this.showTimeAsAMPM: false});
}
