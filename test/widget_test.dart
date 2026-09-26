import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lumora/providers/auth_provider.dart';
import 'package:lumora/providers/product_provider.dart';
import 'package:lumora/providers/cart_provider.dart';
import 'package:lumora/providers/wishlist_provider.dart';
import 'package:lumora/providers/order_provider.dart';
import 'package:lumora/providers/theme_provider.dart';
import 'package:lumora/providers/notification_provider.dart';
import 'package:lumora/providers/compare_provider.dart';
import 'package:lumora/screens/main_layout.dart';
import 'package:lumora/app/theme/app_theme.dart';

void main() {
  testWidgets('Lumora MainLayout UI renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => CompareProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MainLayout(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify main components exist
    expect(find.byType(MainLayout), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Trending Now ✨'), findsOneWidget);
  });
}
