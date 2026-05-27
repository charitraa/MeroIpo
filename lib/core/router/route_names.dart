/// Named-route constants. Use these with GoRouter — never hardcode paths.
class RouteNames {
  RouteNames._();

  static const String lock = 'lock';
  static const String dashboard = 'dashboard';
  static const String accounts = 'accounts';
  static const String addAccount = 'addAccount';
  static const String openIpos = 'openIpos';
  static const String ipoDetail = 'ipoDetail';
  static const String results = 'results';
  static const String resultDetail = 'resultDetail';
  static const String history = 'history';
  static const String settings = 'settings';

  // Paths.
  static const String lockPath = '/lock';
  static const String dashboardPath = '/';
  static const String accountsPath = '/accounts';
  static const String addAccountPath = '/accounts/add';
  static const String openIposPath = '/ipos';
  static const String ipoDetailPath = '/ipos/:companyShareId';
  static const String resultsPath = '/results';
  static const String resultDetailPath = '/results/:companyShareId';
  static const String historyPath = '/history';
  static const String settingsPath = '/settings';
}
