// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Constants
import '../constants/colors.dart';

// Models
import 'package:uitmscheduler/models/campus_faculty.dart';

// Widgets
import 'package:uitmscheduler/views/widgets/campus_input_field.dart';

class CampusSelection extends ConsumerStatefulWidget {
  const CampusSelection({Key? key}) : super(key: key);

  @override
  _CampusSelectionState createState() => _CampusSelectionState();
}

class _CampusSelectionState extends ConsumerState<CampusSelection> {
  String _errorMessage = '';

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
        child: CampusInputField(campuses: campuses),
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