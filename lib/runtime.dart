import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/forms/forms.module.dart';
import 'package:flutter_ui_builder/middleware.dart';
import 'package:flutter_ui_builder/ui.module.dart';
import 'package:flutter_ui_builder/templating/templating.module.dart';
import 'package:flutter_ui_builder/state_management/ui_state.dart';
import 'package:flutter_ui_builder/utils.dart';
import 'package:html/dom.dart' as html_dom;

import 'core.dart';
import 'eventing/ui_event.dart';
import 'module.dart';
import 'templating/core.dart';

Runtime getDefaultRuntime() {
  final runtime = Runtime();

  runtime.import(templatingModule);
  runtime.import(uiModule);
  runtime.import(formsModule);

  return runtime;
}

class Runtime {
  final List<NodeHandlerBinding> _nodeHandlerBindings = [];

  import(
    Module module, {
    String? as,
  }) {
    module.nodeHandlers.forEach((key, value) {
      final namespace = as.isNotNullEmpty ? as : module.defaultNamespace;
      var elementName = namespace.isNullEmpty ? key : '$namespace:$key';
      registerElement(elementName, value);
    });
  }

  void registerElement(
    String elementName,
    NodeHandlerFunc f,
  ) {
    _nodeHandlerBindings.add(elementName.bindTo(f));
  }

  bool canHandleNode(html_dom.Node node) {
    return _nodeHandlerBindings.any((binding) => binding.predicate(node));
  }

  Iterable<Object> handleNode(
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
    yield* _nodeHandlerBindings
        .firstWhere((binding) => binding.predicate(node))
        .f(
          node,
          buildContext: buildContext,
          state: state,
          document: document,
          contentMap: contentMap,
          nodeDepth: nodeDepth,
          nodeHandlerFunc: nodeHandlerFunc,
          buildDocumentFunc: buildDocumentFunc,
          buildNodeFunc: buildNodeFunc,
          buildChildrenFunc: buildChildrenFunc,
          raiseEventFunc: raiseEventFunc,
        );
  }

  NodeHandlerFunc toNodeHandlingFunc() {
    return handleNode.wrap();
  }

  NodeHandlingMiddleware toNodeHandlingMiddleware() {
    return (
      html_dom.Node node,
      NodeHandlerFunc nextFunc, {
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
      yield* (canHandleNode(node)
          ? handleNode(
              node,
              nodeDepth: nodeDepth,
              buildContext: buildContext,
              state: state,
              document: document,
              contentMap: contentMap,
              nodeHandlerFunc: nodeHandlerFunc,
              buildDocumentFunc: buildDocumentFunc,
              buildNodeFunc: buildNodeFunc,
              buildChildrenFunc: buildChildrenFunc,
              raiseEventFunc: raiseEventFunc,
            )
          : nextFunc(
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
            ));
    };
  }
}

typedef NodePredicate = bool Function(html_dom.Node);

class NodeHandlerBinding {
  NodeHandlerBinding({
    required this.predicate,
    required this.f,
  });

  final NodePredicate predicate;
  final NodeHandlerFunc f;
}

extension StringExtensions on String {
  NodeHandlerBinding bindTo(
    NodeHandlerFunc f,
  ) {
    return NodeHandlerBinding(
      predicate: (node) {
        return node is html_dom.Element && node.localName == this;
      },
      f: f,
    );
  }
}
