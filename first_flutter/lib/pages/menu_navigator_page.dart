import 'package:first_flutter/pages/search_results_page.dart';
import 'package:flutter/material.dart';
import 'menu_page.dart';

class MenuNavigator extends StatelessWidget {
  const MenuNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name){

          case '/search':
          page = const SearchResultsPage();
          break;

          case '/menu':

          default:
          page = const MenuPage();

        }

        return MaterialPageRoute(
          builder: (context) => page,
          settings: settings,
          );
        
      },
    );
  }
}
