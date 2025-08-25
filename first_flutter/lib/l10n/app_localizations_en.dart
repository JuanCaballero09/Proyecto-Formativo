// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Hello World';

  @override
  String get welcomeTitle => 'Welcome to Bitevia';

  @override
  String get welcomeSubtitle => 'Enjoy a Unique Experience!';

  @override
  String get loginButton => 'Log In';

  @override
  String get registerButton => 'Sign Up';

  @override
  String get appTitle => 'Restaurant';
}
