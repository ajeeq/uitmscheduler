// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// API Services
import 'package:uitmscheduler/api/services.dart';

// Models
import 'package:uitmscheduler/models/campus_faculty.dart';
import 'package:uitmscheduler/models/course.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';

class CampusInputField extends ConsumerStatefulWidget {
  const CampusInputField({
    Key? key,
    required this.campuses
  }) : super(key: key);

  final List<Result> campuses;

  @override
  _CampusInputFieldState createState() => _CampusInputFieldState();
}

class _CampusInputFieldState extends ConsumerState<CampusInputField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsController suggestionController = SuggestionsController();

  String? _selectedSaveCampus;

  bool _isLoading = false;
  String _errorMessage = '';
  List<Result> _campuses = [];

  late String _selectedCampus;

  @override
  void initState() {
    super.initState();

    Future<void>.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data loaded from iCRESS successfully!"),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _typeAheadController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // declaring notifiers for updating riverpod states
    final CampusNameNotifier campusController = ref.read(campusNameProvider.notifier);
    final CourseListNotifier courseListController = ref.read(courseListProvider.notifier);
    final campuses = widget.campuses;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator()
          ],
        ),
      );
    }
    else {
      return SingleChildScrollView(
        reverse: true,
        physics: const ClampingScrollPhysics(),
        child: GestureDetector(
          // close the suggestions box when the user taps outside of it
          onTap: () {
            suggestionController.close();
          },
          child: Column(
            children: [
              Form(
                key: this._formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '1. Campus',
                        style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 32,
                          fontWeight: FontWeight.w900),
                      ),
                      
                      TypeAheadField<String>(
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: this._typeAheadController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                onPressed: () => this._typeAheadController.clear(),
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
                              hintText: 'Search campus here',
                            ),
                          );
                        },
                        suggestionsCallback: (pattern) {
                          Iterable<String> items = campuses.map((e) => (e.text));
                          return items.where((e) => e.toLowerCase().contains(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        // transitionBuilder: (context, suggestionsBox, controller) {
                        //   return suggestionsBox;
                        // },
                        emptyBuilder: (context) => Container(
                          height: 70,
                          child: const Center(
                            child: Text(
                              'No campus found.',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        onSelected: (suggestion) {
                          this._typeAheadController.text = suggestion;
                          _selectedCampus = suggestion;

                          // updating selected campus name in state(riverpod)
                          campusController.updateSelectedCampusName(_selectedCampus);
                        },
                        // suggestionsController: suggestionController,
                        decorationBuilder: (context, child) {
                          return Material(
                            borderRadius: BorderRadius.circular(8),
                            elevation: 8.0,
                            color: Theme.of(context).cardColor,
                          );
                        },
                        autoFlipDirection: true,
                        // autoFlipListDirection: true,
                        // validator: (value) => value!.isEmpty ? 'Please select a campus' : null,
                        // onSaved: (value) => this._selectedSaveCampus = value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

  }
}