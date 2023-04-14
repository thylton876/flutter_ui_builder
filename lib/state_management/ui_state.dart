import 'package:flutter/material.dart';

class UiState {
  UiState();

  final List<TextEditingController> textEditingControllers = const [];
  final Map<String, TextEditingController> _textEditingControllersById = {};

  TextEditingController getTextEditingControllerFor(String textFormFieldId) {
    if (!_textEditingControllersById.containsKey(textFormFieldId)) {
      final textEditingController = TextEditingController();
      textEditingControllers.add(textEditingController);
      _textEditingControllersById[textFormFieldId] = textEditingController;
    }

    return _textEditingControllersById[textFormFieldId]!;
  }

  final List<FormState> formStates = const [];
  final Map<String, FormState> _formStateById = {};

  FormState getFormState(String formId) {
    if (!_formStateById.containsKey(formId)) {
      final formState = FormState();
      formStates.add(formState);
      _formStateById[formId] = formState;
    }

    return _formStateById[formId]!;
  }

  void dispose() {
    for (var textEditingController in textEditingControllers) {
      textEditingController.dispose();
    }
  }
}
