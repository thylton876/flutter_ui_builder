import 'package:collection/collection.dart';
import 'package:flutter_ui_builder/utils.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class FormDefinition {
  final String id;
  final String initialStepId;
  final String? initializeEndpointId;
  final String? saveProgressEndpointId;
  final String submitEndpointId;
  final FormGuiShell? guiShell;
  late final List<FormStep> steps;
  late final List<FormEndpoint> endpoints;

  FormDefinition({
    required this.id,
    required this.initialStepId,
    this.initializeEndpointId,
    this.saveProgressEndpointId,
    required this.submitEndpointId,
    this.guiShell,
    required Iterable<FormStep> steps,
    required Iterable<FormEndpoint> endpoints,
  }) {
    if (initialStepId.isNotNullEmpty &&
        steps.where((s) => s.id == initialStepId).length != 1) {
      throw ArgumentError();
    }

    if (initializeEndpointId.isNotNullEmpty &&
        endpoints.where((e) => e.id == initializeEndpointId).length != 1) {
      throw ArgumentError();
    }

    if (saveProgressEndpointId.isNotNullEmpty &&
        endpoints.where((e) => e.id == saveProgressEndpointId).length != 1) {
      throw ArgumentError();
    }

    if (submitEndpointId.isNotNullEmpty &&
        endpoints.where((e) => e.id == submitEndpointId).length != 1) {
      throw ArgumentError();
    }

    this.steps = [...steps];
    this.endpoints = [...endpoints];
  }

  factory FormDefinition.deserializeXml(String xml) {
    return FormDefinition.deserializeDocument(XmlDocument.parse(xml));
  }

  factory FormDefinition.deserializeDocument(XmlDocument document) {
    return FormDefinition.fromElement(document.rootElement);
  }

  factory FormDefinition.fromElement(XmlElement element) {
    final id = element.attributeValue('id');

    final initialStepId = element.attributeValue('initial-step-id');

    final initializeEndpointId =
        element.attributeValue('initialize-endpoint-id');
    final saveProgressEndpointId =
        element.attributeValue('save-progress-endpoint-id');
    final submitEndpointId = element.attributeValue('submit-endpoint-id');

    final guiShell = element
        .findAllElements('gui-shell')
        .map((e) => FormGuiShell.deserializeElement(e))
        .singleOrNull;

    final steps = element
        .findAllElements('step')
        .map((e) => FormStep.deserializeElement(e));

    final endpoints = element
        .findAllElements('endpoint')
        .map((e) => FormEndpoint.deserializeElement(e));

    return FormDefinition(
      id: id!,
      initialStepId: initialStepId!,
      initializeEndpointId: initializeEndpointId,
      saveProgressEndpointId: saveProgressEndpointId,
      submitEndpointId: submitEndpointId!,
      guiShell: guiShell,
      steps: steps,
      endpoints: endpoints,
    );
  }
}

Future<FormDefinition> loadFormDefinitionFromUrl(String url) async {
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

  return FormDefinition.deserializeXml(xml);
}

class FormGuiShell {
  FormGuiShell({
    required this.template,
  });

  final html_dom.DocumentFragment template;

  factory FormGuiShell.deserializeElement(XmlElement element) {
    final html = element.findAllElements('template').singleOrNull?.innerText;

    final template = html_parser.parseFragment(html);

    return FormGuiShell(
      template: template,
    );
  }
}

class FormStep {
  FormStep({
    required this.id,
    required this.template,
  });

  final String id;
  final html_dom.DocumentFragment template;

  factory FormStep.deserializeElement(XmlElement element) {
    final id = element.attributeValue('id');
    final html = element.findAllElements('template').singleOrNull?.innerText;

    final template = html_parser.parseFragment(html);

    return FormStep(
      id: id!,
      template: template,
    );
  }
}

class FormEndpoint {
  FormEndpoint({
    required this.id,
    required this.url,
    required this.httpMethod,
  });

  final String id;
  final String url;
  final String httpMethod;

  factory FormEndpoint.deserializeElement(XmlElement element) {
    final id = element.attributeValue('id');
    final url = element.attributeValue('url');
    final httpMethod = element.attributeValue('http-method');

    return FormEndpoint(
      id: id!,
      url: url!,
      httpMethod: httpMethod!,
    );
  }
}
