// Import directives
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class SearchableInputField extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final Function(String) onSelected;
  final String emptyBuilderText;

  const SearchableInputField({
    // super.key,
    required this.hintText,
    required this.items,
    required this.onSelected,
    required this.emptyBuilderText,
  });

  @override
  State<SearchableInputField> createState() => _SearchableInputFieldState();
}

class _SearchableInputFieldState extends State<SearchableInputField> {
  late TextEditingController _controller;
  String _currentValue = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController controller = TextEditingController();
    final suggestionController = SuggestionsController();

    return GestureDetector(
      onTap: () => suggestionController.close(),
      child: Padding(
        padding: const EdgeInsets.all(0), 
        child: TypeAheadField<String>(
          controller: _controller,
          suggestionsCallback: (search) {
            return widget.items
              .where((e) =>
                e.toLowerCase().contains(search.toLowerCase()))
              .toList();
          },
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              onChanged: (text) {
              // Sync local state if user types manually
                _currentValue = text;
              },
              focusNode: focusNode,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () => controller.clear(),
                  icon: const Icon(Icons.clear),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: widget.hintText,
              ),
            );
          },
          itemBuilder: (context, item) {
            return ListTile(title: Text(item));
          },
          decorationBuilder: (context, child) {
            return Material(
              borderRadius: BorderRadius.circular(8),
              elevation: 8.0,
              color: Theme.of(context).cardColor,
              child: child,
            );
          },
          onSelected: (value) {
            // controller.text = value;
            // print(value);
            setState(() {
              _controller.text = value; // Updates the text field visibility
              _currentValue = value;    // Updates your local variable
            });
            widget.onSelected(value);
          },
          emptyBuilder: (context) => Container(
             height: 70,
             child: Center(
               child: Text(
                 widget.emptyBuilderText,
                 style: TextStyle(fontSize: 20),
               ),
             ),
           ),
        ),
      ),
    );
  }
}