import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html_dom;

import '../core.dart';
import 'package:flutter_ui_builder/eventing/ui_event.dart';
import '../templating/core.dart';
import '../state_management/ui_state.dart';
import 'validator.dart';

Iterable<Validator> buildValidator(
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
  yield Validator();
}
