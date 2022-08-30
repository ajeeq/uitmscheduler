// Import directives
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Widgets
import 'package:uitmscheduler/screens/widgets/course_autocomplete.dart';
import 'package:uitmscheduler/screens/widgets/group_autocomplete.dart';

// API Services
import 'package:uitmscheduler/services/services.dart';

// Models
import 'package:uitmscheduler/models/campus.dart';
import 'package:uitmscheduler/models/course.dart';
import 'package:uitmscheduler/models/selected.dart';

// Providers
import 'package:uitmscheduler/providers/campus_providers.dart';
import 'package:uitmscheduler/providers/course_providers.dart';
import 'package:uitmscheduler/providers/group_providers.dart';
import 'package:uitmscheduler/providers/selected_providers.dart';


class Selection extends ConsumerStatefulWidget {
  const Selection({Key? key}) : super(key: key);
  
  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends ConsumerState<Selection> {
  bool isLoading = false;
  List<CampusElement> _campuses = [];
  late TextEditingController controller;
  late String _selectedCampus;

  @override
  void initState() {
    super.initState();

    isLoading = true;
    Services.getCampuses().then((campuses) {
      final List<CampusElement> jsonStringData = campuses;

      setState(() {
        _campuses = jsonStringData;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // declaring riverpod state providers
    final courseNameState = ref.watch(courseNameProvider);
    final groupNameState = ref.watch(groupNameProvider);
    final selectedListState = ref.watch(selectedListProvider);

    // declaring notifiers for updating riverpod states
    final CampusNameNotifier campusController = ref.read(campusNameProvider.notifier);
    final CourseListNotifier courseListController = ref.read(courseListProvider.notifier);
    final SelectedListNotifier selectedListController = ref.read(selectedListProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add Course"),
      ),
      body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            reverse: true,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '1. Campus',
                        style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 32,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      
                      Autocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          } else {
                            return _campuses.map((e) => e.campus).where((word) => word
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                          }
                        },
                        optionsViewBuilder: (context, Function(String) onSelected, options) {
                          return Material(
                            elevation: 4,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
            
                                return ListTile(
                                  title: SubstringHighlight(
                                    text: option.toString(),
                                    term: controller.text,
                                    textStyleHighlight: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  onTap: () {
                                    onSelected(option.toString());
                                  },
                                );
                              },
                            ),
                          );
                        },
                        onSelected: (selectedString) async {
                          _selectedCampus = selectedString.toString();

                          // updating selected campus name in state(riverpod)
                          campusController.updateSelectedCampusName(_selectedCampus);
                    
                          Services.getCourses(selectedString).then((courses) {
                            final List<CourseElement> jsonStringData = courses;

                            // updating course list state using Riverpod
                            courseListController.updateCourseList(jsonStringData);
                          });
                        },
                        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                          this.controller = controller;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onEditingComplete: onEditingComplete,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              hintText: "Search campus here",
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                onPressed: () => controller.clear(), 
                                icon: const Icon(Icons.clear)
                              )
                            ),
                          );
                        },
                      ),
                    ],
        
                  ),
                ),
              
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '2. Course',
                        style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 32,
                          fontWeight: FontWeight.w900
                        ),
                      ),
  
                      CourseAutocomplete(),
                    ]
                  )
                
                ),
              
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '3. Group',
                        style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 32,
                          fontWeight: FontWeight.w900
                        ),
                      ),
  
                      GroupAutocomplete(),
                    ]
                  )
                
                ),
              
              ],
            ),
          ),
  
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.done),
            label: const Text('Done'),
            onPressed: () async {
              // adding user course selection using Riverpod
              selectedListController.addSelected(Selected(
                campusSelected: _selectedCampus,
                courseSelected: courseNameState.toString(),
                facultySelected: "",
                groupSelected: groupNameState.toString()
              ));
  
              Navigator.pop(context);
            },
          ),
    );

  }
}