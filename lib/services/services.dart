// Import directives
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// List of Models
import 'package:uitmscheduler/models/campus.dart';
import 'package:uitmscheduler/models/course.dart';
import 'package:uitmscheduler/models/detail.dart';
import 'package:uitmscheduler/models/group.dart';

class Services {
  // Fetching campus list
  static Future<List<CampusElement>> getCampuses() async {
    var url = Uri.parse("${dotenv.env['API_BASE_URI_CAMPUS']}");
    
    try {
      final response = await http.get(url);

      if(response.statusCode == 200) {
        final campusList = campusFromJson(response.body);
        return campusList.campuses;
      }
      else {
        final campusList = null;
        return campusList;
      }
    }
    catch (e) {
      throw e;
    }
  }

  // Fetching course list
  static Future<List<CourseElement>> getCourses(value) async {
    var url = Uri.parse("${dotenv.env['API_BASE_URI_COURSE']}");
    var body = {
      "campusInputUser": value,
      "facultyInputUser": ""
    };
    
    try {
      final response = await http.post(url, body: body);

      if(response.statusCode == 200) {
        final courseList = courseFromJson(response.body);
        return courseList.courses;
      }
      else {
        final courseList = null;
        return courseList;
      }
    }
    catch (e) {
      throw e;
    }
  }

  // Fetching group list
  static Future<List<GroupElement>> getGroup(campus, course) async {
    var url = Uri.parse("${dotenv.env['API_BASE_URI_GROUP']}");
    var body = {
      "campusInputUser": campus,
      "facultyInputUser": "",
      "courseInputUser": course,
    };
    
    try {
      final response = await http.post(url, body: body);

      if(response.statusCode == 200) {
        final groupList = groupFromJson(response.body);
        return groupList.groups;
      }
      else {
        final groupList = null;
        return groupList;
      }
    }
    catch (e) {
      throw e;
    }
  }

  // Fetching detail list based on selected campus, course, group
  static Future<List<DetailElement>> getDetails(rawJson) async {
    var url = Uri.parse("${dotenv.env['API_BASE_URI_DETAIL']}");
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = rawJson;

    try {
      final response = await http.post(url, headers: headers, body: body);

      if(response.statusCode == 200) {
        final detailsList = detailFromJson(response.body);
        return detailsList.details;
      }
      else {
        List<DetailElement> detailsList = [];
        return detailsList;
      }
    }
    catch (e) {
      throw e;
    }
  }

}