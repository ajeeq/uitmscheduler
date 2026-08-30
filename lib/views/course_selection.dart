// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Models
import 'package:uitmscheduler/models/course.dart';
import 'package:uitmscheduler/models/group.dart';

// Providers
import 'package:uitmscheduler/providers/course_providers.dart';
import 'package:uitmscheduler/providers/group_providers.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/searchable_input_field.dart';
import 'package:uitmscheduler/shared/components/title_text.dart';

class CourseSelection extends ConsumerStatefulWidget {
  const CourseSelection({Key? key}) : super(key: key);

  @override
  _CourseSelectionState createState() => _CourseSelectionState();
}

class _CourseSelectionState extends ConsumerState<CourseSelection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsController suggestionController = SuggestionsController();

  @override
  void dispose() {
    super.dispose();
    _typeAheadController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // declaring riverpod state providers
    final List<CourseElement> courseListState = ref.watch(courseListProvider);
    final GroupListNotifier groupListController = ref.read(groupListProvider.notifier);

    // declaring notifiers for updating riverpod states
    final CourseNameNotifier courseNameController = ref.read(courseNameProvider.notifier);
    final CourseUrlNotifier courseUrlController = ref.read(courseUrlProvider.notifier);
    
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your course"),
        backgroundColor: AppColor.lightPrimary
      ),
      body: Container(
        child: GestureDetector(
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightPrimary,
        icon: const Icon(Icons.navigate_next),
        label: const Text('Next'),
        onPressed: () async {
          // declaring riverpod state providers
          final courseUrlState = ref.watch(courseUrlProvider);

          Services.getGroup(courseUrlState).then((groups) {
            final List<GroupElement> jsonStringData = groups.groups;

            // updating group list state
            groupListController.updateGroupList(jsonStringData);
          });

          Navigator.pushNamed(context, '/group_selection');
          
        },
      ),
    );

  }
}