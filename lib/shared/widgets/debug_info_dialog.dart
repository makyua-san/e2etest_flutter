import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/infra/fault/fault_provider.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class DebugInfoDialog extends ConsumerWidget {
  const DebugInfoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faultController = ref.watch(faultControllerProvider);

    final debugInfo = '''
アプリ: E2E テスト Flutter デモ
Version: 1.0.0

フォルト状態:
- SORT_REVERSED: ${faultController.isSortReversed ? 'ACTIVE' : 'inactive'}

現在の状態: ${faultController.statusText}
''';

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.bug_report, color: Colors.amber),
          SizedBox(width: 8),
          Text('デバッグ情報'),
        ],
      ),
      content: Semantics(
        label: SemanticsLabels.debugInfoText,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Text(
              debugInfo,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('閉じる'),
        ),
      ],
    );
  }
}
