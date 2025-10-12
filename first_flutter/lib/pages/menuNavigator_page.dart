import 'package:flutter/material.dart';
import 'menu_page.dart';

class MenuNavigator extends StatelessWidget {
  const MenuNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const MenuPage(),
        );
      },
    );
  }
}
