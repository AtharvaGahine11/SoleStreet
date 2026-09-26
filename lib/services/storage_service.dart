import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Theme
  static bool isDarkMode() {
    return _prefs?.getBool(AppConstants.themePrefKey) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(AppConstants.themePrefKey, value);
  }

  // Wishlist
  static List<String> getWishlistIds() {
    return _prefs?.getStringList(AppConstants.wishlistPrefKey) ?? [];
  }

  static Future<void> setWishlistIds(List<String> ids) async {
    await _prefs?.setStringList(AppConstants.wishlistPrefKey, ids);
  }

  // Search History
  static List<String> getSearchHistory() {
    return _prefs?.getStringList(AppConstants.searchHistoryPrefKey) ?? [
      'Minimal Gold Chain',
      'Obsidian Watch',
      'Pearl Earrings',
      'Cuban Link',
    ];
  }

  static Future<void> saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    final list = getSearchHistory().toSet().toList();
    list.remove(query);
    list.insert(0, query);
    if (list.length > 10) {
      list.removeLast();
    }
    await _prefs?.setStringList(AppConstants.searchHistoryPrefKey, list);
  }

  static Future<void> clearSearchHistory() async {
    await _prefs?.remove(AppConstants.searchHistoryPrefKey);
  }
}
