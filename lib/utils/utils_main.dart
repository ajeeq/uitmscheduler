import 'package:uitmscheduler/models/detail.dart';
import 'dart:ui';

class UtilsMain {
  static int getHourInt(String hour) {
      var parsedHour = int.parse((hour).split(":")[0]);
      return parsedHour;
    }

  static int getMinuteInt(String minute) {
    var parsedMinute = int.parse((minute).substring(3,5));
    return parsedMinute;
  }

  static int hourToMinute(String hour, String minute) {
    var totalMinute = (int.parse(hour))*60 + int.parse(minute);
    return totalMinute;
  }

  static Set isClash(List<DetailElement> json) {
    bool clashed = false;
    var clashOne;
    var clashTwo;

    for (var i=0; i<json.length; i++) {
      for (var j=i+1; j<json.length; j++) {
        // if first time is the same day with the second day
        if(json[i].day == json[j].day) {
          String startHourFormer = (json[i].start).split(":")[0];
          String startMinuteFormer = (json[i].start).split(":")[1].split(" ")[0];

          String endHourFormer = (json[i].end).split(":")[0];
          String endMinuteFormer = (json[i].end).split(":")[1].split(" ")[0];

          String startHourLatter = (json[j].start).split(":")[0];
          String startMinuteLatter = (json[j].start).split(":")[1].split(" ")[0];

          String endHourLatter = (json[j].end).split(":")[0];
          String endMinuteLatter = (json[j].end).split(":")[1].split(" ")[0];

          var summedMinutesStartFormer = UtilsMain.hourToMinute(startHourFormer, startMinuteFormer);
          var summedMinutesEndFormer = UtilsMain.hourToMinute(endHourFormer, endMinuteFormer);
          var summedMinutesStartLatter = UtilsMain.hourToMinute(startHourLatter, startMinuteLatter);
          var summedMinutesEndLatter = UtilsMain.hourToMinute(endHourLatter, endMinuteLatter);

          if(summedMinutesEndFormer > summedMinutesStartLatter && summedMinutesStartFormer < summedMinutesEndLatter) {
            clashOne = json[i];
            clashTwo = json[j];
            clashed = true;
          }
        }
      }
    }

    if(clashed == true) {
      return {clashed, clashOne, clashTwo};
    } else {
      return {clashed};
    }
    
  }

  static Set setStartDay(detailsList) {
    // Refer lib/darts/set_timetable_column.dart
    List dayColumn = [];
    List dayToCompare = [];

    for (var i=0; i<detailsList.length; i++) {

      var trimmed = detailsList[i].campus.substring(0,1);

      if(trimmed == "D" || trimmed == "K" || trimmed == "J" || trimmed == "T") {
        dayColumn = ['SUN', 'MON', 'TUE', 'WED', 'THU'];
        dayToCompare = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY'];
      } else {
        dayColumn = ['MON', 'TUE', 'WED', 'THU', 'FRI'];
        dayToCompare = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'];
      }
    }

    return { dayColumn, dayToCompare };
  }

  static Set logicalPixelSafeArea() {
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

    return { safeWidth, safeHeight };
  }
}