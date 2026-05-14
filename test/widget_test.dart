import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pefcmeem/app.dart';
import 'package:pefcmeem/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App arranca y muestra onboarding o inicio', (WidgetTester tester) async {
    final appState = AppState();
    await appState.init();
    await tester.pumpWidget(PefcmeemApp(appState: appState));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('PEFC'), findsWidgets);
  });
}
