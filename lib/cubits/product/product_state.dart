import 'package:equatable/equatable.dart';
import '../../models/product.dart';

enum SortOption {
  none,
  priceLowToHigh,
  priceHighToLow,
  rating,
  nameAZ,
}

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> allProducts;
  final List<Product> displayedProducts;
  final String? selectedCategory;
  final String searchQuery;
  final SortOption sortOption;
  final double? minPrice;
  final double? maxPrice;
  final bool isGridView;

  const ProductLoaded({
    required this.allProducts,
    required this.displayedProducts,
    this.selectedCategory,
    this.searchQuery = '',
    this.sortOption = SortOption.none,
    this.minPrice,
    this.maxPrice,
    this.isGridView = true,
  });

  List<String> get categories {
    final cats = allProducts.map((p) => p.category).toSet().toList();
    cats.sort();
    return cats;
  }

  @override
  List<Object?> get props => [
        allProducts,
        displayedProducts,
        selectedCategory,
        searchQuery,
        sortOption,
        minPrice,
        maxPrice,
        isGridView,
      ];

  ProductLoaded copyWith({
    List<Product>? allProducts,
    List<Product>? displayedProducts,
    String? selectedCategory,
    String? searchQuery,
    SortOption? sortOption,
    double? minPrice,
    double? maxPrice,
    bool? isGridView,
    bool clearCategory = false,
    bool clearPriceFilter = false,
  }) {
    return ProductLoaded(
      allProducts: allProducts ?? this.allProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      minPrice: clearPriceFilter ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPriceFilter ? null : (maxPrice ?? this.maxPrice),
      isGridView: isGridView ?? this.isGridView,
    );
  }
}

class ProductError extends ProductState {
  final String message;
  final bool hasCache;

  const ProductError(this.message, {this.hasCache = false});

  @override
  List<Object?> get props => [message, hasCache];
}
