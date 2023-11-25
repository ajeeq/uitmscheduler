// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Constants
import '../constants/colors.dart';

// Widgets
import 'package:uitmscheduler/views/widgets/campus_input_field.dart';

class CampusSelection extends ConsumerStatefulWidget {
  const CampusSelection({Key? key}) : super(key: key);

  @override
  _CampusSelectionState createState() => _CampusSelectionState();
}

class _CampusSelectionState extends ConsumerState<CampusSelection> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Choose your campus"),
        backgroundColor: AppColor.lightPrimary,
      ),
      body: Container(
        child: CampusInputField(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightPrimary,
        icon: const Icon(Icons.navigate_next),
        label: const Text('Next'),
        onPressed: () async {
          // Navigator.pop(context);
          Navigator.pushNamed(context, '/faculty_selection');
        },
      ),
    );

  }
}