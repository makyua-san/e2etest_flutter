import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/domain/entities/category.dart';
import 'package:e2etest_flutter/features/transactions/providers/transactions_provider.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(categoryFilterProvider);

    return Semantics(
      label: SemanticsLabels.txFilterCategory,
      child: DropdownButtonFormField<Category?>(
        value: selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: [
          const DropdownMenuItem<Category?>(
            value: null,
            child: Text('All Categories'),
          ),
          ...Category.values.map(
            (category) => DropdownMenuItem<Category?>(
              value: category,
              child: Text(category.displayName),
            ),
          ),
        ],
        onChanged: (value) {
          ref.read(categoryFilterProvider.notifier).state = value;
        },
      ),
    );
  }
}
