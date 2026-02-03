import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const _keyNotifications = 'settings_notifications';
  static const _keyMaskAmount = 'settings_mask_amount';
  static const _keyBiometric = 'settings_biometric';

  bool get notificationsEnabled => _prefs.getBool(_keyNotifications) ?? true;
  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(_keyNotifications, value);

  bool get maskAmountEnabled => _prefs.getBool(_keyMaskAmount) ?? false;
  Future<void> setMaskAmountEnabled(bool value) =>
      _prefs.setBool(_keyMaskAmount, value);

  bool get biometricEnabled => _prefs.getBool(_keyBiometric) ?? false;
  Future<void> setBiometricEnabled(bool value) =>
      _prefs.setBool(_keyBiometric, value);
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});
