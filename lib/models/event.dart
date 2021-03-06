import 'dart:math' show Random;
import 'timerange.dart';

/// An Event takes place at a specified [TimeRange] (A single moment, a simple
/// range, or a recurring [Frequency]). It will have a specific value which is
/// triggered when an event is "active" (Within the TimeRange). An event may
/// also have a specific [priority] or it may be flagged as a special event which
/// supersedes any other events on that day.
class Event {
  // Used in json serialization
  static const String _name = 'name';
  static const String _id = 'id';
  static const String _priority = 'priority';
  static const String _special = 'special';
  static const String _value = 'value';
  static const String _time = 'timeRange';

  /// Display name for the event.
  String name;
  /// Internal identifier for the event.
  String id;
  /// Priority level 0 - 9. 0 Is no priority specified. 1 is highest 9 is lowest.
  int priority;
  /// specialEvent indicates if this event should supersede all other events
  /// for that day. Not to be confused with a higher priority, which will allow
  /// the other events to still occur as long as they do not over-lap.
  bool isSpecial;
  /// Value to be set when event is active
  Object value;
  /// The Date and Time range, and frequency over that period, the event should
  /// occur.
  final TimeRange timeRange;

  Event(this.name, this.timeRange, this.value,
      {this.isSpecial: false, this.priority: 0, this.id: null}) {
    if (id == null) id = generateId();
  }

  /// Update the event's [TimeRange] with the values specified in the provided
  /// parameter. The values are copied from the parameter rather than replacing
  /// the existing TimeRange object.
  void updateTimeRange(TimeRange tr) {
    timeRange
        ..sTime = tr.sTime
        ..sDate = tr.sDate
        ..eTime = tr.eTime
        ..eDate = tr.eDate
        ..frequency = tr.frequency;
  }

  /// Create a new Event from a json map that was previously exported with [toJson]
  factory Event.fromJson(Map<String, dynamic> map) {
    String name = map[_name];
    String id = map[_id];
    int priority = map[_priority] ?? 0;
    bool special = map[_special] ?? false;
    Object value = map[_value];
    TimeRange tr = new TimeRange.fromJson(map[_time]);

    return new Event(name, tr, value,
        isSpecial: special, priority: priority, id: id);
  }

  /// Export the Event to a json map.
  Map<String, dynamic> toJson() => {
    _name: name,
    _id: id,
    _priority: priority,
    _special: isSpecial,
    _value: value,
    _time: timeRange.toJson()
  };
}

/// Create a random ID String of Letters (upper and lowercase) and numbers.
/// Optionally you may specify a length for the string, which defaults to 50.
String generateId({int length: 50}) {
  var buff = new StringBuffer();
  var rand = new Random();

  for (var i = 0; i < length; i++) {
    if (rand.nextBool()) {
      // A = 65, Z = 90. Add 32 for lowercase.
      var cc = rand.nextInt(26) + 65;
      if (rand.nextBool()) cc += 32;
      buff.writeCharCode(cc);
    } else {
      buff.write(rand.nextInt(10));
    }
  }

  return buff.toString();
}

/// Determine which Event, a or b, has highest priority and return that.
/// This handles cases of different priority levels and if an event isSpecial.
/// If both Events have the same priority, Event A will be returned. Throws an
/// [ArgumentError] if both a and b are null.
Event getPriority(Event a, Event b) {
  if (a == null && b == null) {
    throw new ArgumentError('Both Events cannot be null');
  }

  if (a == null) return b;
  if (b == null) return a;
  // 0 Is no priority specified. 1 is highest 9 is lowest.

  // shortcut if one is special and not the other.
  if (a.isSpecial && !b.isSpecial) return a;
  if (!a.isSpecial && b.isSpecial) return b;

  if (a.priority == b.priority) return a; // Just as special and same priority
  if (a.priority < b.priority) {
    if (a.priority == 0) return b;
    return a;
  }
  if (b.priority == 0) return a;
  return b;
}