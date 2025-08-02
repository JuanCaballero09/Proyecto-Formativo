import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  CarritoPageState createState() => CarritoPageState();
}

class CarritoPageState extends State<CarritoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        title: Center(child: Image.asset("assets/imagen5.png", width: 150)),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final cartItems = state.cart.items;

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'El carrito está vacío.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    'assets/carrito vacio.png',
                    width: 180,
                    height: 180,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Imagen
                      if (item.image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.image!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),

                      const SizedBox(width: 12),

                      // Info + botones
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (item.description != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  item.description!,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          UpdateCartItemQuantity(item.id, item.quantity - 1),
                                        );
                                  },
                                ),
                                Text('Cantidad: ${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          UpdateCartItemQuantity(item.id, item.quantity + 1),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Precio y eliminar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<CartBloc>().add(RemoveFromCart(item.id));
                            },
                          ),
                          Text(
                            '\$ ${item.price * item.quantity} COP',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final cartItems = state.cart.items;

          if (cartItems.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total: \$ ${state.cart.totalPrice} COP',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<CartBloc>().add(ClearCart());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Carrito vaciado')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Vaciar Carrito'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}