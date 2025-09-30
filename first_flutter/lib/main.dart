import 'package:first_flutter/pages/carrito_Page.dart';
import 'package:first_flutter/pages/login_page.dart';
import 'package:first_flutter/pages/menu_page.dart';
import 'package:first_flutter/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc/product_bloc.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/language_bloc.dart';
import 'bloc/language_event.dart';
import 'bloc/language_state.dart';
import 'bloc/categorias_bloc.dart';
import 'repository/product_repository.dart';
import 'repository/api_product_repository.dart'; // Nuevo repositorio
import 'pages/splash_page.dart';
import 'package:first_flutter/pages/inter_page.dart';
import 'l10n/app_localizations.dart';
import 'bloc/auth_bloc.dart';
import 'pages/perfil_wrapper.dart';
import 'service/ApiService.dart';

void main() {
  // Configuración de repositorio de productos
  final ProductRepository repository = ApiProductRepository();
  
  // Crear instancia del ApiService para categorías
  final ApiService apiService = ApiService();

  runApp(MyApp(repository: repository, apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;
  final ApiService apiService;

  const MyApp({super.key, required this.repository, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductBloc(repository)),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => LanguageBloc()..add(const LoadLanguage())),
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => CategoriasBloc(apiService)),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return MaterialApp(
            title: 'Restaurante',
            debugShowCheckedModeBanner: false,
            locale: languageState is LanguageLoaded ? languageState.locale : const Locale('es'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('es'), // Spanish
            ],
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
        
            initialRoute: '/',
            routes: {
              '/': (context) => SplashPage(key: UniqueKey()),
              '/menu': (context) => const MenuPage(),
              '/carrito': (context) => CarritoPage(key: UniqueKey()),
              "wrapper": (context) => const PerfilWrapper(),
               '/login': (context) => const  LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => const ProductPage(),
            },
          );
        },
      ),
    );
  }
}
