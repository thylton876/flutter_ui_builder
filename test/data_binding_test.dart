import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/state_management/data_binding/data_binding.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Evaluate expression 1 ...', () async {
    final Map<String, dynamic> context =
        jsonDecode('{"firstName": "John", "lastName": "Doe", "age": 18}');

    final result = evalJS("age * 2", context);

    expect(result, 36);
  });

  test('Evaluate expression 2 ...', () async {
    final context = jsonDecode(
        '{"firstName": "John", "lastName": "Doe", "age": 45, "subscriptionTier": "tier_0"}');

    expect(evalJS("subscriptionTier == 'tier_0'", context), true);
    expect(evalJS("subscriptionTier == 'tier_1'", context), false);
    expect(evalJS("age >= 18", context), true);
  });

  test(
    'Evaluate expression 3 ...',
    () async {
      final context = {
        "localVars": {
          "x": 1,
          "y": 2,
          "z": 3,
        },
        "inputProps": {
          "firstName": "John",
          "lastName": "Doe",
          "DateOfBirth": DateTime(1983, 10, 18),
        }
      };

      expect(evalJS('''localVars.y * localVars.z''', context), 6);
      expect(evalJS('''this.localVars.y * this.localVars.z''', context), 6);

      expect(
          evalJS(
              '''inputProps.firstName + ' ' + inputProps.lastName''', context),
          'John Doe');

      expect(
          evalJS('''inputProps.firstName + ' ' + this.inputProps.lastName''',
              context),
          'John Doe');
    },
  );
}
