import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e2etest_flutter/app/router.dart';
import 'package:e2etest_flutter/features/auth/providers/auth_provider.dart';
import 'package:e2etest_flutter/features/settings/providers/settings_provider.dart';
import 'package:e2etest_flutter/features/settings/presentation/widgets/debug_panel.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Preferences',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Semantics(
                    label: SemanticsLabels.settingsNotifications,
                    child: SwitchListTile(
                      title: const Text('Notifications'),
                      subtitle: const Text('Receive transaction alerts'),
                      value: settings.notificationsEnabled,
                      onChanged: (value) {
                        settingsNotifier.setNotificationsEnabled(value);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Semantics(
                    label: SemanticsLabels.settingsMaskAmount,
                    child: SwitchListTile(
                      title: const Text('Mask Amounts'),
                      subtitle: const Text('Hide transaction amounts'),
                      value: settings.maskAmountEnabled,
                      onChanged: (value) {
                        settingsNotifier.setMaskAmountEnabled(value);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Semantics(
                    label: SemanticsLabels.settingsBiometric,
                    child: SwitchListTile(
                      title: const Text('Biometric Lock'),
                      subtitle: const Text('Require fingerprint to open'),
                      value: settings.biometricEnabled,
                      onChanged: (value) {
                        settingsNotifier.setBiometricEnabled(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Debug',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DebugPanel(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Semantics(
                label: SemanticsLabels.settingsLogout,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(authStateProvider.notifier).logout();
                    context.go(AppRoutes.login);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
