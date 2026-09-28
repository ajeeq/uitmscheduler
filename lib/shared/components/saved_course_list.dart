import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:uitmscheduler/models/selected.dart';

class SavedCourseList extends StatelessWidget {
  final Box box;
  final ValueChanged<int> onDelete;

  const SavedCourseList({
    Key? key,
    required this.box,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: box.length,
      itemBuilder: (context, index) {
        final course = box.getAt(index) as Selected;
        return Card(
          child: ListTile(
            title: Text(course.courseSelected),
            subtitle: Text(course.groupSelected),
            trailing: const Icon(Icons.delete),
            onTap: () => _confirmDelete(context, index),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: const Text('Are you sure to delete this course?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) onDelete(index);
  }
}
