import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts/presentation/screens/accounts_screen.dart';
import '../../features/accounts/presentation/screens/add_account_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/ipo/domain/entities/ipo_entity.dart';
import '../../features/ipo/presentation/screens/ipo_detail_screen.dart';
import '../../features/ipo/presentation/screens/open_ipos_screen.dart';
import '../../features/results/domain/entities/result_entity.dart';
import '../../features/results/presentation/screens/result_detail_screen.dart';
import '../../features/results/presentation/screens/results_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'lock_screen.dart';
import 'route_names.dart';
import 'router_guards.dart';

/// Bridges a Riverpod provider to a [Listenable] for GoRouter's
/// `refreshListenable`, so navigation re-evaluates when the lock state changes.
class _ProviderRefresh extends ChangeNotifier {
  _ProviderRefresh(Ref ref) {
    ref.listen(appLockProvider, (_, _) => notifyListeners());
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _ProviderRefresh(ref);

  return GoRouter(
    initialLocation: RouteNames.dashboardPath,
    refreshListenable: refresh,
    redirect: (context, state) => lockRedirect(
      isUnlocked: ref.read(appLockProvider),
      location: state.uri.path,
    ),
    routes: [
      GoRoute(
        path: RouteNames.lockPath,
        name: RouteNames.lock,
        builder: (_, _) => const LockScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboardPath,
        name: RouteNames.dashboard,
        builder: (_, _) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.accountsPath,
        name: RouteNames.accounts,
        builder: (_, _) => const AccountsScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: RouteNames.addAccount,
            builder: (_, _) => const AddAccountScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.openIposPath,
        name: RouteNames.openIpos,
        builder: (_, _) => const OpenIposScreen(),
        routes: [
          GoRoute(
            path: ':companyShareId',
            name: RouteNames.ipoDetail,
            builder: (context, state) => IpoDetailScreen(
              companyShareId: state.pathParameters['companyShareId']!,
              ipo: state.extra as IpoEntity?,
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.resultsPath,
        name: RouteNames.results,
        builder: (_, _) => const ResultsScreen(),
        routes: [
          GoRoute(
            path: ':companyShareId',
            name: RouteNames.resultDetail,
            builder: (context, state) => ResultDetailScreen(
              companyShareId: state.pathParameters['companyShareId']!,
              result: state.extra as ResultEntity?,
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.historyPath,
        name: RouteNames.history,
        builder: (_, _) => const HistoryScreen(),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (_, _) => const SettingsScreen(),
      ),
    ],
  );
});
