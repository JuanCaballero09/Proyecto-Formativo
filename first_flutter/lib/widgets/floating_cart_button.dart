import 'package:first_flutter/pages/carrito_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
// import '../pages/carrito_page.dart'; // crea o usa la tuya si ya existe

class FloatingCartButton extends StatelessWidget {
  const FloatingCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // si no hay productos, no mostramos el botón
        final itemCount = state.cart.items.length;
        if (itemCount == 0) return const SizedBox.shrink();

        return Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarritoPage()),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_cart,
                    size: 28, color: Theme.of(context).colorScheme.onPrimary),
                if (itemCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$itemCount',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
