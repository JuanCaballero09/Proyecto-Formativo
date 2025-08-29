import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'menu_page.dart';
import 'home_Page.dart';
import 'carrito_Page.dart';
import 'perfil_Page.dart';
import 'domicilio_Page.dart';

class ProductPage extends StatefulWidget {
  final int initialIndex;
  const ProductPage({super.key, this.initialIndex = 0});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
    final pages = [HomePage(), MenuPage(), CarritoPage(), PerfilPage(), DomicilioPage()];

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
              _buildNavItem(
                icon: Icons.shopping_cart,
                label: AppLocalizations.of(context)!.cart,
                index: 2,
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