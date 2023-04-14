import 'package:flutter_js/flutter_js.dart';

import 'utils.dart';

dynamic evalJS(String expression, Map<String, dynamic> context) {
  final localVarsJS = context.entries
      .map((entry) =>
          'let ${entry.key} = ${getJavaScriptObjectLiteral(entry.value)}')
      .join(';\n');

  final javaScript = '''
let context = ${getJavaScriptObjectLiteral(context)};
context.eval = function() {
  $localVarsJS

  return $expression;
};
context.eval();
''';

  final jsRuntime = getJavascriptRuntime();
  final jsResult = jsRuntime.evaluate(javaScript);

  if (jsResult.isError) {
    throw jsResult.rawResult;
  }

  return jsResult.rawResult;
}
