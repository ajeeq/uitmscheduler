// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
import 'package:uitmscheduler/models/selected.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';
import 'package:uitmscheduler/providers/group_providers.dart';
import 'package:uitmscheduler/utils/hive_selected_course.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/selection_page.dart';

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
    final courseUrlState = ref.watch(courseUrlProvider);
    final facultyNameState = ref.watch(facultyNameProvider);
    final groupNameState = ref.watch(groupNameProvider);

    // declaring riverpod state providers
    final groupListState = ref.watch(groupListProvider);

    // declaring notifiers for updating riverpod states
    final GroupNameNotifier groupNameController =
        ref.read(groupNameProvider.notifier);

    return SelectionPage(
      title: 'Choose your group',
      sectionTitle: '4. Group',
      hintText: 'Search group here',
      items: groupListState.map((e) => e.group).toList(),
      emptyBuilderText: 'No group found',
      nextLabel: 'Done',
      nextIcon: Icons.done,
      onSelected: (suggestion) {
        groupNameController.updateSelectedGroupName(suggestion);
      },
      onNext: () async {
        final selection = Selected(
            campusSelected: campusNameState.toString(),
            courseSelected: courseNameState.toString(),
            courseUrlSelected: courseUrlState.toString(),
            facultySelected: facultyNameState.toString(),
            groupSelected: groupNameState.toString());
        await dataStore.addSelected(selectedModel: selection);

        if (!context.mounted) return;
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
    );
  }
}
