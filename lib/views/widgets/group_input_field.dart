// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/group_providers.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/searchable_input_field.dart';
import 'package:uitmscheduler/shared/components/title_text.dart';

class GroupInputField extends ConsumerStatefulWidget {
  const GroupInputField({Key? key}) : super(key: key);

  @override
  _GroupInputFieldState createState() => _GroupInputFieldState();
}

class _GroupInputFieldState extends ConsumerState<GroupInputField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsController suggestionBoxController = SuggestionsController();

  String? _selectedSaveGroup;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // declaring riverpod state providers
    final groupListState = ref.watch(groupListProvider);

    // declaring notifiers for updating riverpod states
    final GroupNameNotifier groupNameController = ref.read(groupNameProvider.notifier);

    return GestureDetector(
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
    );
  }
}