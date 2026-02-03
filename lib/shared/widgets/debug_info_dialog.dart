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
App: E2E Test Flutter Demo
Version: 1.0.0

Fault Status:
- SORT_REVERSED: ${faultController.isSortReversed ? 'ACTIVE' : 'inactive'}

Current State: ${faultController.statusText}
''';

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.bug_report, color: Colors.amber),
          SizedBox(width: 8),
          Text('Debug Info'),
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
          child: const Text('Close'),
        ),
      ],
    );
  }
}
