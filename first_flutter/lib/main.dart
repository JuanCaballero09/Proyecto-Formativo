
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/product_bloc.dart';
import 'repository/product_repository.dart';
import 'repository/http_product_repository.dart';
import 'pages/product_page.dart';

void main() {
  const String apiUrl = 'https://run.mocky.io/v3/a667541a-2e6f-4de8-9431-d62ce7ffa590';
  final ProductRepository repository = HttpProductRepository(apiUrl: apiUrl);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Terraza Del Pri',
      theme: ThemeData(
        primaryColor: Colors.amber[800],
        scaffoldBackgroundColor: Colors.amber[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber[800],
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: BlocProvider(
        create: (_) => ProductBloc(repository),
        child: const ProductPage(),
      ),
    );
  }
}
