import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/route_names.dart';

/// Bottom navigation bar with the 5 primary destinations. Highlights the tab
/// matching the current GoRouter location.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  static const _destinations = <_NavItem>[
    _NavItem(RouteNames.dashboardPath, Icons.dashboard_outlined,
        Icons.dashboard, 'Home'),
    _NavItem(RouteNames.openIposPath, Icons.trending_up_outlined,
        Icons.trending_up, 'IPOs'),
    _NavItem(RouteNames.resultsPath, Icons.emoji_events_outlined,
        Icons.emoji_events, 'Results'),
    _NavItem(RouteNames.historyPath, Icons.history_outlined, Icons.history,
        'History'),
    _NavItem(RouteNames.accountsPath, Icons.people_outline, Icons.people,
        'Accounts'),
  ];

  int _indexForLocation(String location) {
    final i = _destinations.indexWhere(
      (d) => d.path == '/'
          ? location == '/'
          : location.startsWith(d.path),
    );
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _indexForLocation(location);

    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (i) => context.go(_destinations[i].path),
      destinations: [
        for (final d in _destinations)
          NavigationDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: d.label,
          ),
      ],
    );
  }
}

class _NavItem {
  const _NavItem(this.path, this.icon, this.selectedIcon, this.label);
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
