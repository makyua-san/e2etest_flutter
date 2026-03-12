import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e2etest_flutter/app/router.dart';
import 'package:e2etest_flutter/features/auth/providers/auth_provider.dart';
import 'package:e2etest_flutter/features/settings/providers/settings_provider.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '環境設定',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
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
                      title: const Text('通知'),
                      subtitle: const Text('取引アラートを受信する'),
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
                      title: const Text('金額を非表示'),
                      subtitle: const Text('取引金額を隠す'),
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
                      title: const Text('生体認証ロック'),
                      subtitle: const Text('指紋認証でロック解除'),
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
              child: Semantics(
                label: SemanticsLabels.settingsLogout,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(authStateProvider.notifier).logout();
                    context.go(AppRoutes.login);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('ログアウト'),
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
