// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Constants

// Models
import 'package:uitmscheduler/models/campus_faculty.dart';

// Providers and Hive
import 'package:uitmscheduler/providers/campus_providers.dart';

// Custom Components
import 'package:uitmscheduler/shared/components/selection_page.dart';

class CampusSelection extends ConsumerStatefulWidget {
  const CampusSelection({Key? key}) : super(key: key);

  @override
  _CampusSelectionState createState() => _CampusSelectionState();
}

class _CampusSelectionState extends ConsumerState<CampusSelection> {
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
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final campuses = args['campuses'] as List<Result>;

    return SelectionPage(
      title: 'Choose your campus',
      sectionTitle: '1. Campus',
      hintText: 'Search campus here',
      items: campuses.map((e) => e.text).toList(),
      emptyBuilderText: 'No campus found',
      onSelected: (suggestion) {
        _selectedCampus = suggestion;
        ref.read(campusNameProvider.notifier).updateSelectedCampusName(_selectedCampus);
      },
      onNext: () async {
        Services.getFaculties().then((data) {
          if (data.results.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No data available from the iCRESS at the moment😐"),
                duration: Duration(seconds: 5),
              ),
            );
          } else {
            // print(jsonEncode(data.results));
            Navigator.pushNamed(
              context, '/faculty_selection', 
              arguments: {'faculties': data.results}
            );
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
    );
  }
}
