import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../bloc/cart_bloc.dart';
import '../models/cart_model.dart';
import 'pedido_Page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.productDetails),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
        elevation: 0,
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
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.grey)
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
              Row(
                children: [
                  const Icon(Icons.description, color: Colors.amber),
                  const SizedBox(width: 8),
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
              
              // Sección de ingredientes
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
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber[200]!,
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
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.amber[300]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          ingredient,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart_checkout_rounded),
                  label: Text(AppLocalizations.of(context)!.addToCart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
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

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center( 
                          child: Text('Añadido Con Exito', style: TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.bold, color: Colors.black),),
                      
                        ),

                        backgroundColor: const Color.fromARGB(255, 113, 219, 140),
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: 10,
                          left: 100,
                          right: 100,
                        ),
                        shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(10),

                        ),

                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
