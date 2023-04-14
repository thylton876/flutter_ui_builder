import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/utils.dart';
import 'package:html/dom.dart' as html_dom;

import 'core.dart';
import 'templating/core.dart';
import 'eventing/ui_event.dart';
import 'state_management/ui_state.dart';

typedef NodeHandlingMiddleware = Iterable<Object> Function(
  html_dom.Node node,
  NodeHandlerFunc next, {
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
});

extension MiddlewareExtension on NodeHandlingMiddleware {
  NodeHandlerFunc chain(NodeHandlerFunc next) {
    return (
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
      yield* this(
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
        next,
      );
    }.wrap();
  }
}

extension MiddlewareIterableExtension on Iterable<NodeHandlingMiddleware> {
  NodeHandlerFunc chain() {
    return toList()
        .reversed
        .fold(noOpNodeHandler, (next, middleware) => middleware.chain(next));
  }
}

Iterable<Object> debugMiddleware(
  html_dom.Node node,
  NodeHandlerFunc next, {
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
  debugPrint('${'  ' * nodeDepth} $node');
  yield* next(
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

Iterable<Object> preprocessingMiddleware(
  html_dom.Node node,
  NodeHandlerFunc next, {
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
  if (node is html_dom.Comment) {
    return;
  } else if (node is html_dom.Text) {
    if (node.text.isNullEmpty) {
      return;
    }

    yield node;
  } else {
    yield* next(
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

Iterable<Object> unhandledNodeMiddleware(
  html_dom.Node node,
  NodeHandlerFunc next, {
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
  // Options: return the raw node, skip node but include children, skip node and children, blowup
  //debugPrint('Unhandled node: $node');
  yield node;
}

final noOpNodeHandler = NodeHandlerFunc((
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
}) sync* {});
