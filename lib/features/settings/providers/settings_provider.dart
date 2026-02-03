import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/infra/storage/preferences_service.dart';

class SettingsState {
  final bool notificationsEnabled;
  final bool maskAmountEnabled;
  final bool biometricEnabled;

  const SettingsState({
    this.notificationsEnabled = true,
    this.maskAmountEnabled = false,
    this.biometricEnabled = false,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? maskAmountEnabled,
    bool? biometricEnabled,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      maskAmountEnabled: maskAmountEnabled ?? this.maskAmountEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final PreferencesService _preferencesService;

  SettingsNotifier(this._preferencesService)
      : super(SettingsState(
          notificationsEnabled: _preferencesService.notificationsEnabled,
          maskAmountEnabled: _preferencesService.maskAmountEnabled,
          biometricEnabled: _preferencesService.biometricEnabled,
        ));

  Future<void> setNotificationsEnabled(bool value) async {
    await _preferencesService.setNotificationsEnabled(value);
    state = state.copyWith(notificationsEnabled: value);
  }

  Future<void> setMaskAmountEnabled(bool value) async {
    await _preferencesService.setMaskAmountEnabled(value);
    state = state.copyWith(maskAmountEnabled: value);
  }

  Future<void> setBiometricEnabled(bool value) async {
    await _preferencesService.setBiometricEnabled(value);
    state = state.copyWith(biometricEnabled: value);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final preferencesService = ref.watch(preferencesServiceProvider);
  return SettingsNotifier(preferencesService);
});
