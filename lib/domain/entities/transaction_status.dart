enum TransactionStatus {
  completed('Completed'),
  pending('Pending'),
  failed('Failed');

  const TransactionStatus(this.displayName);
  final String displayName;

  static TransactionStatus fromString(String value) {
    for (final status in TransactionStatus.values) {
      if (status.name == value || status.displayName == value) {
        return status;
      }
    }
    return TransactionStatus.completed;
  }
}
