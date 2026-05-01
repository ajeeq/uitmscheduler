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

class FacultyInputField extends ConsumerStatefulWidget {
  const FacultyInputField({
    Key? key,
    required this.faculties
  }) : super(key: key);

  final List<Result> faculties;

  @override
  _FacultyInputFieldState createState() => _FacultyInputFieldState();
}

class _FacultyInputFieldState extends ConsumerState<FacultyInputField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsController suggestionBoxController = SuggestionsController();

  String? _selectedSaveFaculty;

  bool isLoading = false;
  List<Result> _faculties = [];

  // late String _selectedCampus;
  late String _selectedFaculty;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    // declaring riverpod state providers
    final List<CourseElement> courseListState = ref.watch(courseListProvider);
    final campusNameState = ref.watch(campusNameProvider);

    // declaring notifiers for updating riverpod states
    final FacultyNameNotifier facultyController = ref.read(facultyNameProvider.notifier);
    final CourseListNotifier courseListController = ref.read(courseListProvider.notifier);
    final faculties = widget.faculties;
    
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
                TitleText(title: "2. Faculty"),
                SearchableInputField(
                  hintText: 'Search faculty here', 
                  items: faculties.map((e) => e.text).toList(), 
                  onSelected: (suggestion) {
                    this._typeAheadController.text = suggestion;
                    _selectedFaculty = suggestion;

                    // updating selected faculty name in state(riverpod)
                    facultyController.updateSelectedFacultyName(_selectedFaculty);
                  },
                  emptyBuilderText: 'No faculty found',
                ),

                SizedBox(height: 4),
                
                Text(
                  "Skip this and hit Next button if you are not UiTM Shah Alam student.",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}