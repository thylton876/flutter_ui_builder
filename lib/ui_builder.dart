import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/core.dart';
import 'package:flutter_ui_builder/state_management/ui_state.dart';
import 'package:flutter_ui_builder/eventing/ui_event.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

import 'templating/core.dart';

Widget buildWidget(
  html_dom.DocumentFragment document, {
  required BuildContext buildContext,
  required UiState state,
  required NodeHandlerFunc nodeHandlerFunc,
  required void Function(UiEvent) raiseEventFunc,
}) {
  return buildDocument(
    document,
    buildContext: buildContext,
    initialNodeDepth: 0,
    state: state,
    contentMap: {},
    nodeHandlerFunc: nodeHandlerFunc,
    raiseEventFunc: raiseEventFunc,
  ).whereType<Widget>().single;
}

Iterable<Object> buildHtml(
  String html, {
  required BuildContext buildContext,
  required int initialNodeDepth,
  required UiState state,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  yield* buildDocument(
    html_parser.parseFragment(html),
    buildContext: buildContext,
    initialNodeDepth: initialNodeDepth,
    state: state,
    contentMap: contentMap,
    nodeHandlerFunc: nodeHandlerFunc,
    raiseEventFunc: raiseEventFunc,
  );
}

Iterable<Object> buildDocument(
  html_dom.DocumentFragment document, {
  required BuildContext buildContext,
  required int initialNodeDepth,
  required UiState state,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  for (final node in document.nodes) {
    yield* buildNode(
      node,
      buildContext: buildContext,
      document: document,
      contentMap: contentMap,
      nodeDepth: initialNodeDepth,
      state: state,
      nodeHandlerFunc: nodeHandlerFunc,
      raiseEventFunc: raiseEventFunc,
    );
  }
}

Iterable<Object> buildNode(
  html_dom.Node node, {
  required BuildContext buildContext,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required int nodeDepth,
  required UiState state,
  required NodeHandlerFunc nodeHandlerFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  buildChildrenFunc({
    required NodeHandlerFunc nodeHandlerFunc,
  }) sync* {
    for (final child in node.nodes) {
      yield* buildNode(
        child,
        buildContext: buildContext,
        document: document,
        contentMap: contentMap,
        nodeDepth: nodeDepth + 1,
        state: state,
        nodeHandlerFunc: nodeHandlerFunc,
        raiseEventFunc: raiseEventFunc,
      );
    }
  }

  yield* nodeHandlerFunc(
    node,
    buildContext: buildContext,
    document: document,
    contentMap: contentMap,
    nodeDepth: nodeDepth,
    state: state,
    nodeHandlerFunc: nodeHandlerFunc,
    buildDocumentFunc: buildDocument,
    buildNodeFunc: buildNode,
    buildChildrenFunc: buildChildrenFunc,
    raiseEventFunc: raiseEventFunc,
  );
}

NodeHandlerFunc createCustomWidgetBuilder(html_dom.DocumentFragment template) {
  return NodeHandlerFunc((
    html_dom.Node node, {
    required BuildContext buildContext,
    required UiState state,
    required html_dom.DocumentFragment document,
    required int nodeDepth,
    required Map<String, Content> contentMap,
    required NodeHandlerFunc nodeHandlerFunc,
    required BuildDocumentFunc buildDocumentFunc,
    required BuildNodeFunc buildNodeFunc,
    required BuildChildrenFunc buildChildrenFunc,
    required void Function(UiEvent) raiseEventFunc,
  }) sync* {
    final children =
        buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc).toList();

    var newContentMap = {for (var x in children.whereType<Content>()) x.id: x};

    yield* buildDocumentFunc(
      template,
      buildContext: buildContext,
      initialNodeDepth: nodeDepth,
      state: state,
      contentMap: {...newContentMap},
      nodeHandlerFunc: nodeHandlerFunc,
      raiseEventFunc: raiseEventFunc,
    );
  });
}
/*
class BuildResults {
  BuildResults._();

  factory BuildResults.fromObjects(Iterable<Object> objects) {
    final widgets = <Widget>[];
    final contentBlocks = <Content>[];
    final other = <Object>[];
    final contentMap = {};

    for (final object in objects) {
      if (object is Widget) {
        widgets.add(object);
      } else if (object is Content) {
        contentBlocks.add(object);
      } else {
        other.add(object);
      }
    }

    return BuildResults._();
  }

  Iterable<Object> all() sync* {}
}

ContentMap buildContentMap(Iterable<Object> objects) {
  return ContentMap();
}
*/