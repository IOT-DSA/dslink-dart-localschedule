import 'package:dslink/dslink.dart';
import 'package:dslink/utils.dart' show logger;

import 'schedule.dart' show ScheduleNode;

abstract class ScheduleChild extends SimpleNode {
  ScheduleChild(String path) : super(path);

  /// Returns the primary [ScheduleNode] for this part of the node tree
  ScheduleNode getSchedule() {
    var p = parent;
    while (p is! ScheduleNode) {
      if (p.parent == null) break;
      p = p.parent;
    }

    if (p == null) {
      logger.warning('Unable to remove event, could not find schedule');
      return null;
    }

    return p as ScheduleNode;
  }
}

class RemoveAction extends SimpleNode {
  static const String pathName = 'removeNode';
  static const String isType = 'removeActionNode';

  static Map<String, dynamic> def() => {
    r'$is': isType,
    r'$name': 'Remove',
    r'$invokable': 'write',
  };

  final LinkProvider _link;
  RemoveAction(String path, this._link) : super(path);

  @override
  void onInvoke(Map<String, dynamic> _) {
    RemoveNode(provider, parent);

    _link.save();
  }
}

void RemoveNode(SimpleNodeProvider provider, SimpleNode node) {
  if (node == null || provider == null) return;

  var childs = node.children.keys.toList();
  for (var cPath in childs) {
    RemoveNode(provider, provider.getNode(node.path + '/$cPath'));
  }

  provider.removeNode(node.path, recurse: false);
}

dynamic parseInputValue(input) {
  if (input is! String) return input;

  var lowerTrimmed = input.trim().toLowerCase();

  if (lowerTrimmed == "true" || lowerTrimmed == "false") {
    return lowerTrimmed == "true";
  }

  var number = num.parse(input, (source) => null);
  if (number != null) return number;

  return input;
}
