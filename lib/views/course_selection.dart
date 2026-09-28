// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Constants

// Services
import 'package:uitmscheduler/api/services.dart';

// Models
import 'package:uitmscheduler/models/course.dart';
import 'package:uitmscheduler/models/group.dart';

// Providers
import 'package:uitmscheduler/providers/course_providers.dart';
import 'package:uitmscheduler/providers/group_providers.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/selection_page.dart';

class CourseSelection extends ConsumerStatefulWidget {
  const CourseSelection({Key? key}) : super(key: key);

  @override
  _CourseSelectionState createState() => _CourseSelectionState();
}

class _CourseSelectionState extends ConsumerState<CourseSelection> {
  @override
  Widget build(BuildContext context) {
    // declaring riverpod state providers
    final List<CourseElement> courseListState = ref.watch(courseListProvider);
    final GroupListNotifier groupListController =
        ref.read(groupListProvider.notifier);

    // declaring notifiers for updating riverpod states
    final CourseNameNotifier courseNameController =
        ref.read(courseNameProvider.notifier);
    final CourseUrlNotifier courseUrlController =
        ref.read(courseUrlProvider.notifier);

    return SelectionPage(
      title: 'Choose your course',
      sectionTitle: '3. Course',
      hintText: 'Search course here',
      items: courseListState.map((e) => e.course).toList(),
      emptyBuilderText: 'No course found',
      onSelected: (suggestion) {
        var url = '';
        for (final obj in courseListState) {
          if (obj.course == suggestion) {
            url = obj.url;
            break;
          }
        }
        courseNameController.updateSelectedCourseName(suggestion);
        courseUrlController.updateCourseUrl(url);
      },
      onNext: () async {
        // declaring riverpod state providers
        final courseUrlState = ref.read(courseUrlProvider);
        try {
          final groups = await Services.getGroup(courseUrlState);
          final List<GroupElement> jsonStringData = groups.groups;

          // updating group list state
          groupListController.updateGroupList(jsonStringData);
          if (!context.mounted) return;
          Navigator.pushNamed(context, '/group_selection');
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unable to load groups: $e'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
    );
  }
}
