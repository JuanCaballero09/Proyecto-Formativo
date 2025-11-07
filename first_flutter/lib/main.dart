import 'package:first_flutter/pages/carrito_page.dart';
import 'package:first_flutter/pages/login_page.dart';
import 'package:first_flutter/pages/menu_page.dart';
import 'package:first_flutter/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bloc/theme/theme_bloc.dart';
import 'core/theme/app_theme.dart';
import 'bloc/product/product_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/language/language_bloc.dart';
import 'bloc/language/language_event.dart';
import 'bloc/language/language_state.dart';
import 'bloc/categorias/categorias_bloc.dart';
import 'bloc/search/search_bloc.dart';
import 'repository/product_repository.dart';
import 'repository/api_product_repository.dart';
import 'pages/splash_page.dart';
import 'package:first_flutter/pages/product_catalog_page.dart';
import 'l10n/app_localizations.dart';
import 'bloc/auth/auth_bloc.dart';
import 'pages/perfil_wrapper.dart';
import 'service/api_service.dart';

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
        BlocProvider(create: (_) => SearchBloc(apiService)),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: 'Restaurante',
                debugShowCheckedModeBanner: false,
                locale: languageState is LanguageLoaded
                    ? languageState.locale
                    : const Locale('es'),
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
                theme: themeState.isDarkMode
                    ? AppTheme.darkTheme
                    : AppTheme.lightTheme,
                initialRoute: '/',
                routes: {
                  '/': (context) => SplashPage(key: UniqueKey()),
                  '/menu': (context) => const MenuPage(),
                  '/carrito': (context) => CarritoPage(key: UniqueKey()),
                  "wrapper": (context) => const PerfilWrapper(),
                  '/login': (context) => const LoginPage(),
                  '/register': (context) => const RegisterPage(),
                  '/home': (context) => const ProductCatalogPage(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
