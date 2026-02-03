/// Semantics labels for Maestro E2E testing
class SemanticsLabels {
  SemanticsLabels._();

  // Login Screen
  static const loginUsername = 'login.username';
  static const loginPassword = 'login.password';
  static const loginSubmit = 'login.submit';
  static const loginError = 'login.error';

  // Home Screen
  static const homeUsername = 'home.username';
  static const homeMonthlyTotal = 'home.monthlyTotal';
  static const homeToTransactions = 'home.toTransactions';
  static const homeToSettings = 'home.toSettings';

  // Transactions Screen
  static const txList = 'tx.list';
  static const txSortLabel = 'tx.sortLabel';
  static const txSearch = 'tx.search';
  static const txFilterCategory = 'tx.filter.category';

  // Transaction Row (dynamic)
  static String txRow(String id) => 'tx.row.$id';
  static String txRowTimestamp(String id) => 'tx.row.$id.timestamp';
  static String txRowMerchant(String id) => 'tx.row.$id.merchant';
  static String txRowAmount(String id) => 'tx.row.$id.amount';

  // Transaction Detail Screen
  static const txDetailTitle = 'tx.detail.title';
  static const txDetailTimestamp = 'tx.detail.timestamp';
  static const txDetailAmount = 'tx.detail.amount';
  static const txDetailStatus = 'tx.detail.status';

  // Settings Screen
  static const settingsNotifications = 'settings.notifications';
  static const settingsMaskAmount = 'settings.maskAmount';
  static const settingsBiometric = 'settings.biometric';
  static const settingsLogout = 'settings.logout';

  // Debug Panel
  static const debugPanel = 'debug.panel';
  static const debugFaultSortReversed = 'debug.fault.sortReversed';
  static const debugFaultStatus = 'debug.fault.status';
  static const debugInfoOpen = 'debug.info.open';
  static const debugInfoText = 'debug.info.text';
}
