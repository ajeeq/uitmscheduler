// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Models
import 'package:uitmscheduler/models/campus_faculty.dart';
import 'package:uitmscheduler/models/course.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/searchable_input_field.dart';
import 'package:uitmscheduler/shared/components/title_text.dart';

class FacultySelection extends ConsumerStatefulWidget {
  const FacultySelection({Key? key}) : super(key: key);

  @override
  _FacultySelectionState createState() => _FacultySelectionState();
}

class _FacultySelectionState extends ConsumerState<FacultySelection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsController suggestionBoxController = SuggestionsController();

  bool isLoading = false;
  late String _selectedFaculty;
  String _errorMessage = '';

  @override
  void dispose() {
    super.dispose();
    _typeAheadController.dispose();
  }

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
      body: GestureDetector(
        // close the suggestions box when the user taps outside of it
        onTap: () {
          suggestionBoxController.close();
        },
        child: Container(
          // Add zero opacity to make the gesture detector work
          color: Colors.amber.withOpacity(0),
          // Create the form for the user
          child: Form(
            key: this._formKey,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TitleText(title: "2. Faculty"),
                  SearchableInputField(
                    hintText: 'Search faculty here', 
                    items: faculties.map((e) => e.text).toList(), 
                    onSelected: (suggestion) {
                      this._typeAheadController.text = suggestion;
                      _selectedFaculty = suggestion;

                      // updating selected faculty name in state(riverpod)
                      ref.read(facultyNameProvider.notifier).updateSelectedFacultyName(_selectedFaculty);
                    },
                    emptyBuilderText: 'No faculty found',
                  ),

                  SizedBox(height: 4),
                  
                  Text(
                    "Skip this and hit Next button if you are not UiTM Shah Alam student.",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12
                    )
                  )
                ],
              ),
            ),
          ),
        ),
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