import 'package:collection/collection.dart';
import 'package:xml/xml.dart';

extension StringExtension on String? {
  bool get isNullEmpty => this == null || this!.isEmpty || this!.trim().isEmpty;

  bool get isNotNullEmpty => !isNullEmpty;
}

extension ObjectExtension<T, R> on T {
  R apply(R Function(T value) f) {
    return f(this);
  }
}

extension XmlElementExtension on XmlElement {
  String? attributeValue(String localName) {
    return attributes
        .singleWhereOrNull((a) => a.name.local.toLowerCase() == localName)
        ?.value;
  }
}
