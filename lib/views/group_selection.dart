// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Widgets
import 'package:uitmscheduler/views/widgets/group_input_field.dart';

// Models
import 'package:uitmscheduler/models/selected.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';
import 'package:uitmscheduler/providers/group_providers.dart';
import 'package:uitmscheduler/utils/hive_selected_course.dart';

class GroupSelection extends ConsumerStatefulWidget {
  const GroupSelection({Key? key}) : super(key: key);

  @override
  _GroupSelectionState createState() => _GroupSelectionState();
}

class _GroupSelectionState extends ConsumerState<GroupSelection> {
  final HiveSelectedCourse dataStore = HiveSelectedCourse();

  @override
  Widget build(BuildContext context) {
    // declaring riverpod state providers
    final campusNameState = ref.watch(campusNameProvider);
    final courseNameState = ref.watch(courseNameProvider);
    final facultyNameState = ref.watch(facultyNameProvider);
    final groupNameState = ref.watch(groupNameProvider);

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your group"),
        backgroundColor: AppColor.lightPrimary
      ),
      body: Container(
        child: GroupInputField(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightPrimary,
        icon: const Icon(Icons.done),
        label: const Text('Done'),
        onPressed: () async {
          final selection = Selected(
            campusSelected: campusNameState.toString(),
            courseSelected: courseNameState.toString(),
            facultySelected: facultyNameState.toString(),
            groupSelected: groupNameState.toString()
          );
          dataStore.addSelected(selectedModel: selection);

          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      ),
    );

  }
}