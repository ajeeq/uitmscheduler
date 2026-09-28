// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Constants

// Models
import 'package:uitmscheduler/models/campus_faculty.dart';
import 'package:uitmscheduler/models/course.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/selection_page.dart';

class FacultySelection extends ConsumerStatefulWidget {
  const FacultySelection({Key? key}) : super(key: key);

  @override
  _FacultySelectionState createState() => _FacultySelectionState();
}

class _FacultySelectionState extends ConsumerState<FacultySelection> {
  late String _selectedFaculty;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final CourseListNotifier courseListController =
        ref.read(courseListProvider.notifier);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final faculties = args['faculties'] as List<Result>;

    return SelectionPage(
      title: 'Choose your faculty',
      sectionTitle: '2. Faculty',
      hintText: 'Search faculty here',
      items: faculties.map((e) => e.text).toList(),
      emptyBuilderText: 'No faculty found',
      additionalContent: const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          'Skip this and hit Next button if you are not UiTM Shah Alam student.',
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
      onSelected: (suggestion) {
        _selectedFaculty = suggestion;
        ref
            .read(facultyNameProvider.notifier)
            .updateSelectedFacultyName(_selectedFaculty);
      },
      onNext: () async {
        // declaring riverpod state providers
        final campusNameState = ref.watch(campusNameProvider);
        final facultyNameState = ref.watch(facultyNameProvider);

        Services.getCourses(campusNameState, facultyNameState).then((courses) {
          if (courses.courses.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("No data available from the iCRESS at the moment😐"),
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
    );
  }
}
