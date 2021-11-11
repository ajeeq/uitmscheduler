import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model
import 'package:uitmscheduler/models/selection_parameter.dart';

final selectionListProvider = StateNotifierProvider<SelectionListNotifier, List<SelectionParameter>>((_) => SelectionListNotifier());

class SelectionListNotifier extends StateNotifier<List<SelectionParameter>> {
  SelectionListNotifier() : super([]);

  addSelection(SelectionParameter sp) {
    state = [...state, sp];
  }

  deleteSelection(SelectionParameter sp) {
    state = state.where((_selection) => _selection.courseSelected != sp.courseSelected).toList();
  }

  updateSelection(List<SelectionParameter> sp) {
    state = sp;
  }

  getSelection() {
    return state;
  }

}