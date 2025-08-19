import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'home_Page.dart';
import 'carrito_Page.dart';
import 'perfil_Page.dart';
import 'domicilio_Page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndex = 0;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 20),
                  _buildNavItem(
                    icon: Icons.restaurant_menu,
                    label: 'Menú',
                    index: 1,
                  ),
                  const SizedBox(width: 50),
                  _buildNavItem(
                    icon: Icons.shopping_cart,
                    label: 'Carrito',
                    index: 2,
                  ),
                ],
              ),
              Row(
                children: [

                _buildNavItem(
                    icon: Icons.delivery_dining, 
                    label: 'Domicilio', 
                    index: 4
                    ),

                  const SizedBox(width: 50),

                _buildNavItem(
                    icon: Icons.person,
                    label: 'Perfil',
                    index: 3,
                  ),

                SizedBox(width: 20),
                ],
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
