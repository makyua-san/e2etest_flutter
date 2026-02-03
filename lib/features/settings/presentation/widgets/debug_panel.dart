import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/infra/fault/fault_provider.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class DebugPanel extends ConsumerWidget {
  const DebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faultController = ref.watch(faultControllerProvider);

    return Semantics(
      label: SemanticsLabels.debugPanel,
      child: Card(
        color: Colors.amber.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bug_report,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Debug Panel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const Divider(),
              Semantics(
                label: SemanticsLabels.debugFaultSortReversed,
                child: SwitchListTile(
                  title: const Text('SORT_REVERSED Fault'),
                  subtitle: const Text('Sort transactions oldest first'),
                  value: faultController.isSortReversed,
                  onChanged: (value) {
                    faultController.setSortReversed(value);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Semantics(
                label: SemanticsLabels.debugFaultStatus,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: faultController.isSortReversed
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Status: ${faultController.statusText}',
                    style: TextStyle(
                      color: faultController.isSortReversed
                          ? Colors.red.shade900
                          : Colors.green.shade900,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
