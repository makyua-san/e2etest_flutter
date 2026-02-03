enum FaultType {
  sortReversed('SORT_REVERSED');

  const FaultType(this.value);
  final String value;

  static FaultType? fromString(String value) {
    for (final type in FaultType.values) {
      if (type.value == value || type.name == value) {
        return type;
      }
    }
    return null;
  }
}
