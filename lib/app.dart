import 'package:flutter/material.dart';

import 'app_state.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Expone [AppState] a todo el árbol bajo [MaterialApp].
class AppContainer extends InheritedWidget {
  const AppContainer({
    required this.appState,
    required super.child,
    super.key,
  });

  final AppState appState;

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppContainer>();
    assert(scope != null, 'AppContainer no encontrado');
    return scope!.appState;
  }

  @override
  bool updateShouldNotify(covariant AppContainer oldWidget) => true;
}

extension AppBuildContext on BuildContext {
  AppState get app => AppContainer.of(this);
}

class PefcmeemApp extends StatelessWidget {
  const PefcmeemApp({required this.appState, super.key});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return AppContainer(
          appState: appState,
          child: MaterialApp.router(
            title: 'PEFCMEEM',
            debugShowCheckedModeBanner: false,
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: appState.themeMode,
            routerConfig: createAppRouter(appState),
          ),
        );
      },
    );
  }
}
