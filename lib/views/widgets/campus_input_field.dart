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

// Custom Components
import 'package:uitmscheduler/shared/components/searchable_input_field.dart';
import 'package:uitmscheduler/shared/components/title_text.dart';

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
                      TitleText(title: "1. Campus"),
                      SearchableInputField(
                        hintText: 'Search campus here', 
                        items: campuses.map((e) => e.text).toList(), 
                        onSelected: (suggestion) {
                          _typeAheadController.text = suggestion;
                          _selectedCampus = suggestion;

                          // updating selected campus name in state(riverpod)
                          campusController.updateSelectedCampusName(_selectedCampus);
                        },
                        emptyBuilderText: 'No campus found',
                      )
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