import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e2etest_flutter/infra/fault/fault_controller.dart';

final faultControllerProvider = ChangeNotifierProvider<FaultController>((ref) {
  return FaultController();
});
