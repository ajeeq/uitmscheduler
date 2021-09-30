/// RESOURCES:
///  1) https://pusher.com/tutorials/flutter-listviews
/// 

// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Services
import 'package:uitmscheduler/services/services.dart';

// Models
import 'package:uitmscheduler/models/detail.dart';
import 'package:uitmscheduler/models/selection_parameter.dart';

// Providers
import 'package:uitmscheduler/providers/selection_providers.dart';
import 'package:uitmscheduler/providers/detail_providers.dart';

class Home extends ConsumerWidget{
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // declaring riverpod state providers
    final selectionListState = ref.watch(selectionListProvider);

    // declaring notifiers for updating riverpod states
    final SelectionListNotifier selectionListController = ref.read(selectionListProvider.notifier);
    final DetailListNotifier detailListController = ref.read(detailListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("UiTM Scheduler"),
      ),
      body: selectionListState.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'Empty :(',
                ),
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: <Widget>[
                const Text(
                  'Course List',
                  style: TextStyle(
                    fontFamily: 'avenir',
                    fontSize: 32,
                    fontWeight: FontWeight.w900
                  ),
                ),
                for (var i=0; i<selectionListState.length; i++) Card(
                  child: ListTile(
                    title: Text(selectionListState[i].courseSelected),
                    trailing: const Icon(Icons.delete),
                    onTap: () {
                      selectionListController.deleteSelection(selectionListState[i]);
                    },
                  ),
                ),
                  
              ],
            ),
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
              Navigator.pushNamed(context, '/selection');
            },
          ),
  
          const SizedBox(height: 16),
  
          FloatingActionButton(
            tooltip: "Fetch Details",
            heroTag: "fetch",
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.find_in_page),
            onPressed: () async {
              // reading campus, course, group in Provider state
              final jsonString = selectionParameterToJson(selectionListState);
    
              Services.getDetails(jsonString).then((details) {
                final List<DetailElement> jsonStringData = details;
        
                // updating details list returned from API using Riverpod
                detailListController.updateDetailList(jsonStringData);
    
                Navigator.pushNamed(context, "/result");
              });
            },
          ),
          
        ],
      ),
    );
  }
}