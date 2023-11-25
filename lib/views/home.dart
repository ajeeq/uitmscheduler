// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

// Services
import 'package:uitmscheduler/api/services.dart';

// Utils
import 'package:uitmscheduler/utils/utils_main.dart';
import 'package:uitmscheduler/utils/hive_selected_course.dart';

// Constants
import 'package:uitmscheduler/constants/colors.dart';

// Models
import 'package:uitmscheduler/models/detail.dart';
import 'package:uitmscheduler/models/selected.dart';
import 'package:uitmscheduler/models/campus_faculty.dart';

// Providers
import 'package:uitmscheduler/providers/selected_providers.dart';
import 'package:uitmscheduler/providers/detail_providers.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>{
  // const Home({Key? key}) : super(key: key);

  String _errorMessage = '';
  bool data = false;

  @override
  Widget build(BuildContext context) {
    // declaring notifiers for updating riverpod states
    final SelectedListNotifier selectionListController = ref.read(selectedListProvider.notifier);
    final DetailListNotifier detailListController = ref.read(detailListProvider.notifier);

    final HiveSelectedCourse selectedCourseStore = HiveSelectedCourse();

    final Uri url = Uri.parse('https://discord.gg/uTwBPShWdz');
    Future<void> discordUrlLauncher() async {
      if (!await launchUrl(url)) {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("UiTM Scheduler"),
        backgroundColor: AppColor.lightPrimary,
      ),
      body: ValueListenableBuilder(
          valueListenable: HiveSelectedCourse.box.listenable(),
          builder: (context, Box box, widget) {
            return SafeArea(
              child: box.isEmpty 
              ? Container(
                color: AppColor.lightBackground,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Center(
                      child: Text(
                        "No data.",
                        textAlign: TextAlign.center
                      ),
                    )
                  ],
                ),
              )
              : Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Course List',
                        style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 32,
                          fontWeight: FontWeight.w900
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: box.length,
                        itemBuilder: (BuildContext context, int index) { 
                          var courseList = box.getAt(index);

                          return Card(
                            child: ListTile (
                              title: Text(courseList.courseSelected),
                              subtitle: Text(courseList.groupSelected),
                              trailing: const Icon(Icons.delete),
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Delete Course'),
                                    content: const Text('Are you sure to delete this course?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          selectedCourseStore.deleteSelected(index: index);
                                          Navigator.pop(context);
                                        }, 
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  )
                                );
                              },

                            )
                          );
                        },
                      ),
                    ],
                  ),
              )
            );
          }
        ),

        drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor.lightPrimary,
              ),
              child: Text('UiTM Scheduler 0.5.2'),
            ),
            ListTile(
              leading: const Icon(
                Icons.discord,
              ),
              title: const Text('Get Help on Discord!'),
              onTap: () async {
                // Update the state of the app
                // ...
                // Then close the drawer
                // Navigator.pop(context);
                // Navigator.pushNamed(context, '/help');
                discordUrlLauncher();
              },
            ),
          ]
        )
      ),
      
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            tooltip: "Add course",
            heroTag: "add",
            backgroundColor: AppColor.lightPrimary,
            child: const Icon(Icons.add),
            onPressed: () {
              Services.getCampusesFaculties().then((campuses) {
                if(campuses.campuses.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No data available from the iCRESS at the moment😐"),
                      duration: Duration(seconds: 5),
                    ),
                  );
                } else {
                  Navigator.pushNamed(context, '/campus_selection');
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

          data 
            ? const SizedBox(height: 16)
            : const SizedBox.shrink(),

          data 
            ? FloatingActionButton(
                tooltip: "Fetch Details",
                heroTag: "fetch",
                backgroundColor: AppColor.lightPrimary,
                child: const Icon(Icons.find_in_page),
                onPressed: () async {
                  List<Selected> selectedList = selectedCourseStore.getAllSelected();
                  final String jsonString = selectedToJson(selectedList);
        
                  Services.getDetails(jsonString).then((details) {
                    final List<DetailElement> jsonStringData = details.details;
                    bool clashed = false;
            
                    // updating details list returned from API using Riverpod
                    detailListController.updateDetailList(jsonStringData);

                    var isClashSet = UtilsMain.isClash(jsonStringData);
                    clashed = isClashSet.elementAt(0);
                    
                    if(clashed == true) {
                      DetailElement clashOne = isClashSet.elementAt(1);
                      DetailElement clashTwo = isClashSet.elementAt(2);

                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Time clash occured!'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text("${clashOne.course}-${clashOne.group} (${clashOne.start}-${clashOne.end})"),
                                  const Text("is clashed with"),
                                  Text("${clashTwo.course}-${clashTwo.group} (${clashTwo.start}-${clashTwo.end})"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Okay'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }

                    Navigator.pushNamed(context, "/result");
                  });
                }
              )
              : const SizedBox.shrink()
          
          
        ],
      ),
    );
  }
}