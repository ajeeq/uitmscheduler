// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Widgets
import 'package:uitmscheduler/views/widgets/course_input_field.dart';

// Models
import 'package:uitmscheduler/models/group.dart';

// Providers
import 'package:uitmscheduler/providers/course_providers.dart';
import 'package:uitmscheduler/providers/group_providers.dart';

class CourseSelection extends ConsumerStatefulWidget {
  const CourseSelection({Key? key}) : super(key: key);

  @override
  _CourseSelectionState createState() => _CourseSelectionState();
}

class _CourseSelectionState extends ConsumerState<CourseSelection> {

  @override
  Widget build(BuildContext context) {
    final GroupListNotifier groupListController = ref.read(groupListProvider.notifier);
    
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your course"),
        backgroundColor: AppColor.lightPrimary
      ),
      body: Container(
        child: CourseInputField(),
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