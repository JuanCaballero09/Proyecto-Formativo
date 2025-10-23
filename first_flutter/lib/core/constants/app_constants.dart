/// Constantes globales de la aplicación
class AppConstants {
  // Prevenir instanciación
  AppConstants._();

  // Configuración general
  static const String appName = 'BiteVia';
  static const String appVersion = '1.0.0';

  // Tiempos de espera
  static const int apiTimeoutSeconds = 30;
  static const int splashDurationSeconds = 3;

  // Límites
  static const int maxCartItems = 99;
  static const int maxSearchHistoryItems = 10;

  // Valores por defecto
  static const String defaultLanguage = 'es';
  static const String defaultCurrency = 'COP';

  // Ubicación por defecto (Barranquilla)
  static const double defaultLatitude = 10.96854;
  static const double defaultLongitude = -74.78132;
}
