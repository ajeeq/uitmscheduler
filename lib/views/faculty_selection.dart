// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Widgets
import 'package:uitmscheduler/views/widgets/faculty_input_field.dart';

// Models
import 'package:uitmscheduler/models/campus_faculty.dart';
import 'package:uitmscheduler/models/course.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';

class FacultySelection extends ConsumerStatefulWidget {
  const FacultySelection({Key? key}) : super(key: key);

  @override
  _FacultySelectionState createState() => _FacultySelectionState();
}

class _FacultySelectionState extends ConsumerState<FacultySelection> {
   String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final CourseListNotifier courseListController = ref.read(courseListProvider.notifier);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final faculties = args['faculties'] as List<Result>;

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your faculty"),
        backgroundColor: AppColor.lightPrimary,
      ),
      body: Container(
        child: FacultyInputField(faculties: faculties),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightPrimary,
        icon: const Icon(Icons.navigate_next),
        label: const Text('Next'),
        onPressed: () async {
          // declaring riverpod state providers
          final campusNameState = ref.watch(campusNameProvider);
          final facultyNameState = ref.watch(facultyNameProvider);

          Services.getCourses(campusNameState, facultyNameState).then((courses) {
            if(courses.courses.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No data available from the iCRESS at the moment😐"),
                  duration: Duration(seconds: 5),
                ),
              );
            } else {
              final List<CourseElement> jsonStringData = courses.courses;

              // updating course list state using Riverpod
              courseListController.updateCourseList(jsonStringData);
              Navigator.pushNamed(context, '/course_selection');
            }
          }).catchError((e) {
              setState(() {
                _errorMessage = e.toString();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_errorMessage),
                  duration: const Duration(seconds: 5),
                ),
              );
          });
        },
      ),
    );

  }
}