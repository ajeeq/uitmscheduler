// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Widgets
import 'package:uitmscheduler/views/widgets/course_input_field.dart';

class CourseSelection extends ConsumerStatefulWidget {
  const CourseSelection({Key? key}) : super(key: key);

  @override
  _CourseSelectionState createState() => _CourseSelectionState();
}

class _CourseSelectionState extends ConsumerState<CourseSelection> {

  @override
  Widget build(BuildContext context) {
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
          // Navigator.pop(context);
          Navigator.pushNamed(context, '/group_selection');
        },
      ),
    );

  }
}