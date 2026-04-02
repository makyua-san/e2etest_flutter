import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e2etest_flutter/shared/semantics/semantics_labels.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: Semantics(
              label: SemanticsLabels.navHome,
              child: const Icon(Icons.home_outlined),
            ),
            selectedIcon: Semantics(
              label: SemanticsLabels.navHome,
              child: const Icon(Icons.home),
            ),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Semantics(
              label: SemanticsLabels.navTransactions,
              child: const Icon(Icons.receipt_long_outlined),
            ),
            selectedIcon: Semantics(
              label: SemanticsLabels.navTransactions,
              child: const Icon(Icons.receipt_long),
            ),
            label: '取引',
          ),
          NavigationDestination(
            icon: Semantics(
              label: SemanticsLabels.navSettings,
              child: const Icon(Icons.settings_outlined),
            ),
            selectedIcon: Semantics(
              label: SemanticsLabels.navSettings,
              child: const Icon(Icons.settings),
            ),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
