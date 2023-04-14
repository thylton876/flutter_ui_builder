import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html_dom;

import '../core.dart';
import '../eventing/ui_event.dart';
import '../state_management/ui_state.dart';
import 'core.dart';

Iterable<Object> buildIf(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  final element = node as html_dom.Element;

  yield* If(
    expression: element.attributes['expression']!,
    documentFragment: html_dom.DocumentFragment()
      ..nodes.addAll(element.children),
  ).evaluate();
}

Iterable<Object> buildSwitch(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  //final element = node as html_dom.Element;
  return;
  //yield* Switch().evaluate();
}

Iterable<Object> buildSwitchCase(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  //final element = node as html_dom.Element;
  //yield* Switch().evaluate();
  return;
}

Iterable<Object> buildSwitchDefault(
  html_dom.Node node, {
  required int nodeDepth,
  required BuildContext buildContext,
  required UiState state,
  required html_dom.DocumentFragment document,
  required Map<String, Content> contentMap,
  required NodeHandlerFunc nodeHandlerFunc,
  required BuildDocumentFunc buildDocumentFunc,
  required BuildNodeFunc buildNodeFunc,
  required BuildChildrenFunc buildChildrenFunc,
  required void Function(UiEvent) raiseEventFunc,
}) sync* {
  //final element = node as html_dom.Element;
  return;
  //yield* Switch().evaluate();
}

Iterable<Object> buildFor(
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
  final element = node as html_dom.Element;

  yield* For(
    expression: element.attributes['expression']!,
    documentFragment: html_dom.DocumentFragment()
      ..nodes.addAll(element.children),
  ).evaluate();
}

Iterable<Content> buildContent(
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
  final element = node as html_dom.Element;

  yield Content(
    id: element.attributes.keys
        .map((e) => e as String)
        .firstWhere((e) => e.startsWith('#'))
        .substring(1),
    build: () => buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc),
  );
}

Iterable<Object> buildSlot(
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
  final element = node as html_dom.Element;

  final slotId = element.attributes.keys
      .map((e) => e as String)
      .firstWhere((e) => e.startsWith('#'))
      .substring(1);
  if (contentMap.containsKey(slotId)) {
    yield* contentMap[slotId]!.build();
  } else {
    yield* buildChildrenFunc(nodeHandlerFunc: nodeHandlerFunc);
  }
}
