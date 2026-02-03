import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/features/transactions/providers/transactions_provider.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class TransactionSearchBar extends ConsumerStatefulWidget {
  const TransactionSearchBar({super.key});

  @override
  ConsumerState<TransactionSearchBar> createState() =>
      _TransactionSearchBarState();
}

class _TransactionSearchBarState extends ConsumerState<TransactionSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: SemanticsLabels.txSearch,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search by merchant...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
      ),
    );
  }
}
