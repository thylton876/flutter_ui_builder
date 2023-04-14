import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as html_dom;

class UiEvent {
  UiEvent({
    required this.eventType,
    this.widgetId,
    this.widgetKey,
    required this.node,
    required this.payload,
  });

  final String eventType;
  final String? widgetId;
  final Key? widgetKey;
  final html_dom.Node node;
  final dynamic payload;
}

abstract class UiEventTypes {
  static const String buttonPressed = "buttonPressed";
  static const String gestureDetectorTapped = "gestureDetectorTapped";
}
