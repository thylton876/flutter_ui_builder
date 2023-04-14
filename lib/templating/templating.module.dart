import 'package:flutter_ui_builder/core.dart';

import '../module.dart';
import 'builders.dart';

final templatingModule = Module(
  defaultNamespace: '',
  nodeHandlers: {
    'if': buildIf.wrap(),
    'switch': buildSwitch.wrap(),
    'case': buildSwitchCase.wrap(),
    'default': buildSwitchDefault.wrap(),
    'for': buildFor.wrap(),
    'slot': buildSlot.wrap(),
    'content': buildContent.wrap(),
  },
);
