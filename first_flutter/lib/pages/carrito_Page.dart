import 'package:first_flutter/pages/product_catalog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../service/api_service.dart';
import '../core/errors/exceptions.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  CarritoPageState createState() => CarritoPageState();
}

class CarritoPageState extends State<CarritoPage> {
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _direccionController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _showCheckoutDialog(BuildContext context) async {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is Authenticated;

    // Limpiar controllers
    _direccionController.clear();
    _nombreController.clear();
    _apellidoController.clear();
    _emailController.clear();
    _telefonoController.clear();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.shopping_bag, color: Color.fromRGBO(237, 88, 33, 1)),
                  const SizedBox(width: 8),
                  const Text('Finalizar Pedido'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mostrar resumen del carrito
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.shopping_cart, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${state.cart.items.length} productos',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '\$${NumberFormat('#,###', 'es_CO').format(state.cart.totalPrice)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dirección de entrega (TODOS)
                    const Text('📍 Dirección de Entrega', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _direccionController,
                      decoration: const InputDecoration(
                        hintText: 'Ej: Calle 123 #45-67, Bogotá',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // Datos del invitado (solo si NO está autenticado)
                    if (!isAuthenticated) ...[
                      const Text('👤 Información Personal', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nombreController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _apellidoController,
                              decoration: const InputDecoration(
                                labelText: 'Apellido',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'correo@ejemplo.com',
                          border: OutlineInputBorder(),
                          isDense: true,
                          prefixIcon: Icon(Icons.email, size: 20),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _telefonoController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          hintText: '3001234567',
                          border: OutlineInputBorder(),
                          isDense: true,
                          prefixIcon: Icon(Icons.phone, size: 20),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isProcessing ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _isProcessing ? null : () async {
                    setState(() => _isProcessing = true);
                    await _processOrder(dialogContext);
                    setState(() => _isProcessing = false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Confirmar Pedido', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _processOrder(BuildContext dialogContext) async {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is Authenticated;
    final cartState = context.read<CartBloc>().state;

    // Validar dirección
    if (_direccionController.text.trim().length < 5) {
      _showError(dialogContext, 'Por favor ingresa una dirección válida (mínimo 5 caracteres)');
      return;
    }

    // Validar datos de invitado si no está autenticado
    if (!isAuthenticated) {
      if (_nombreController.text.trim().isEmpty ||
          _apellidoController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _telefonoController.text.trim().isEmpty) {
        _showError(dialogContext, 'Por favor completa todos los campos requeridos');
        return;
      }

      // Validar formato de email
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(_emailController.text.trim())) {
        _showError(dialogContext, 'Por favor ingresa un email válido');
        return;
      }
    }

    // Preparar items para la orden
    final items = cartState.cart.items.map((item) {
      return {
        'product_id': item.id,
        'quantity': item.quantity,
      };
    }).toList();

    try {
      final api = ApiService();
      final orderData = await api.createOrder(
        items: items,
        direccion: _direccionController.text.trim(),
        guestNombre: !isAuthenticated ? _nombreController.text.trim() : null,
        guestApellido: !isAuthenticated ? _apellidoController.text.trim() : null,
        guestEmail: !isAuthenticated ? _emailController.text.trim() : null,
        guestTelefono: !isAuthenticated ? _telefonoController.text.trim() : null,
      );

      // Orden creada exitosamente
      if (!mounted) return;
      
      // Vaciar el carrito
      context.read<CartBloc>().add(ClearCart());
      
      // Cerrar diálogo
      Navigator.pop(dialogContext);

      // Mostrar mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 8),
              Text('¡Pedido Confirmado!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Código de orden: ${orderData['code']}'),
              const SizedBox(height: 8),
              Text('Total: \$${NumberFormat('#,###', 'es_CO').format(orderData['total'])}'),
              const SizedBox(height: 8),
              const Text(
                'Tu pedido ha sido registrado exitosamente. Recibirás confirmación pronto.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } on DataException catch (e) {
      _showError(dialogContext, e.message);
    } on NetworkException catch (e) {
      _showError(dialogContext, e.message);
    } catch (e) {
      _showError(dialogContext, 'Error inesperado: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final cartItems = state.cart.items;

         if (cartItems.isEmpty) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Imagen de carrito vacío
          Image.asset(
            'assets/carro_vacio.jpeg',
            width: 180,
            height: 180,
          ),
          const SizedBox(height: 24),

          // Texto principal
          Text(
            AppLocalizations.of(context)!.cartEmpty.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtexto
          Text(
            AppLocalizations.of(context)!.cartEmptyMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Botón para ir al menú
          SizedBox(
            width: 220,
            height: 50,
            child: ElevatedButton(
            onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ProductCatalogPage(initialIndex: 1), // 👈 abrir directo el Menú
    ),
  );
},

              style: ElevatedButton.styleFrom(
               backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                AppLocalizations.of(context)!.startShopping,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
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
                          child: Image.network(
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
                                Text('${AppLocalizations.of(context)!.quantity}: ${item.quantity}'),
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
                            '\$ ${NumberFormat('#,###', 'es_CO').format(item.price * item.quantity)} COP',
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
                  '${AppLocalizations.of(context)!.total}: \$ ${NumberFormat('#,###', 'es_CO').format(state.cart.totalPrice)} COP',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _showCheckoutDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Proceder al Pago',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}