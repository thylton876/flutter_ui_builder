import 'package:flutter_ui_builder/core.dart';
import 'package:flutter_ui_builder/forms/builders.dart';

import '../module.dart';

final formsModule = Module(
  defaultNamespace: 'forms',
  nodeHandlers: {
    'validator': buildValidator.wrap(),
  },
);
