import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pefcmeem/app.dart';
import 'package:pefcmeem/app_state.dart';
import 'package:pefcmeem/firebase_options.dart';
import 'package:pefcmeem/router/app_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } on FirebaseException catch (e) {
      if (e.code != 'duplicate-app') rethrow;
    }
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App arranca y muestra onboarding o inicio', (WidgetTester tester) async {
    final appState = AppState();
    await appState.init();
    appState.attachRouter(createAppRouter(appState));
    await tester.pumpWidget(PefcmeemApp(appState: appState));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('EULER'), findsWidgets);
  });
}
