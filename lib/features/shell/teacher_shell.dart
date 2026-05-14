import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../widgets/companion_dock.dart';
import 'web_shell.dart';

class TeacherShell extends StatefulWidget {
  const TeacherShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends State<TeacherShell> {
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
      return WebTeacherShell(navigationShell: widget.navigationShell);
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
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Resumen',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_2_outlined),
            selectedIcon: Icon(Icons.groups_2_rounded),
            label: 'Grupos',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Estadísticas',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle_rounded),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}
