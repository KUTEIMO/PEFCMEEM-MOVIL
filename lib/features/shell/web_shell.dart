import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'web_app_bar_actions.dart';

/// Navegación tipo web (rail / cajón). Una sola barra superior por pantalla (la del contenido),
/// sin engranaje duplicado en el shell.
class WebStudentShell extends StatefulWidget {
  const WebStudentShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<WebStudentShell> createState() => _WebStudentShellState();
}

class _WebStudentShellState extends State<WebStudentShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _destinations = <_WebNavSpec>[
    _WebNavSpec(Icons.home_outlined, Icons.home_rounded, 'Inicio'),
    _WebNavSpec(Icons.route_outlined, Icons.route_rounded, 'Ruta'),
    _WebNavSpec(Icons.leaderboard_outlined, Icons.leaderboard_rounded, 'Ranking'),
    _WebNavSpec(Icons.insights_outlined, Icons.insights_rounded, 'Estadísticas'),
    _WebNavSpec(Icons.person_outline_rounded, Icons.person_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 860;
        if (narrow) {
          return Scaffold(
            key: _scaffoldKey,
            drawer: _buildDrawer(context),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  child: SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu_rounded),
                            tooltip: 'Menú',
                            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                          ),
                          Text(
                            'EULER',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: widget.navigationShell),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NavigationRail(
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: (i) {
                  widget.navigationShell.goBranch(
                    i,
                    initialLocation: i == widget.navigationShell.currentIndex,
                  );
                },
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: widget.navigationShell),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: Text(
              'Menú',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          for (var i = 0; i < _destinations.length; i++)
            ListTile(
              leading: Icon(
                widget.navigationShell.currentIndex == i
                    ? _destinations[i].selectedIcon
                    : _destinations[i].icon,
              ),
              title: Text(_destinations[i].label),
              selected: widget.navigationShell.currentIndex == i,
              onTap: () {
                Navigator.of(context).pop();
                widget.navigationShell.goBranch(
                  i,
                  initialLocation: i == widget.navigationShell.currentIndex,
                );
              },
            ),
          const WebDrawerFooter(),
        ],
      ),
    );
  }
}

class WebTeacherShell extends StatefulWidget {
  const WebTeacherShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<WebTeacherShell> createState() => _WebTeacherShellState();
}

class _WebTeacherShellState extends State<WebTeacherShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _destinations = <_WebNavSpec>[
    _WebNavSpec(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Resumen'),
    _WebNavSpec(Icons.groups_2_outlined, Icons.groups_2_rounded, 'Grupos'),
    _WebNavSpec(Icons.insights_outlined, Icons.insights_rounded, 'Estadísticas'),
    _WebNavSpec(Icons.account_circle_outlined, Icons.account_circle_rounded, 'Cuenta'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 860;
        if (narrow) {
          return Scaffold(
            key: _scaffoldKey,
            drawer: _buildDrawer(context),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  child: SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu_rounded),
                            tooltip: 'Menú',
                            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                          ),
                          Text(
                            'EULER · Docente',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(child: widget.navigationShell),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NavigationRail(
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: (i) {
                  widget.navigationShell.goBranch(
                    i,
                    initialLocation: i == widget.navigationShell.currentIndex,
                  );
                },
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: widget.navigationShell),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: Text(
              'Menú docente',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          for (var i = 0; i < _destinations.length; i++)
            ListTile(
              leading: Icon(
                widget.navigationShell.currentIndex == i
                    ? _destinations[i].selectedIcon
                    : _destinations[i].icon,
              ),
              title: Text(_destinations[i].label),
              selected: widget.navigationShell.currentIndex == i,
              onTap: () {
                Navigator.of(context).pop();
                widget.navigationShell.goBranch(
                  i,
                  initialLocation: i == widget.navigationShell.currentIndex,
                );
              },
            ),
          const WebDrawerFooter(),
        ],
      ),
    );
  }
}

class _WebNavSpec {
  const _WebNavSpec(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
