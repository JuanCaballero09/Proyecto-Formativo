import 'package:first_flutter/pages/product_catalog_page.dart';
import 'package:first_flutter/pages/payment_method_selection_page.dart';
import 'package:first_flutter/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isCheckingAuth = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      // Verificar si hay token almacenado
      final api = ApiService();
      final token = await api.storage.read(key: 'token');
      
      // Verificar el estado del AuthBloc
      final authState = context.read<AuthBloc>().state;
      final isAuthenticatedByBloc = authState is Authenticated;
      
      // Considerar autenticado si hay token O si el AuthBloc indica autenticación
      final hasValidSession = token != null || isAuthenticatedByBloc;
      
      if (mounted) {
        setState(() {
          _isAuthenticated = hasValidSession;
          _isCheckingAuth = false;
        });
      }
    } catch (e) {
      // En caso de error, asumir no autenticado
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isCheckingAuth = false;
        });
      }
    }
  }

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
    // Usar la variable de estado en lugar de leer el BLoC de nuevo
    final isAuthenticated = _isAuthenticated;

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
            final theme = Theme.of(context);
            final bool isDark = theme.brightness == Brightness.dark;
            final Color bgColorLocal = theme.colorScheme.surface;
            final Color fill = isDark ? const Color(0xFF1E1E1E) : Colors.white;
            final Color shadowColor = isDark ? Colors.black45 : Colors.black12;

            return AlertDialog(
              backgroundColor: bgColorLocal,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 10), // MÁS ANCHO
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              titlePadding: const EdgeInsets.all(20),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

              title: Row(
                children: [
                  Icon(Icons.shopping_bag,
                      color: Color.fromRGBO(237, 88, 33, 1), size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Finalizar Pedido',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),

              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bgColorLocal,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color.fromRGBO(237, 88, 33, 1),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.shopping_cart,
                                      size: 26,
                                      color: Color.fromRGBO(237, 88, 33, 1)),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${state.cart.items.length} productos',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // ⭐ FORMULARIO ENSANCHADO Y CORRECTO
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    0.85, // ⭐ MÁS ANCHO
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: bgColorLocal,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Dirección
                                    const Text(
                                      '📍 Dirección de Entrega',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    TextField(
                                      controller: _direccionController,
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Ej: Calle 123 #45-67, Bogotá',
                                        filled: true,
                                        fillColor: fill,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 18,
                                          horizontal: 16,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromRGBO(237, 88, 33, 1),
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromRGBO(237, 88, 33, 1),
                                            width: 2.5,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // SOLO INVITADOS
                                    if (!isAuthenticated) ...[
                                      const Text(
                                        '👤 Información Personal',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _nombreController,
                                              decoration: InputDecoration(
                                                labelText: "Nombre",
                                                filled: true,
                                                fillColor: fill,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 18,
                                                  horizontal: 16,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        237, 88, 33, 1),
                                                    width: 2,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        237, 88, 33, 1),
                                                    width: 2.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: TextField(
                                              controller: _apellidoController,
                                              decoration: InputDecoration(
                                                labelText: "Apellido",
                                                filled: true,
                                                fillColor: fill,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 18,
                                                  horizontal: 16,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        237, 88, 33, 1),
                                                    width: 2,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        237, 88, 33, 1),
                                                    width: 2.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      TextField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: "Email",
                                          hintText: "ejemplo@correo.com",
                                          filled: true,
                                          fillColor: fill,
                                          prefixIcon:
                                              const Icon(Icons.email, size: 22),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 18,
                                            horizontal: 16,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  237, 88, 33, 1),
                                              width: 2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  237, 88, 33, 1),
                                              width: 2.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      TextField(
                                        controller: _telefonoController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        decoration: InputDecoration(
                                          labelText: "Teléfono",
                                          hintText: "Ej: 3001234567",
                                          filled: true,
                                          fillColor: fill,
                                          prefixIcon:
                                              const Icon(Icons.phone, size: 22),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 18,
                                            horizontal: 16,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  237, 88, 33, 1),
                                              width: 2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(
                                                  237, 88, 33, 1),
                                              width: 2.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                    ],
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.all(16),

              actions: [
                TextButton(
                  onPressed:
                      _isProcessing ? null : () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : () async {
                          setState(() => _isProcessing = true);
                          await _processOrder(dialogContext);
                          setState(() => _isProcessing = false);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Confirmar Pedido',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ignore: unused_element
  Widget _buildInput({
    required TextEditingController controller,
    String? label,
    String? hint,
    IconData? prefix,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 17),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 17),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        prefixIcon: prefix != null
            ? Icon(prefix, size: 24, color: Color.fromRGBO(237, 88, 33, 1))
            : null,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14), // MÁS BAJITO
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(237, 88, 33, 1),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(237, 88, 33, 1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> _processOrder(BuildContext dialogContext) async {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is Authenticated;
    final cartState = context.read<CartBloc>().state;

    // Validar dirección
    if (_direccionController.text.trim().length < 5) {
      _showError(context, AppLocalizations.of(context)!.invalidAddress);
      return;
    }

    // Validar datos de invitado si no está autenticado
    if (!isAuthenticated) {
      if (_nombreController.text.trim().isEmpty ||
          _apellidoController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _telefonoController.text.trim().isEmpty) {
        _showError(
            context, AppLocalizations.of(context)!.completeAllFields);
        return;
      }

      // Validar formato de email (debe tener @ y un dominio válido)
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
      if (!emailRegex.hasMatch(_emailController.text.trim())) {
        _showError(
            context, 'Email inválido. Debe contener @ y un dominio válido (ej: .com, .co)');
        return;
      }

      // Validar teléfono (10 dígitos que comience con 3)
      final phone = _telefonoController.text.trim();
      if (phone.length != 10) {
        _showError(context, 'El teléfono debe tener exactamente 10 dígitos');
        return;
      }
      if (!phone.startsWith('3')) {
        _showError(context, 'El teléfono debe comenzar con 3 (números celulares)');
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
        guestApellido:
            !isAuthenticated ? _apellidoController.text.trim() : null,
        guestEmail: !isAuthenticated ? _emailController.text.trim() : null,
        guestTelefono:
            !isAuthenticated ? _telefonoController.text.trim() : null,
      );

      // Orden creada exitosamente
      if (!mounted) return;

      // Cerrar diálogo
      Navigator.pop(dialogContext);

      // Crear objeto Order
      final order = Order(
        code: orderData['code'],
        total: (orderData['total'] as num).toDouble(),
        status: orderData['status'] ?? 'pending',
        customerEmail: _emailController.text.trim(),
        address: _direccionController.text.trim(),
      );

      // Vaciar el carrito
      context.read<CartBloc>().add(ClearCart());

      // Navegar a selección de método de pago
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethodSelectionPage(order: order),
        ),
      );
    } on DataException catch (e) {
      _showError(context, e.message);
    } on NetworkException catch (e) {
      _showError(context, e.message);
    } catch (e) {
      _showError(
          context, '${AppLocalizations.of(context)!.unknownError}: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    // Usar ScaffoldMessenger es más seguro y no causa conflictos con el overlay
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar loading mientras verifica autenticación
    if (_isCheckingAuth) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(237, 88, 33, 1),
          ),
        ),
      );
    }

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
                      'assets/carro_vacio.png',
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 16),
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
                              builder: (context) => ProductCatalogPage(
                                  initialIndex: 1), // 👈 abrir directo el Menú
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 13),
                                ),
                              ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          UpdateCartItemQuantity(
                                              item.id, item.quantity - 1),
                                        );
                                  },
                                ),
                                Text(
                                    '${AppLocalizations.of(context)!.quantity}: ${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                          UpdateCartItemQuantity(
                                              item.id, item.quantity + 1),
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
                            icon: Icon(Icons.delete,
                                color: Theme.of(context).colorScheme.error),
                            onPressed: () {
                              context
                                  .read<CartBloc>()
                                  .add(RemoveFromCart(item.id));
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
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 14),

                // ⭐ BOTONES (Vaciar y Proceder)

                Row(
                  children: [
                    // 🔴 BOTÓN MINI DE VACIAR
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartBloc>().add(ClearCart());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              duration: const Duration(seconds: 2),
                              content: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.redAccent.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.error_outline,
                                          color: Colors.white, size: 22),
                                      SizedBox(width: 10),
                                      Text(
                                        'Carrito vacío',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.redAccent,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Colors.redAccent, width: 1.5),
                          ),
                        ),
                        child: const Icon(Icons.delete,
                            size: 22, color: Colors.redAccent),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 🟠 BOTÓN PROCEDER AL PAGO (GRANDE)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showCheckoutDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Proceder al Pago',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
