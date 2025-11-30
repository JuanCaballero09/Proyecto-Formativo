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

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 16,
                vertical: 24,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: bgColorLocal,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                          ? Colors.black.withOpacity(0.5)
                          : Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(237, 88, 33, 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            AppLocalizations.of(context)!.finalizeOrderDialogTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header con contador de productos
                              Row(
                                children: [
                                  const Icon(
                                    Icons.shopping_bag_rounded,
                                    color: Color.fromRGBO(237, 88, 33, 1),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${state.cart.items.length} ${state.cart.items.length == 1 ? AppLocalizations.of(context)!.productCountSingular : AppLocalizations.of(context)!.productCountPlural}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Formulario
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Dirección
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_rounded,
                                          color: Color.fromRGBO(237, 88, 33, 1),
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          AppLocalizations.of(context)!.deliveryAddressLabel,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: isDark ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    TextField(
                                      controller: _direccionController,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!.exampleAddressHint,
                                        hintStyle: TextStyle(
                                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                                        ),
                                        filled: true,
                                        fillColor: isDark
                                            ? const Color(0xFF1E1E1E)
                                            : Colors.white,
                                        contentPadding: const EdgeInsets.all(16),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color.fromRGBO(237, 88, 33, 1),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // SOLO INVITADOS
                                    if (!isAuthenticated) ...[
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person_rounded,
                                            color: Color.fromRGBO(237, 88, 33, 1),
                                            size: 22,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            AppLocalizations.of(context)!.personalInfoLabel,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _nombreController,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: isDark ? Colors.white : Colors.black87,
                                              ),
                                              decoration: InputDecoration(
                                                labelText: AppLocalizations.of(context)!.nameLabel,
                                                labelStyle: TextStyle(
                                                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                                                ),
                                                filled: true,
                                                fillColor: isDark
                                                    ? const Color(0xFF1E1E1E)
                                                    : Colors.white,
                                                contentPadding: const EdgeInsets.all(16),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                                    width: 1,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(237, 88, 33, 1),
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: TextField(
                                              controller: _apellidoController,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: isDark ? Colors.white : Colors.black87,
                                              ),
                                              decoration: InputDecoration(
                                                labelText: AppLocalizations.of(context)!.lastNameLabel,
                                                labelStyle: TextStyle(
                                                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                                                ),
                                                filled: true,
                                                fillColor: isDark
                                                    ? const Color(0xFF1E1E1E)
                                                    : Colors.white,
                                                contentPadding: const EdgeInsets.all(16),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                                    width: 1,
                                                  ),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                    color: Color.fromRGBO(237, 88, 33, 1),
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(context)!.email,
                                          hintText: AppLocalizations.of(context)!.exampleEmailHint,
                                          labelStyle: TextStyle(
                                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                                          ),
                                          hintStyle: TextStyle(
                                            color: isDark ? Colors.grey[600] : Colors.grey[400],
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? const Color(0xFF1E1E1E)
                                              : Colors.white,
                                          prefixIcon: Icon(
                                            Icons.email_rounded,
                                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                                            size: 20,
                                          ),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(237, 88, 33, 1),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: _telefonoController,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(context)!.phoneLabel,
                                          hintText: AppLocalizations.of(context)!.phoneExampleHint,
                                          labelStyle: TextStyle(
                                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                                          ),
                                          hintStyle: TextStyle(
                                            color: isDark ? Colors.grey[600] : Colors.grey[400],
                                          ),
                                          filled: true,
                                          fillColor: isDark
                                              ? const Color(0xFF1E1E1E)
                                              : Colors.white,
                                          prefixIcon: Icon(
                                            Icons.phone_rounded,
                                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                                            size: 20,
                                          ),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color.fromRGBO(237, 88, 33, 1),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Botones de acción
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark 
                      ? const Color(0xFF1E1E1E)
                      : Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isProcessing ? null : () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.cancelLabel,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  setState(() => _isProcessing = true);
                                  await _processOrder(dialogContext);
                                  setState(() => _isProcessing = false);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.confirmOrderLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

          final isDark = Theme.of(context).brightness == Brightness.dark;
          
          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen con badge de cantidad
                      Stack(
                        children: [
                          if (item.image != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromRGBO(237, 88, 33, 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  item.image!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          // Badge con cantidad
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(237, 88, 33, 1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(237, 88, 33, 0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      // Info del producto
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (item.description != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                item.description!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 12),
                            // Precio unitario
                            Text(
                              '\$${NumberFormat('#,###', 'es_CO').format(item.price)} c/u',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Controles de cantidad
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDark 
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: item.quantity > 1
                                              ? const Color.fromRGBO(237, 88, 33, 1)
                                              : Colors.grey,
                                          size: 22,
                                        ),
                                        onPressed: item.quantity > 1
                                            ? () {
                                                context.read<CartBloc>().add(
                                                      UpdateCartItemQuantity(
                                                          item.id, item.quantity - 1),
                                                    );
                                              }
                                            : null,
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: Text(
                                          '${item.quantity}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: isDark ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle,
                                          color: Color.fromRGBO(237, 88, 33, 1),
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                                UpdateCartItemQuantity(
                                                    item.id, item.quantity + 1),
                                              );
                                        },
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                // Precio total del item
                                Text(
                                  '\$${NumberFormat('#,###', 'es_CO').format(item.price * item.quantity)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color.fromRGBO(237, 88, 33, 1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Botón eliminar
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: isDark ? Colors.red[300] : Colors.red[400],
                          size: 24,
                        ),
                        onPressed: () {
                          context.read<CartBloc>().add(RemoveFromCart(item.id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              duration: const Duration(seconds: 2),
                              content: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Producto eliminado',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final cartItems = state.cart.items;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          if (cartItems.isEmpty) return const SizedBox.shrink();

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        const Color(0xFF1E1E1E).withOpacity(0.95),
                        const Color(0xFF1E1E1E),
                      ]
                    : [
                        Colors.white.withOpacity(0.95),
                        Colors.white,
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Resumen del total
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(237, 88, 33, 0.1),
                            Color.fromRGBO(237, 88, 33, 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color.fromRGBO(237, 88, 33, 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.totalToPayTitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${NumberFormat('#,###', 'es_CO').format(state.cart.totalPrice)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(237, 88, 33, 1),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(237, 88, 33, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${cartItems.length} ${cartItems.length == 1 ? AppLocalizations.of(context)!.itemSingular : AppLocalizations.of(context)!.itemPlural}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botones de acción
                    Row(
                      children: [
                        // Botón Vaciar Carrito
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
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
                                        color: Colors.red[400],
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.4),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.check_circle,
                                              color: Colors.white, size: 22),
                                          SizedBox(width: 10),
                                          Text(
                                            'Carrito vacío',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
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
                              backgroundColor: isDark
                                  ? const Color(0xFF2C2C2C)
                                  : Colors.white,
                              foregroundColor: Colors.red[400],
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                    color: Colors.red[400]!, width: 2),
                              ),
                            ),
                            child: Icon(Icons.delete_outline,
                                size: 24, color: Colors.red[400]),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Botón Proceder al Pago
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(237, 88, 33, 1),
                                  Color.fromRGBO(255, 110, 50, 1),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromRGBO(237, 88, 33, 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => _showCheckoutDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.proceedToPayment,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward_rounded,
                                      color: Colors.white, size: 22),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
