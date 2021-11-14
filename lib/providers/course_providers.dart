import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uitmscheduler/models/course.dart';

final courseListProvider = StateNotifierProvider<CourseListNotifier, List<CourseElement>>((ref) => CourseListNotifier());
final courseNameProvider = StateNotifierProvider((ref) => CourseNameNotifier());

class CourseListNotifier extends StateNotifier<List<CourseElement>> {
  CourseListNotifier() : super([]);

  updateCourseList(List<CourseElement> l) {
    state = [];
    state = l;
  }
}

class CourseNameNotifier extends StateNotifier<String> {
  CourseNameNotifier(): super("");

  updateSelectedCourseName(String value) {
    state = value;
  }
}