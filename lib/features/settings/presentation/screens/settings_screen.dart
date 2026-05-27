import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _sectionLabel(context, 'Appearance'),
          SettingsTile(
            icon: Icons.brightness_6_outlined,
            title: 'Theme',
            subtitle: _themeLabel(settings.themeMode),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              underline: const SizedBox.shrink(),
              onChanged: (mode) {
                if (mode != null) notifier.setThemeMode(mode);
              },
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
          const Divider(),
          _sectionLabel(context, 'Security'),
          SettingsTile(
            icon: Icons.fingerprint,
            title: 'Biometric lock',
            subtitle: 'Require unlock when opening the app',
            trailing: Switch(
              value: settings.biometricEnabled,
              onChanged: (v) => _toggleBiometric(context, ref, v),
            ),
          ),
          const Divider(),
          _sectionLabel(context, 'Auto-apply'),
          SettingsTile(
            icon: Icons.autorenew,
            title: 'Background auto-apply',
            subtitle:
                'Check and apply every ${AppConstants.backgroundPollInterval.inHours}h',
            trailing: Switch(
              value: settings.autoApplyGlobal,
              onChanged: notifier.setAutoApplyGlobal,
            ),
          ),
          const Divider(),
          _sectionLabel(context, 'About'),
          const SettingsTile(
            icon: Icons.info_outline,
            title: AppConstants.appName,
            subtitle: 'Version 1.0.0',
          ),
          const SettingsTile(
            icon: Icons.lock_outline,
            title: 'Your credentials stay on this device',
            subtitle: 'Passwords are encrypted and only sent to MeroShare.',
          ),
        ],
      ),
    );
  }

  Future<void> _toggleBiometric(
    BuildContext context,
    WidgetRef ref,
    bool enable,
  ) async {
    final notifier = ref.read(settingsProvider.notifier);
    if (!enable) {
      await notifier.setBiometricEnabled(false);
      return;
    }
    final service = ref.read(biometricServiceProvider);
    if (!await service.isAvailable) {
      if (context.mounted) {
        context.showSnack('Biometrics not available on this device',
            isError: true);
      }
      return;
    }
    final ok = await service.authenticate(reason: 'Enable biometric lock');
    if (ok) {
      await notifier.setBiometricEnabled(true);
    } else if (context.mounted) {
      context.showSnack('Authentication failed', isError: true);
    }
  }

  Widget _sectionLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
        child: Text(
          text.toUpperCase(),
          style: context.textTheme.labelSmall
              ?.copyWith(color: context.colors.primary, letterSpacing: 0.8),
        ),
      );

  String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'System default',
      };
}
