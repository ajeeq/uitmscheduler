// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/group_providers.dart';

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
                Text(
                  '4. Group',
                  style: TextStyle(
                    fontFamily: 'avenir',
                    fontSize: 32,
                    fontWeight: FontWeight.w900),
                ),
                
                TypeAheadField<String>(
                  suggestionsCallback: (pattern) {
                    Iterable<String> items = groupListState.map((e) => (e.group));
                    return items.where((e) => e.toLowerCase().contains(pattern.toLowerCase())).toList();
                  },
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: _typeAheadController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: () => _typeAheadController.clear(),
                          icon: const Icon(Icons.clear),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey[300]!),
                        ),
                        hintText: 'Search group here',
                      ),
                    );
                  },
                  itemBuilder: (context, group) {
                    return ListTile(
                      title: Text(group),
                    );
                  },
                  transitionBuilder: (context, animation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.fastOutSlowIn,
                      ),
                      child: child,
                    );
                  },
                  emptyBuilder: (context) => Container(
                    height: 70,
                    child: Center(
                      child: Text(
                        'No group found.',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  onSelected: (String suggestion) {
                    _typeAheadController.text = suggestion;

                    // updating selected group name in state(riverpod)
                    groupNameController.updateSelectedGroupName(suggestion.toString());

                  },
                  // suggestionsBoxController: suggestionBoxController,
                  decorationBuilder: (context, child) {
                    return Material(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 8.0,
                      color: Theme.of(context).cardColor,
                      child: child
                    );
                  },
                  autoFlipDirection: true,
                  // autoFlipListDirection: true,
                  // validator: (value) => value!.isEmpty ? 'Please select a group' : null,
                  // onSaved: (value) => this._selectedSaveGroup = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}