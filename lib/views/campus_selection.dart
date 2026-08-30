// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Constants
import '../constants/colors.dart';

// Models
import 'package:uitmscheduler/models/campus_faculty.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/searchable_input_field.dart';
import 'package:uitmscheduler/shared/components/title_text.dart';

class CampusSelection extends ConsumerStatefulWidget {
  const CampusSelection({Key? key}) : super(key: key);

  @override
  _CampusSelectionState createState() => _CampusSelectionState();
}

class _CampusSelectionState extends ConsumerState<CampusSelection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  SuggestionsController suggestionController = SuggestionsController();

  bool _isLoading = false;
  late String _selectedCampus;
  String _errorMessage = '';

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
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final campuses = args['campuses'] as List<Result>;

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your campus"),
        backgroundColor: AppColor.lightPrimary,
      ),
      body: Container(
        child: _isLoading 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator()
              ],
              ),
            )
        : SingleChildScrollView(
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
                              ref.read(campusNameProvider.notifier).updateSelectedCampusName(_selectedCampus);
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
          )
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightPrimary,
        icon: const Icon(Icons.navigate_next),
        label: const Text('Next'),
        onPressed: () async {
          Services.getFaculties().then((data) {
            if(data.results.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No data available from the iCRESS at the moment😐"),
                  duration: Duration(seconds: 5),
                ),
              );
            } else {
              // print(jsonEncode(data.results));
              Navigator.pushNamed(context, '/faculty_selection', arguments: {
                'faculties': data.results
              });
            }
          }).catchError((e) {
              setState(() {
                _errorMessage = e.toString();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_errorMessage),
                  duration: const Duration(seconds: 5),
                ),
              );
          });
        },
      ),
    );

  }
}