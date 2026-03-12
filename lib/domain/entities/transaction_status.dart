enum TransactionStatus {
  completed('完了'),
  pending('保留中'),
  failed('失敗');

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
