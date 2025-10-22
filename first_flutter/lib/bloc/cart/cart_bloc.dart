import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_model.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final CartItem item;

  AddToCart(this.item);
}

class RemoveFromCart extends CartEvent {
  final String itemId;

  RemoveFromCart(this.itemId);
}

class UpdateCartItemQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  UpdateCartItemQuantity(this.itemId, this.quantity);
}

class ClearCart extends CartEvent {}

class CartState {
  final Cart cart;

  CartState(this.cart);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(Cart())) {
    on<AddToCart>((event, emit) {
      final updatedItems = List<CartItem>.from(state.cart.items);
      final index = updatedItems.indexWhere((item) => item.id == event.item.id);

      if (index >= 0) {
        final existingItem = updatedItems[index];
        updatedItems[index] = existingItem.copyWith(quantity: existingItem.quantity + 1);
      } else {
        updatedItems.add(event.item);
      }

      emit(CartState(Cart(items: updatedItems)));
    });

    on<RemoveFromCart>((event, emit) {
      final updatedItems =
          state.cart.items.where((item) => item.id != event.itemId).toList();
      emit(CartState(Cart(items: updatedItems)));
    });

    on<UpdateCartItemQuantity>((event, emit) {
      final updatedItems = List<CartItem>.from(state.cart.items);
      final index = updatedItems.indexWhere((item) => item.id == event.itemId);

      if (index >= 0) {
        if (event.quantity <= 0) {
          updatedItems.removeAt(index);
        } else {
          updatedItems[index] = updatedItems[index].copyWith(quantity: event.quantity);
        }
      }

      emit(CartState(Cart(items: updatedItems)));
    });

    on<ClearCart>((event, emit) {
      emit(CartState(Cart(items: [])));
    });
  }
}
