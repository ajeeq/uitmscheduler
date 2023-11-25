// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Widgets
import 'package:uitmscheduler/views/widgets/faculty_input_field.dart';

class FacultySelection extends ConsumerStatefulWidget {
  const FacultySelection({Key? key}) : super(key: key);

  @override
  _FacultySelectionState createState() => _FacultySelectionState();
}

class _FacultySelectionState extends ConsumerState<FacultySelection> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your faculty"),
        backgroundColor: AppColor.lightPrimary,
      ),
      body: Container(
        child: FacultyInputField(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightPrimary,
        icon: const Icon(Icons.navigate_next),
        label: const Text('Next'),
        onPressed: () async {
          // Navigator.pop(context);
          Navigator.pushNamed(context, '/course_selection');
        },
      ),
    );

  }
}