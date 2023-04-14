import 'package:flutter/widgets.dart';
import 'package:flutter_ui_builder/runtime.dart';
import 'package:flutter_ui_builder/state_management/ui_state.dart';

import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import 'middleware.dart';
import 'ui_builder.dart';
import 'eventing/ui_event.dart';

class UiBuilderWidget extends StatefulWidget {
  const UiBuilderWidget({
    super.key,
    this.url,
    this.onEvent,
  });

  final String? url;
  final void Function(UiEvent)? onEvent;

  @override
  State<UiBuilderWidget> createState() => _UiBuilderWidgetState();
}

class _UiBuilderWidgetState extends State<UiBuilderWidget> {
  late Runtime _runtime;
  late UiState _uiState;
  html.DocumentFragment? _document;

  @override
  void initState() {
    super.initState();

    _runtime = getDefaultRuntime();
    _uiState = UiState();

    http.get(Uri.parse(widget.url!)).then((value) {
      final html = value.body;
      final document = html_parser.parseFragment(html);
      setState(() {
        _document = document;
      });
    });
  }

  @override
  void dispose() {
    _uiState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _document != null
        ? buildWidget(
            _document!,
            buildContext: context,
            state: _uiState,
            nodeHandlerFunc: <NodeHandlingMiddleware>[
              debugMiddleware,
              _runtime.toNodeHandlingMiddleware(),
              unhandledNodeMiddleware,
            ].chain(),
            raiseEventFunc: raiseEvent,
          )
        : const Spacer();
  }

  void raiseEvent(UiEvent event) {
    widget.onEvent?.call(event);
  }
}
