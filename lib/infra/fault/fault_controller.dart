import 'package:flutter/foundation.dart';
import 'package:e2etest_flutter/infra/fault/fault_type.dart';

class FaultController extends ChangeNotifier {
  bool _sortReversed = false;

  bool get isSortReversed => _sortReversed;

  void setSortReversed(bool value) {
    if (_sortReversed != value) {
      _sortReversed = value;
      notifyListeners();
    }
  }

  void toggleSortReversed() {
    _sortReversed = !_sortReversed;
    notifyListeners();
  }

  void applyFault(FaultType fault) {
    switch (fault) {
      case FaultType.sortReversed:
        setSortReversed(true);
        break;
    }
  }

  void clearAllFaults() {
    _sortReversed = false;
    notifyListeners();
  }

  String get statusText {
    final faults = <String>[];
    if (_sortReversed) faults.add('SORT_REVERSED');
    return faults.isEmpty ? 'No faults active' : faults.join(', ');
  }
}
