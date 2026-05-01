// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// API Services
import 'package:uitmscheduler/api/services.dart';

// Models
import 'package:uitmscheduler/models/course.dart';
import 'package:uitmscheduler/models/group.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';
import 'package:uitmscheduler/providers/group_providers.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/searchable_input_field.dart';
import 'package:uitmscheduler/shared/components/title_text.dart';

class CourseInputField extends ConsumerStatefulWidget {
  const CourseInputField({Key? key}) : super(key: key);

  @override
  _CourseInputFieldState createState() => _CourseInputFieldState();
}

class _CourseInputFieldState extends ConsumerState<CourseInputField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsController suggestionController = SuggestionsController();

  String? _selectedSaveCourse;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // declaring riverpod state providers
    final List<CourseElement> courseListState = ref.watch(courseListProvider);
    final campusNameState = ref.watch(campusNameProvider);
    final facultyNameState = ref.watch(facultyNameProvider);

    // declaring notifiers for updating riverpod states
    final CourseNameNotifier courseNameController = ref.read(courseNameProvider.notifier);
    final CourseUrlNotifier courseUrlController = ref.read(courseUrlProvider.notifier);
    final GroupListNotifier groupListController = ref.read(groupListProvider.notifier);

    return GestureDetector(
      // close the suggestions box when the user taps outside of it
      onTap: () {
        suggestionController.close();
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
                TitleText(title: "3. Course"),
                SearchableInputField(
                  hintText: 'Search course here', 
                  items: courseListState.map((e) => e.course).toList(),
                  onSelected: (suggestion) {
                    _typeAheadController.text = suggestion;
                    var url = '';

                    for (var obj in courseListState) {
                      if (obj.course == suggestion) {
                        url = obj.url;
                        break;
                      }
                    }

                    // updating selected course name and course url in state(riverpod)
                    courseNameController.updateSelectedCourseName(suggestion.toString());
                    courseUrlController.updateCourseUrl(url);
                  },
                  emptyBuilderText: 'No course found',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}