import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/state_management/ui_state.dart';

import 'package:html/dom.dart' as html_dom;

import 'eventing/ui_event.dart';
import 'templating/core.dart';

class NodeHandlerFunc {
  NodeHandlerFunc(this.f);

  final Function(
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
  }) f;

  Iterable<Object> call(
    html_dom.Node node, {
    required int nodeDepth,
    required html_dom.DocumentFragment document,
    required Map<String, Content> contentMap,
    required BuildContext buildContext,
    required UiState state,
    required NodeHandlerFunc nodeHandlerFunc,
    required BuildDocumentFunc buildDocumentFunc,
    required BuildNodeFunc buildNodeFunc,
    required BuildChildrenFunc buildChildrenFunc,
    required void Function(UiEvent) raiseEventFunc,
  }) sync* {
    yield* f(
      node,
      buildContext: buildContext,
      state: state,
      document: document,
      nodeDepth: nodeDepth,
      contentMap: contentMap,
      nodeHandlerFunc: nodeHandlerFunc,
      buildDocumentFunc: buildDocumentFunc,
      buildNodeFunc: buildNodeFunc,
      buildChildrenFunc: buildChildrenFunc,
      raiseEventFunc: raiseEventFunc,
    );
  }
}

typedef BuildDocumentFunc = Iterable<Object> Function(
  html_dom.DocumentFragment document, {
  required BuildContext buildContext,
  required int initialNodeDepth,
  required UiState state,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required void Function(UiEvent) raiseEventFunc,
});

typedef BuildNodeFunc = Iterable<Object> Function(
  html_dom.Node node, {
  required BuildContext buildContext,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required int nodeDepth,
  required UiState state,
  required NodeHandlerFunc nodeHandlerFunc,
  required void Function(UiEvent) raiseEventFunc,
});

typedef BuildChildrenFunc = Iterable<Object> Function({
  required NodeHandlerFunc nodeHandlerFunc,
});

class ContentMap {}

extension FunctionExtensions on Iterable<Object> Function(
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
}) {
  NodeHandlerFunc wrap() {
    return NodeHandlerFunc(this);
  }
}
