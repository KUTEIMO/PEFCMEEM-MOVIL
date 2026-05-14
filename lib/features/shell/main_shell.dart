import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../widgets/companion_dock.dart';
import 'web_shell.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  String? _lastPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final path = GoRouterState.of(context).uri.path;
    if (path != _lastPath) {
      _lastPath = path;
      context.app.updateCompanionForRoute(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebStudentShell(navigationShell: widget.navigationShell);
    }
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          RepaintBoundary(
            child: widget.navigationShell,
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 78,
            child: const CompanionDock(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route_rounded),
            label: 'Ruta',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard_rounded),
            label: 'Ranking',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Estadísticas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
