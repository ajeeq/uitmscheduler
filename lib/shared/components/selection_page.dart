import 'package:flutter/material.dart';

import 'package:uitmscheduler/constants/colors.dart';
import 'package:uitmscheduler/shared/components/searchable_input_field.dart';
import 'package:uitmscheduler/shared/components/title_text.dart';

class SelectionPage extends StatelessWidget {
  final String title;
  final String sectionTitle;
  final String hintText;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final String emptyBuilderText;
  final Future<void> Function() onNext;
  final String nextLabel;
  final IconData nextIcon;
  final Widget? additionalContent;
  final bool isLoading;

  const SelectionPage({
    Key? key,
    required this.title,
    required this.sectionTitle,
    required this.hintText,
    required this.items,
    required this.onSelected,
    required this.emptyBuilderText,
    required this.onNext,
    this.nextLabel = 'Next',
    this.nextIcon = Icons.navigate_next,
    this.additionalContent,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColor.lightPrimary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(title: sectionTitle),
                    SearchableInputField(
                      hintText: hintText,
                      items: items,
                      onSelected: onSelected,
                      emptyBuilderText: emptyBuilderText,
                    ),
                    if (additionalContent != null) additionalContent!,
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.lightPrimary,
        icon: Icon(nextIcon),
        label: Text(nextLabel),
        onPressed: onNext,
      ),
    );
  }
}
