import 'dart:async';

import "package:dslink/dslink.dart";

import 'package:dslink_schedule/nodes.dart';

Future<Null> main(List<String> args) async {
  LinkProvider link;

  link = new LinkProvider(args, "Schedule-", profiles: {
    AddSchedule.isType: (String path) => new AddSchedule(path, link),
    ScheduleNode.isType: (String path) => new ScheduleNode(path, link),
    DefaultValueNode.isType: (String path) => new DefaultValueNode(path),
    ExportSchedule.isType: (String path) => new ExportSchedule(path),
    ImportSchedule.isType: (String path) => new ImportSchedule(path, link),
    EventsNode.isType: (String path) => new EventsNode(path),
    AddSingleEvent.isType: (String path) => new AddSingleEvent(path, link),
    AddMomentEvent.isType: (String path) => new AddMomentEvent(path, link),
    AddRecurringEvents.isType: (String path) => new AddRecurringEvents(path, link),
    RemoveAction.isType: (String path) => new RemoveAction(path, link),
    EditEvent.isType: (String path) => new EditEvent(path, link),
    EventDateTime.isType: (String path) => new EventDateTime(path),
    EventFrequency.isType: (String path) => new EventFrequency(path),
    EventValue.isType: (String path) => new EventValue(path),
    EventIsSpecial.isType: (String path) => new EventIsSpecial(path),
    EventPriority.isType: (String path) => new EventPriority(path),
    // DataNodes for the schedule link. Specially requested by Pavel O.
    DataRootNode.isType: (String path) => new DataRootNode(path),
    DataNode.isType: (String path) => new DataNode(path, link),
    DataAddNode.isType: (String path) => new DataAddNode(path, link),
    DataRemove.isType: (String path) => new DataRemove(path, link),
    DataAddValue.isType: (String path) => new DataAddValue(path, link),
    DataPublish.isType: (String path) => new DataPublish(path, link)
  },
  defaultNodes: {
    AddSchedule.pathName: AddSchedule.def(),
    ImportSchedule.pathName: ImportSchedule.def(),
  }, autoInitialize: false);

  link.init();
  link.connect();
}
