import 'package:flutter/material.dart';
import 'login_page.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';



class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _changeLanguage(BuildContext context, String value) {
    Locale newLocale = value == 'es' ? const Locale('es') : const Locale('en');
    final provider = LanguageProvider.of(context);
    if (provider != null) {
      provider.changeLanguage(newLocale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              _changeLanguage(context, value);
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
      backgroundColor: const Color.fromRGBO(237, 88, 33, 1), // Fondo naranja
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen del logo
              Image.asset(
                'assets/imagen6.png', // Asegúrate que esté en assets
                height: 210,
              ),

              // Texto del título
              Text(
                AppLocalizations.of(context)!.welcomeTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily:'Arial', color: Colors.white),
              ),
  

              Text(
                AppLocalizations.of(context)!.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontFamily:'Arial', color: Colors.white),
              ),
              const SizedBox(height: 15),

              // Botón Iniciar Sesión
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.loginButton,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Botón Registrarse
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                    // A futuro: Navegar a RegisterPage()
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.registerButton,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
