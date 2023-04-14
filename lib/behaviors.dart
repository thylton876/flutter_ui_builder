import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

extension WidgetList on List<Widget> {
  Widget? singleWidgetOrNull() {
    if (length > 1) {
      throw Error();
    }

    return singleOrNull;
  }

  Widget singleWidgetOrDefault() {
    if (length > 1) {
      throw Error();
    }

    return singleOrNull ?? const Spacer();
  }
}
