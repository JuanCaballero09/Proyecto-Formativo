import 'package:first_flutter/bloc/cart/cart_bloc.dart';
import 'package:first_flutter/pages/carrito_Page.dart';
import 'package:first_flutter/pages/domicilio_Page.dart';
import 'package:first_flutter/pages/home_Page.dart';
import 'package:first_flutter/pages/menu_navigator_page.dart';
import 'package:first_flutter/pages/perfil_Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';

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
    final pages = [
      HomePage(),
      MenuNavigator(),
      CarritoPage(),
      PerfilPage(),
      DomicilioPage()
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(237, 88, 33, 1),
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.restaurant_menu_rounded,
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

                return _buildNavItemWithBadge(
                  icon: Icons.shopping_cart_rounded,
                  label: AppLocalizations.of(context)!.cart,
                  index: 2,
                  badgeCount: cartCount,
                  isSelected: isSelected,
                );
              },
            ),
            _buildCenterHomeButton(),
            _buildNavItem(
              icon: Icons.delivery_dining_rounded,
              label: AppLocalizations.of(context)!.delivery,
              index: 4,
            ),
            _buildNavItem(
              icon: Icons.person_rounded,
              label: AppLocalizations.of(context)!.profile,
              index: 3,
            ),
          ],
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
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 65,
        height: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterHomeButton() {
    return InkWell(
      onTap: () => _onItemTapped(0),
      borderRadius: BorderRadius.circular(50),
      child: SizedBox(
        width: 70,
        height: 60,
        child: Center(
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.home_rounded,
              color: Color.fromRGBO(237, 88, 33, 1),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge({
    required IconData icon,
    required String label,
    required int index,
    required int badgeCount,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 65,
        height: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$badgeCount',
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
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
