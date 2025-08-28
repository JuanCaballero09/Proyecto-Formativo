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
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color.fromRGBO(237, 88, 33, 1),
        child: SizedBox(
          height: 40, 
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

                  const SizedBox(width: 48,),


                _buildNavItem(
                    icon: Icons.delivery_dining, 
                    label: AppLocalizations.of(context)!.delivery, 
                    index: 4
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? Colors.black : Colors.black,
              size: 32,
            ),
            onPressed: () => _onItemTapped(0),
          ),
          const SizedBox(height: 4),

        ],
      ),
    );
  }

  // Método reutilizable para los íconos del BottomAppBar
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
            Icon(icon, color: isSelected ? Colors.black : Colors.white),
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
}
