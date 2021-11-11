import 'package:flutter_riverpod/flutter_riverpod.dart';

final courseListProvider = StateNotifierProvider<CourseListNotifier, List<String>>((ref) => CourseListNotifier());
final courseNameProvider = StateNotifierProvider((ref) => CourseNameNotifier());

class CourseListNotifier extends StateNotifier<List<String>> {
  CourseListNotifier() : super([]);

  updateCourseList(List<String> l) {
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