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

// Models
import 'package:uitmscheduler/models/detail.dart';
import 'package:uitmscheduler/models/selected.dart';

// Providers
import 'package:uitmscheduler/providers/selected_providers.dart';
import 'package:uitmscheduler/providers/detail_providers.dart';

class Home extends ConsumerWidget{
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {// declaring notifiers for updating riverpod states
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
      ),
      body: ValueListenableBuilder(
          valueListenable: HiveSelectedCourse.box.listenable(),
          builder: (context, Box box, widget) {
            return SafeArea(
              child: box.isEmpty 
              ? Container(
                color: Colors.grey[85],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Center(
                      child: Text(
                        "No data. Please add course(s) by tapping '+' button on the bottom right corner.",
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
                color: Colors.blue,
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
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/campus_selection');
            },
          ),
  
          const SizedBox(height: 16),
  
          FloatingActionButton(
            tooltip: "Fetch Details",
            heroTag: "fetch",
            backgroundColor: Colors.lightBlue,
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
            },
          ),
          
        ],
      ),
    );
  }
}