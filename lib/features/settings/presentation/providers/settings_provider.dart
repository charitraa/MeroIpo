import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/storage/preferences_storage.dart';

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.biometricEnabled,
    required this.autoApplyGlobal,
  });

  final ThemeMode themeMode;
  final bool biometricEnabled;
  final bool autoApplyGlobal;

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? biometricEnabled,
    bool? autoApplyGlobal,
  }) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        autoApplyGlobal: autoApplyGlobal ?? this.autoApplyGlobal,
      );
}

class SettingsNotifier extends Notifier<SettingsState> {
  late final PreferencesStorage _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(preferencesStorageProvider);
    return SettingsState(
      themeMode: _themeModeFromString(_prefs.themeMode),
      biometricEnabled: _prefs.biometricEnabled,
      autoApplyGlobal: _prefs.autoApplyGlobalEnabled,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setThemeMode(mode.name);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs.setBiometricEnabled(enabled);
    state = state.copyWith(biometricEnabled: enabled);
  }

  Future<void> setAutoApplyGlobal(bool enabled) async {
    await _prefs.setAutoApplyGlobalEnabled(enabled);
    state = state.copyWith(autoApplyGlobal: enabled);
  }

  static ThemeMode _themeModeFromString(String value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
