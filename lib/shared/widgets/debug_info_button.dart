import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';
import 'package:e2etest_flutter/shared/widgets/debug_info_dialog.dart';

class DebugInfoButton extends ConsumerWidget {
  const DebugInfoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: SemanticsLabels.debugInfoOpen,
      child: IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const DebugInfoDialog(),
          );
        },
        tooltip: 'デバッグ情報',
      ),
    );
  }
}
