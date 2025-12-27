import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/cache_service.dart';
import '../../models/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CacheService _cacheService;

  CartCubit({required CacheService cacheService})
      : _cacheService = cacheService,
        super(const CartState()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    emit(state.copyWith(isLoading: true));
    try {
      final items = await _cacheService.loadCart();
      emit(CartState(items: items, isLoading: false));
    } catch (e) {
      emit(const CartState(isLoading: false));
    }
  }

  Future<void> addItem({
    required int productId,
    required String title,
    required double price,
    required String image,
    int quantity = 1,
  }) async {
    final currentItems = List<CartItem>.from(state.items);
    
    final existingIndex = currentItems.indexWhere(
      (item) => item.productId == productId,
    );

    if (existingIndex >= 0) {
      // Update existing item quantity
      currentItems[existingIndex].quantity += quantity;
    } else {
      // Add new item
      currentItems.add(CartItem(
        productId: productId,
        title: title,
        price: price,
        image: image,
        quantity: quantity,
      ));
    }

    emit(state.copyWith(items: currentItems));
    await _saveCart();
  }

  Future<void> removeItem(int productId) async {
    final updatedItems = state.items
        .where((item) => item.productId != productId)
        .toList();

    emit(state.copyWith(items: updatedItems));
    await _saveCart();
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
    await _saveCart();
  }

  Future<void> incrementQuantity(int productId) async {
    final item = state.getItem(productId);
    if (item != null) {
      await updateQuantity(productId, item.quantity + 1);
    }
  }

  Future<void> decrementQuantity(int productId) async {
    final item = state.getItem(productId);
    if (item != null) {
      await updateQuantity(productId, item.quantity - 1);
    }
  }

  Future<void> clearCart() async {
    emit(const CartState());
    await _saveCart();
  }

  Future<void> _saveCart() async {
    await _cacheService.saveCart(state.items);
  }
}
