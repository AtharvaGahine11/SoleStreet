import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/main_layout.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/wishlist/wishlist_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/checkout/checkout_screen.dart';
import '../../screens/orders/orders_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/profile/saved_addresses_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/compare/compare_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String addresses = '/addresses';
  static const String notifications = '/notifications';
  static const String compare = '/compare';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (_) => const SplashScreen(),
      onboarding: (_) => const OnboardingScreen(),
      login: (_) => const LoginScreen(),
      register: (_) => const RegisterScreen(),
      main: (_) => const MainLayout(),
      search: (_) => const SearchScreen(),
      cart: (_) => const CartScreen(),
      wishlist: (_) => const WishlistScreen(),
      checkout: (_) => const CheckoutScreen(),
      orders: (_) => const OrdersScreen(),
      profile: (_) => const ProfileScreen(),
      editProfile: (_) => const EditProfileScreen(),
      addresses: (_) => const SavedAddressesScreen(),
      notifications: (_) => const NotificationsScreen(),
      compare: (_) => const CompareScreen(),
    };
  }
}
