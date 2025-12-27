import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CacheService {
  static const String _productsKey = 'cached_products';
  static const String _cartKey = 'shopping_cart';
  static const String _darkModeKey = 'dark_mode';
  static const String _viewModeKey = 'view_mode';

  // Product caching
  Future<void> cacheProducts(List<Product> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = products.map((p) => p.toJson()).toList();
      await prefs.setString(_productsKey, json.encode(jsonList));
    } catch (e) {
      // Silent fail - caching is not critical
    }
  }

  Future<List<Product>?> getCachedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_productsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      // Silent fail - return null if cache is corrupted
    }
    return null;
  }

  // Cart persistence
  Future<void> saveCart(List<CartItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = items.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, json.encode(jsonList));
    } catch (e) {
      // Silent fail
    }
  }

  Future<List<CartItem>> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cartKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => CartItem.fromJson(json)).toList();
      }
    } catch (e) {
      // Return empty cart if loading fails
    }
    return [];
  }

  // Dark mode preference
  Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDark);
  }

  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  // View mode preference (true = grid, false = list)
  Future<void> saveViewMode(bool isGrid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_viewModeKey, isGrid);
  }

  Future<bool> loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_viewModeKey) ?? true; // Default to grid
  }
}
