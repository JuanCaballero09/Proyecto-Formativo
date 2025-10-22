import 'package:first_flutter/bloc/cart/cart_bloc.dart';
import 'package:first_flutter/pages/menu_navigator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import 'home_page.dart';
import 'carrito_page.dart';
import 'perfil_page.dart';
import 'domicilio_page.dart';

class ProductCatalogPage extends StatefulWidget {
  final int initialIndex;
  const ProductCatalogPage({super.key, this.initialIndex = 0});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [HomePage(), MenuNavigator(), CarritoPage(), PerfilPage(), DomicilioPage()];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(237, 88, 33, 1),
        child: SizedBox(
          height: 70,  // altura mayor para que el botón quepa bien
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.restaurant_menu,
                label: AppLocalizations.of(context)!.menu,
                index: 1,
              ),
   BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  final cartCount = state.cart.items.fold<int>(
                    0,
                    (sum, item) => sum + item.quantity,
                  );

                  final isSelected = _selectedIndex == 2;

                  return InkWell(
                    onTap: () => _onItemTapped(2),
                    child: SizedBox(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                color: isSelected ? Colors.black : Colors.white,
                                size: 24,
                              ),
                              if (cartCount > 0)
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '$cartCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppLocalizations.of(context)!.cart,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              _buildCenterHomeButton(),
              _buildNavItem(
                icon: Icons.delivery_dining,
                label: AppLocalizations.of(context)!.delivery,
                index: 4,
              ),
              _buildNavItem(
                icon: Icons.person,
                label: AppLocalizations.of(context)!.profile,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Aquí defines el método _buildNavItem
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Y también aquí tu botón central personalizado
  Widget _buildCenterHomeButton() {
    final isSelected = _selectedIndex == 0;

    return InkWell(
      onTap: () => _onItemTapped(0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.orange.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 28,
              color: Colors.black,
            ),
            Text(
              AppLocalizations.of(context)!.home,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}