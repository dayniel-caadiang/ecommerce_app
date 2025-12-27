import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../services/cache_service.dart';
import '../../models/product.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ApiService _apiService;
  final CacheService _cacheService;

  ProductCubit({
    required ApiService apiService,
    required CacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService,
        super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());

    try {
      final products = await _apiService.getAllProducts();
      await _cacheService.cacheProducts(products);
      
      final isGridView = await _cacheService.loadViewMode();
      
      emit(ProductLoaded(
        allProducts: products,
        displayedProducts: products,
        isGridView: isGridView,
      ));
    } catch (e) {
      // Try to load from cache if API fails
      final cachedProducts = await _cacheService.getCachedProducts();
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        final isGridView = await _cacheService.loadViewMode();
        emit(ProductLoaded(
          allProducts: cachedProducts,
          displayedProducts: cachedProducts,
          isGridView: isGridView,
        ));
      } else {
        emit(ProductError(e.toString()));
      }
    }
  }

  void searchProducts(String query) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered = _applyFilters(
        currentState.allProducts,
        searchQuery: query.toLowerCase(),
        category: currentState.selectedCategory,
        minPrice: currentState.minPrice,
        maxPrice: currentState.maxPrice,
      );
      
      final sorted = _applySorting(filtered, currentState.sortOption);
      
      emit(currentState.copyWith(
        displayedProducts: sorted,
        searchQuery: query,
      ));
    }
  }

  void filterByCategory(String? category) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered = _applyFilters(
        currentState.allProducts,
        searchQuery: currentState.searchQuery,
        category: category,
        minPrice: currentState.minPrice,
        maxPrice: currentState.maxPrice,
      );
      
      final sorted = _applySorting(filtered, currentState.sortOption);
      
      emit(currentState.copyWith(
        displayedProducts: sorted,
        selectedCategory: category,
        clearCategory: category == null,
      ));
    }
  }

  void filterByPriceRange(double? min, double? max) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final filtered = _applyFilters(
        currentState.allProducts,
        searchQuery: currentState.searchQuery,
        category: currentState.selectedCategory,
        minPrice: min,
        maxPrice: max,
      );
      
      final sorted = _applySorting(filtered, currentState.sortOption);
      
      emit(currentState.copyWith(
        displayedProducts: sorted,
        minPrice: min,
        maxPrice: max,
        clearPriceFilter: min == null && max == null,
      ));
    }
  }

  void sortProducts(SortOption option) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final sorted = _applySorting(currentState.displayedProducts, option);
      
      emit(currentState.copyWith(
        displayedProducts: sorted,
        sortOption: option,
      ));
    }
  }

  void toggleViewMode() async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      final newIsGrid = !currentState.isGridView;
      await _cacheService.saveViewMode(newIsGrid);
      
      emit(currentState.copyWith(isGridView: newIsGrid));
    }
  }

  void clearFilters() {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      emit(ProductLoaded(
        allProducts: currentState.allProducts,
        displayedProducts: currentState.allProducts,
        isGridView: currentState.isGridView,
      ));
    }
  }

  List<Product> _applyFilters(
    List<Product> products, {
    String? searchQuery,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) {
    var filtered = products;

    // Search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.title.toLowerCase().contains(searchQuery) ||
            p.description.toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Category filter
    if (category != null) {
      filtered = filtered.where((p) => p.category == category).toList();
    }

    // Price range filter
    if (minPrice != null) {
      filtered = filtered.where((p) => p.price >= minPrice).toList();
    }
    if (maxPrice != null) {
      filtered = filtered.where((p) => p.price <= maxPrice).toList();
    }

    return filtered;
  }

  List<Product> _applySorting(List<Product> products, SortOption option) {
    final sorted = List<Product>.from(products);

    switch (option) {
      case SortOption.priceLowToHigh:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.rating:
        sorted.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
        break;
      case SortOption.nameAZ:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.none:
        break;
    }

    return sorted;
  }
}
