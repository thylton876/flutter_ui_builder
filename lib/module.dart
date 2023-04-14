import 'dart:collection';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'core.dart';

// Define a module type
// Module can be loaded from URL
// There is a default module
// There is a method to load modules into runtime

class Module {
  Module({
    required this.defaultNamespace,
    required Map<String, NodeHandlerFunc> nodeHandlers,
  }) {
    _nodeHandlers = nodeHandlers;
  }

  String defaultNamespace;
  Map<String, NodeHandlerFunc> _nodeHandlers = {};

  UnmodifiableMapView<String, NodeHandlerFunc> get nodeHandlers =>
      UnmodifiableMapView(_nodeHandlers);

  factory Module.deserializeXml(String xml) {
    return Module.deserializeDocument(XmlDocument.parse(xml));
  }

  factory Module.deserializeDocument(XmlDocument document) {
    return Module(
      defaultNamespace: '',
      nodeHandlers: {},
    );
  }
}

Future<Module> loadModuleFromUrl(String url) async {
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-type': 'text/xml',
    },
  );

  if (response.statusCode ~/ 100 != 2) {
    throw response.statusCode;
  }

  final xml = response.body.toString();

  return Module.deserializeXml(xml);
}
