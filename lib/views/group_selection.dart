// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Models
import 'package:uitmscheduler/models/selected.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';
import 'package:uitmscheduler/providers/group_providers.dart';
import 'package:uitmscheduler/utils/hive_selected_course.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/searchable_input_field.dart';
import 'package:uitmscheduler/shared/components/title_text.dart';

class GroupSelection extends ConsumerStatefulWidget {
  const GroupSelection({Key? key}) : super(key: key);

  @override
  _GroupSelectionState createState() => _GroupSelectionState();
}

class _GroupSelectionState extends ConsumerState<GroupSelection> {
  final HiveSelectedCourse dataStore = HiveSelectedCourse();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsController suggestionBoxController = SuggestionsController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _typeAheadController.dispose();
  }

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
    final GroupNameNotifier groupNameController = ref.read(groupNameProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your group"),
        backgroundColor: AppColor.lightPrimary
      ),
      body: Container(
        child: GestureDetector(
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
                    TitleText(title: "4. Group"),
                    SearchableInputField(
                      hintText: 'Search group here', 
                      items: groupListState.map((e) => e.group).toList(), 
                      onSelected: (suggestion) {
                        _typeAheadController.text = suggestion;

                        // updating selected group name in state(riverpod)
                        groupNameController.updateSelectedGroupName(suggestion.toString());
                      },
                      emptyBuilderText: 'No group found',
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
        icon: const Icon(Icons.done),
        label: const Text('Done'),
        onPressed: () async {
          final selection = Selected(
            campusSelected: campusNameState.toString(),
            courseSelected: courseNameState.toString(),
            courseUrlSelected: courseUrlState.toString(),
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