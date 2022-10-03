import 'package:uitmscheduler/models/lane.dart';
import 'package:uitmscheduler/models/table_event.dart';

class LaneEvents {
  final Lane lane;

  final List<TableEvent> events;

  LaneEvents({
    required this.lane,
    required this.events,
  });
}
