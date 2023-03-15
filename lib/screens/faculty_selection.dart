// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Widgets
import 'package:uitmscheduler/screens/widgets/faculty_input_field.dart';

class FacultySelection extends ConsumerStatefulWidget {
  const FacultySelection({Key? key}) : super(key: key);

  @override
  _FacultySelectionState createState() => _FacultySelectionState();
}

class _FacultySelectionState extends ConsumerState<FacultySelection> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your faculty"),
      ),
      body: Container(
        child: FacultyInputField(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlue,
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