import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e2etest_flutter/app/app.dart';
import 'package:e2etest_flutter/infra/fault/fault_type.dart';
import 'package:e2etest_flutter/infra/fault/fault_provider.dart';
import 'package:e2etest_flutter/infra/storage/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Check for dart-define FAULT flag
  const faultFlag = String.fromEnvironment('FAULT', defaultValue: '');

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const _AppWithFaultInit(faultFlag: faultFlag),
    ),
  );
}

class _AppWithFaultInit extends ConsumerStatefulWidget {
  final String faultFlag;

  const _AppWithFaultInit({required this.faultFlag});

  @override
  ConsumerState<_AppWithFaultInit> createState() => _AppWithFaultInitState();
}

class _AppWithFaultInitState extends ConsumerState<_AppWithFaultInit> {
  @override
  void initState() {
    super.initState();
    // Apply fault from dart-define if specified
    if (widget.faultFlag.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final fault = FaultType.fromString(widget.faultFlag);
        if (fault != null) {
          ref.read(faultControllerProvider).applyFault(fault);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
