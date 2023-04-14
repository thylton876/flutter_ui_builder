import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core.dart';
import 'package:flutter_ui_builder/eventing/ui_event.dart';
import 'package:flutter_ui_builder/forms/form_definition.dart';
import 'package:flutter_ui_builder/forms/form_endpoint_state.dart';
import 'package:flutter_ui_builder/state_management/ui_state.dart';
import 'package:flutter_ui_builder/templating/core.dart';
import 'package:flutter_ui_builder/ui_builder.dart';
import 'package:flutter_ui_builder/utils.dart';
import 'package:http/http.dart' as http;

class FormBuilderWidget extends StatefulWidget {
  const FormBuilderWidget({
    super.key,
    required this.formDefinition,
    required this.nodeHandlerFunc,
  });

  final FormDefinition formDefinition;
  final NodeHandlerFunc nodeHandlerFunc;

  @override
  State<FormBuilderWidget> createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  late UiState _uiState;

  late FormStep _currentStep;

  late final Map<String, FormEndpointState> _endpointStates;

  @override
  void initState() {
    super.initState();

    _uiState = UiState();
    _endpointStates = {
      for (final e in widget.formDefinition.endpoints)
        e.id: const FormEndpointState.initial()
    };

    if (widget.formDefinition.initialStepId.isNotNullEmpty) {
      _transtitionToStepById(widget.formDefinition.initialStepId);
    } else {
      _transtitionToStepByIndex(0);
    }

    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepUiObjects = buildDocument(
      _currentStep.template,
      buildContext: context,
      initialNodeDepth: 0,
      state: _uiState,
      contentMap: {},
      nodeHandlerFunc: widget.nodeHandlerFunc,
      raiseEventFunc: _onUiEvent,
    ).toList();

    const defaultContentId = 'default';

    final stepContentMap = {
      for (final x in stepUiObjects.whereType<Content>()) x.id: x,
      defaultContentId: Content(
        id: defaultContentId,
        build: () => stepUiObjects.whereType<Widget>(),
      )
    };

    final shellUiObjects = buildDocument(
      widget.formDefinition.guiShell!.template,
      buildContext: context,
      initialNodeDepth: 0,
      state: _uiState,
      contentMap: stepContentMap,
      nodeHandlerFunc: widget.nodeHandlerFunc,
      raiseEventFunc: _onUiEvent,
    ).toList();

    return shellUiObjects.whereType<Widget>().firstOrNull ??
        stepUiObjects.whereType<Widget>().firstOrNull ??
        const Placeholder();
  }

  void _transtitionToStepById(String stepId) {
    _transitionToStep(widget.formDefinition.steps
        .singleWhere((step) => step.id.toLowerCase() == stepId.toLowerCase()));
  }

  void _transtitionToStepByIndex(int stepIndex) {
    _transitionToStep(widget.formDefinition.steps[stepIndex]);
  }

  void _transitionToStep(FormStep step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _onUiEvent(UiEvent event) {
    if (event.eventType == UiEventTypes.buttonPressed) {
      final transitionTo = event.node.attributes['form:transition-to'];
      if (transitionTo.isNotNullEmpty) {
        _transtitionToStepById(transitionTo!);
      } else {
        // Raise event
      }
    }
  }

  Future<void> _initialize() async {
    await _invokeEndpoint(widget.formDefinition.initializeEndpointId!);
  }

  Future<void> _saveProgress() async {
    await _invokeEndpoint(widget.formDefinition.saveProgressEndpointId!);
  }

  Future<void> _submit() async {
    await _invokeEndpoint(widget.formDefinition.submitEndpointId);
  }

  Future<void> _invokeEndpoint(String endpointId) async {
    final endpoint = widget.formDefinition.endpoints
        .firstWhere((e) => e.id.toLowerCase() == endpointId.toLowerCase());

    http.Response? httpResponse;

    final url = Uri.parse(endpoint.url);
    final httpMethod = endpoint.httpMethod.toLowerCase();
    final Map<String, String> headers = {};

    try {
      setState(() {
        _endpointStates[endpointId] = const FormEndpointState.loading();
      });

      switch (httpMethod) {
        case 'delete':
          httpResponse = await http.delete(url,
              headers: headers, body: null, encoding: null);
          break;
        case 'get':
          httpResponse = await http.get(url, headers: headers);
          break;
        case 'patch':
          httpResponse = await http.patch(url,
              headers: headers, body: null, encoding: null);
          break;
        case 'post':
          httpResponse = await http.post(url,
              headers: headers, body: null, encoding: null);
          break;
        case 'put':
          httpResponse =
              await http.put(url, headers: headers, body: null, encoding: null);
          break;
        default:
          throw Exception('');
      }

      if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
        setState(
          () {
            _endpointStates[endpointId] = FormEndpointState.data(
              statusCode: httpResponse!.statusCode,
              body: httpResponse.body,
              data: jsonEncode(
                httpResponse.body
                    .apply((body) => body.isNotNullEmpty ? body : '{}'),
              ),
            );
          },
        );
      } else {
        setState(
          () {
            _endpointStates[endpointId] = FormEndpointState.error(
              error: httpResponse!.body,
              statusCode: httpResponse.statusCode,
              body: httpResponse.body,
            );
          },
        );
      }
    } catch (e, st) {
      setState(
        () {
          _endpointStates[endpointId] = FormEndpointState.error(
            error: e,
            stackTrace: st,
            statusCode: httpResponse?.statusCode,
            body: httpResponse?.body,
          );
        },
      );
    }
  }
}
