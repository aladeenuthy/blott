import 'dart:convert';

import 'package:blott/viewmodels/user_info_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('UserInfoViewModel Test', () {
    late UserInfoViewModel viewModel;

    setUp(() {
      viewModel = UserInfoViewModel();
    });

    test(
        'Button should be enabled when both firstName and lastName are provided',
        () {
      viewModel.onchange('John', 'Doe');
      expect(viewModel.buttonEnabled, true);
    });

    test('Button should be disabled when firstName or lastName is empty', () {
      viewModel.onchange('John', '');
      expect(viewModel.buttonEnabled, false);

      viewModel.onchange('', 'Doe');
      expect(viewModel.buttonEnabled, false);
    });

    test('Loading state should toggle during saveUserInfo call', () async {
      final prefs = <String, Object>{};
      SharedPreferences.setMockInitialValues(prefs);

      expect(viewModel.isLoading, false);

      final future = viewModel.saveUserInfo('John', 'Doe');
      expect(viewModel.isLoading, true);

      await future;
      expect(viewModel.isLoading, false);
    });

    test('saveUserInfo should store user data correctly', () async {
      final prefs = <String, Object>{};
      SharedPreferences.setMockInitialValues(
          prefs); 
      await viewModel.saveUserInfo('John', 'Doe');

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final storedData = sharedPreferences.getString('userData');

      expect(storedData, isNotNull);

      final decodedData = jsonDecode(storedData!);
      expect(decodedData['firstName'], 'John');
      expect(decodedData['lastName'], 'Doe');
    });

    test('getUserInfo should retrieve stored user data correctly', () async {
      final prefs = <String, Object>{
        'userData': jsonEncode({
          'firstName': 'John',
          'lastName': 'Doe',
        })
      };
      SharedPreferences.setMockInitialValues(prefs);

      final user = await viewModel.getUserInfo();
      expect(user?.firstName, 'John');
      expect(user?.lastName, 'Doe');
    });

    test('getUserInfo should return null if no user data exists', () async {
      SharedPreferences.setMockInitialValues({});

      final user = await viewModel.getUserInfo();
      expect(user, isNull);
    });
  });
}
