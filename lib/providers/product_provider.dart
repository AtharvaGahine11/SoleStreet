import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/product_service.dart';
import '../services/storage_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _trendingProducts = [];
  List<Product> _newArrivals = [];
  List<Product> _pickedForYou = [];
  final List<Product> _recentlyViewed = [];
  List<ProductCategory> _categories = [];

  String _selectedGender = 'all'; // 'all', 'women', 'men', 'unisex'
  String _selectedCategoryId = 'all';
  ProductFilterOptions _filterOptions = const ProductFilterOptions();
  String _searchQuery = '';
  List<Product> _searchResults = [];
  List<String> _recentSearches = [];

  ProductProvider() {
    _loadInitialData();
  }

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get trendingProducts => _trendingProducts;
  List<Product> get newArrivals => _newArrivals;
  List<Product> get pickedForYou => _pickedForYou;
  List<Product> get recentlyViewed => _recentlyViewed;
  List<ProductCategory> get categories => _categories;

  String get selectedGender => _selectedGender;
  String get selectedCategoryId => _selectedCategoryId;
  ProductFilterOptions get filterOptions => _filterOptions;
  String get searchQuery => _searchQuery;
  List<Product> get searchResults => _searchResults;
  List<String> get recentSearches => _recentSearches;

  void _loadInitialData() {
    _allProducts = _productService.getProducts();
    _filteredProducts = List.from(_allProducts);
    _trendingProducts = _productService.getTrendingProducts();
    _newArrivals = _productService.getNewArrivals();
    _pickedForYou = _productService.getPickedForYou();
    _categories = _productService.getCategories();
    _recentSearches = StorageService.getSearchHistory();
    notifyListeners();
  }

  void setSelectedGender(String gender) {
    if (_selectedGender != gender) {
      _selectedGender = gender;
      _categories = _productService.getCategories(gender: gender);
      _filterOptions = _filterOptions.copyWith(gender: gender == 'all' ? null : gender);
      _applyCurrentFilters();
    }
  }

  void setSelectedCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _filterOptions = _filterOptions.copyWith(
      category: categoryId == 'all' ? null : categoryId,
    );
    _applyCurrentFilters();
  }

  void applyFilterOptions(ProductFilterOptions options) {
    _filterOptions = options;
    _applyCurrentFilters();
  }

  void resetFilters() {
    _filterOptions = ProductFilterOptions(
      gender: _selectedGender == 'all' ? null : _selectedGender,
    );
    _selectedCategoryId = 'all';
    _applyCurrentFilters();
  }

  void setSortBy(String sortBy) {
    _filterOptions = _filterOptions.copyWith(sortBy: sortBy);
    _applyCurrentFilters();
  }

  void _applyCurrentFilters() {
    _filteredProducts = _productService.getProducts(filters: _filterOptions);
    notifyListeners();
  }

  Product? getProductById(String id) {
    return _productService.getProductById(id);
  }

  List<Product> getRelatedProducts(Product product) {
    return _productService.getRelatedProducts(product);
  }

  void addToRecentlyViewed(Product product) {
    _recentlyViewed.removeWhere((p) => p.id == product.id);
    _recentlyViewed.insert(0, product);
    if (_recentlyViewed.length > 8) {
      _recentlyViewed.removeLast();
    }
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = _productService.searchProducts(query);
    }
    notifyListeners();
  }

  Future<void> submitSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    await StorageService.saveSearchQuery(query.trim());
    _recentSearches = StorageService.getSearchHistory();
    search(query);
  }

  Future<void> clearRecentSearches() async {
    await StorageService.clearSearchHistory();
    _recentSearches = [];
    notifyListeners();
  }
}
