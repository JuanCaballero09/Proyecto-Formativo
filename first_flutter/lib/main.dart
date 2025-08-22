import 'package:first_flutter/pages/carrito_Page.dart';
import 'package:first_flutter/pages/menu_page.dart';
import 'package:first_flutter/pages/welcome_page.dart';
import 'package:first_flutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/product_bloc.dart';
import 'bloc/cart_bloc.dart';
import 'repository/product_repository.dart';
//import 'repository/http_product_repository.dart';
import 'repository/mocki_product_repository.dart';
import 'pages/splash_page.dart';
import 'package:first_flutter/pages/register_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  // Para usar datos locales, descomenta la siguiente línea y comenta la de HttpProductRepository:
  final ProductRepository repository = MockiProductRepository();
  //const String apiUrl = 'https://64e8e7e299cf45b15fdffb7e.mockapi.io/api/v1/products';
  //final ProductRepository repository = HttpProductRepository(apiUrl: apiUrl);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatefulWidget {
  final ProductRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductBloc(widget.repository)),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'Restaurante',
        debugShowCheckedModeBanner: false,
        locale: _locale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            brightness: Brightness.light,
            primary: Colors.amber[800]!,
            secondary: Colors.deepOrangeAccent,
            surface: Colors.white,
            surfaceVariant: Colors.amber[50]!,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
            onSurfaceVariant: Colors.black,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.amber),
            titleTextStyle: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              elevation: 2,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.amber),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.amber, width: 2),
            ),
            labelStyle: const TextStyle(color: Colors.amber),
          ),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(key: UniqueKey()),
          '/menu': (context) => const MenuPage(),
          '/carrito': (context) => CarritoPage(key: UniqueKey()),
          '/welcome': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => BlocProvider.value(
            value: BlocProvider.of<ProductBloc>(context),
            child: WelcomePage(), // o HomePage()
          ),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  const MyHomePage({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    String title = Intl.message('Hello World', name: 'title');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'es') {
                onLocaleChange(const Locale('es'));
              } else {
                onLocaleChange(const Locale('en'));
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem(
                value: 'es',
                child: Text('Español'),
              ),
            ],
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
