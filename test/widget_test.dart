import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:solestreet/main.dart';
import 'package:solestreet/providers/app_state.dart';
import 'package:solestreet/screens/splash_screen.dart';

void main() {
  testWidgets('SoleStreet app loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const SoleStreetApp(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    // Settle splash screen timer
    await tester.pump(const Duration(seconds: 3));
  });
}
