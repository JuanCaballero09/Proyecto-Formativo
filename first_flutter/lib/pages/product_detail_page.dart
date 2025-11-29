import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../bloc/cart/cart_bloc.dart';
import '../models/cart_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  void _showCartNotification(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Añadido con éxito',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 2500), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Debug prints removed - avoid logging user-facing details in production

    // El tema se maneja vía ThemeData; los estilos de texto usan textTheme

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.productDetails,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  product.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Theme.of(context).disabledColor),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[800],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '\$ ${NumberFormat('#,###', 'es_CO').format(product.price)} COP',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart_checkout_rounded),
                  label: Text(AppLocalizations.of(context)!.addToCart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    context.read<CartBloc>().add(
                          AddToCart(
                            CartItem(
                              id: product.id.toString(),
                              name: product.name,
                              price: product.price,
                              quantity: 1,
                              image: product.image,
                              description: product.description,
                            ),
                          ),
                        );

                    _showCartNotification(context);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.description, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.description,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 👇 Aquí se cambia el color de la descripción si está en modo oscuro
              Text(
                product.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 16),
                textAlign: TextAlign.justify,
              ),

              if (product.ingredients.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.restaurant, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.ingredients,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]
                        : Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.amber[700]!
                          : Colors.amber[200]!,
                      width: 1,
                    ),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.ingredients.map((ingredient) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.amber[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber[600]!
                                : Colors.amber[300]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          ingredient,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.amber[400]
                                : Colors.amber[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
