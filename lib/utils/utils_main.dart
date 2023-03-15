import 'package:uitmscheduler/models/detail.dart';

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
}