import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @welcomeTitle.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido A Bitevia'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'¡Disfruta De Una Experiencia Única!'**
  String get welcomeSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerButton;

  /// No description provided for @emailRequired.
  ///
  /// In es, this message translates to:
  /// **'El correo electrónico es requerido'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un correo electrónico válido'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es requerida'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get passwordMinLength;

  /// No description provided for @welcomeBack.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido!'**
  String get welcomeBack;

  /// No description provided for @wrongCredentials.
  ///
  /// In es, this message translates to:
  /// **'Usuario o contraseña incorrectos'**
  String get wrongCredentials;

  /// No description provided for @connectionError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. Inténtalo de nuevo.'**
  String get connectionError;

  /// No description provided for @backTooltip.
  ///
  /// In es, this message translates to:
  /// **'Regresar'**
  String get backTooltip;

  /// No description provided for @loadingMessage.
  ///
  /// In es, this message translates to:
  /// **'Tus antojos los verás pronto...'**
  String get loadingMessage;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get login;

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get searchHint;

  /// No description provided for @promotions.
  ///
  /// In es, this message translates to:
  /// **'Promociones'**
  String get promotions;

  /// No description provided for @newItems.
  ///
  /// In es, this message translates to:
  /// **'Novedades'**
  String get newItems;

  /// No description provided for @newBadge.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get newBadge;

  /// No description provided for @ourMenu.
  ///
  /// In es, this message translates to:
  /// **'NUESTRO MENÚ'**
  String get ourMenu;

  /// No description provided for @menuSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una categoría para ver todos nuestros productos'**
  String get menuSubtitle;

  /// No description provided for @pizza.
  ///
  /// In es, this message translates to:
  /// **'PIZZA'**
  String get pizza;

  /// No description provided for @hamburger.
  ///
  /// In es, this message translates to:
  /// **'HAMBURGUESA'**
  String get hamburger;

  /// No description provided for @taco.
  ///
  /// In es, this message translates to:
  /// **'TACO'**
  String get taco;

  /// No description provided for @salad.
  ///
  /// In es, this message translates to:
  /// **'ENSALADA'**
  String get salad;

  /// No description provided for @salsichipapa.
  ///
  /// In es, this message translates to:
  /// **'SALCHIPAPA'**
  String get salsichipapa;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @menu.
  ///
  /// In es, this message translates to:
  /// **'Menú'**
  String get menu;

  /// No description provided for @cart.
  ///
  /// In es, this message translates to:
  /// **'Carrito'**
  String get cart;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @orders.
  ///
  /// In es, this message translates to:
  /// **'Pedidos'**
  String get orders;

  /// No description provided for @notifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notifications;

  /// No description provided for @location.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get location;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @confirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPassword;

  /// No description provided for @nameRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre es requerido'**
  String get nameRequired;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsNoMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsNoMatch;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta?'**
  String get alreadyHaveAccount;

  /// No description provided for @shoppingCart.
  ///
  /// In es, this message translates to:
  /// **'Carrito de Compras'**
  String get shoppingCart;

  /// No description provided for @emptyCart.
  ///
  /// In es, this message translates to:
  /// **'Tu carrito está vacío'**
  String get emptyCart;

  /// No description provided for @emptyCartSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Explora nuestro menú y empieza a pedir'**
  String get emptyCartSubtitle;

  /// No description provided for @addFood.
  ///
  /// In es, this message translates to:
  /// **'Agregar comida'**
  String get addFood;

  /// No description provided for @clearCart.
  ///
  /// In es, this message translates to:
  /// **'Vaciar Carrito'**
  String get clearCart;

  /// No description provided for @cartCleared.
  ///
  /// In es, this message translates to:
  /// **'Carrito vaciado'**
  String get cartCleared;

  /// No description provided for @addToCart.
  ///
  /// In es, this message translates to:
  /// **'Agregar al carrito'**
  String get addToCart;

  /// No description provided for @removeFromCart.
  ///
  /// In es, this message translates to:
  /// **'Eliminar del carrito'**
  String get removeFromCart;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @subtotal.
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @quantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get price;

  /// No description provided for @checkout.
  ///
  /// In es, this message translates to:
  /// **'Proceder al pago'**
  String get checkout;

  /// No description provided for @continueShopping.
  ///
  /// In es, this message translates to:
  /// **'Seguir comprando'**
  String get continueShopping;

  /// No description provided for @addedToCart.
  ///
  /// In es, this message translates to:
  /// **'Agregado al carrito'**
  String get addedToCart;

  /// No description provided for @categories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// No description provided for @allCategories.
  ///
  /// In es, this message translates to:
  /// **'Todas las categorías'**
  String get allCategories;

  /// No description provided for @burgers.
  ///
  /// In es, this message translates to:
  /// **'Hamburguesas'**
  String get burgers;

  /// No description provided for @pizzas.
  ///
  /// In es, this message translates to:
  /// **'Pizzas'**
  String get pizzas;

  /// No description provided for @salads.
  ///
  /// In es, this message translates to:
  /// **'Ensaladas'**
  String get salads;

  /// No description provided for @tacos.
  ///
  /// In es, this message translates to:
  /// **'Tacos'**
  String get tacos;

  /// No description provided for @drinks.
  ///
  /// In es, this message translates to:
  /// **'Bebidas'**
  String get drinks;

  /// No description provided for @desserts.
  ///
  /// In es, this message translates to:
  /// **'Postres'**
  String get desserts;

  /// No description provided for @myProfile.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @personalInfo.
  ///
  /// In es, this message translates to:
  /// **'Información personal'**
  String get personalInfo;

  /// No description provided for @firstName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get lastName;

  /// No description provided for @phone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// No description provided for @changePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuraciones'**
  String get settings;

  /// No description provided for @myOrders.
  ///
  /// In es, this message translates to:
  /// **'Mis pedidos'**
  String get myOrders;

  /// No description provided for @orderHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de pedidos'**
  String get orderHistory;

  /// No description provided for @orderNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de pedido'**
  String get orderNumber;

  /// No description provided for @orderDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha del pedido'**
  String get orderDate;

  /// No description provided for @orderStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado del pedido'**
  String get orderStatus;

  /// No description provided for @orderTotal.
  ///
  /// In es, this message translates to:
  /// **'Total del pedido'**
  String get orderTotal;

  /// No description provided for @pending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pending;

  /// No description provided for @processing.
  ///
  /// In es, this message translates to:
  /// **'En proceso'**
  String get processing;

  /// No description provided for @preparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando'**
  String get preparing;

  /// No description provided for @ready.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get ready;

  /// No description provided for @delivered.
  ///
  /// In es, this message translates to:
  /// **'Entregado'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get cancelled;

  /// No description provided for @viewDetails.
  ///
  /// In es, this message translates to:
  /// **'Ver detalles'**
  String get viewDetails;

  /// No description provided for @reorder.
  ///
  /// In es, this message translates to:
  /// **'Volver a pedir'**
  String get reorder;

  /// No description provided for @delivery.
  ///
  /// In es, this message translates to:
  /// **'Domicilio'**
  String get delivery;

  /// No description provided for @deliveryInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de entrega'**
  String get deliveryInfo;

  /// No description provided for @deliveryAddress.
  ///
  /// In es, this message translates to:
  /// **'Dirección de entrega'**
  String get deliveryAddress;

  /// No description provided for @deliveryTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo de entrega'**
  String get deliveryTime;

  /// No description provided for @estimatedTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo estimado'**
  String get estimatedTime;

  /// No description provided for @contactInfo.
  ///
  /// In es, this message translates to:
  /// **'Información de contacto'**
  String get contactInfo;

  /// No description provided for @specialInstructions.
  ///
  /// In es, this message translates to:
  /// **'Instrucciones especiales'**
  String get specialInstructions;

  /// No description provided for @noSpecialInstructions.
  ///
  /// In es, this message translates to:
  /// **'Sin instrucciones especiales'**
  String get noSpecialInstructions;

  /// No description provided for @myLocation.
  ///
  /// In es, this message translates to:
  /// **'Mi ubicación'**
  String get myLocation;

  /// No description provided for @currentLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación actual'**
  String get currentLocation;

  /// No description provided for @selectLocation.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar ubicación'**
  String get selectLocation;

  /// No description provided for @useCurrentLocation.
  ///
  /// In es, this message translates to:
  /// **'Usar ubicación actual'**
  String get useCurrentLocation;

  /// No description provided for @searchAddress.
  ///
  /// In es, this message translates to:
  /// **'Buscar dirección'**
  String get searchAddress;

  /// No description provided for @noNotifications.
  ///
  /// In es, this message translates to:
  /// **'No hay notificaciones'**
  String get noNotifications;

  /// No description provided for @markAllRead.
  ///
  /// In es, this message translates to:
  /// **'Marcar todas como leídas'**
  String get markAllRead;

  /// No description provided for @newOrderAlert.
  ///
  /// In es, this message translates to:
  /// **'Nueva alerta de pedido'**
  String get newOrderAlert;

  /// No description provided for @orderUpdate.
  ///
  /// In es, this message translates to:
  /// **'Actualización de pedido'**
  String get orderUpdate;

  /// No description provided for @promotion.
  ///
  /// In es, this message translates to:
  /// **'Promoción'**
  String get promotion;

  /// No description provided for @general.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// No description provided for @ingredients.
  ///
  /// In es, this message translates to:
  /// **'Ingredientes'**
  String get ingredients;

  /// No description provided for @productDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles del producto'**
  String get productDetails;

  /// No description provided for @selectQuantity.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar cantidad'**
  String get selectQuantity;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @accept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @yes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In es, this message translates to:
  /// **'Advertencia'**
  String get warning;

  /// No description provided for @information.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get information;

  /// No description provided for @tryAgain.
  ///
  /// In es, this message translates to:
  /// **'Intentar de nuevo'**
  String get tryAgain;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar idioma'**
  String get selectLanguage;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @languageChanged.
  ///
  /// In es, this message translates to:
  /// **'Idioma cambiado exitosamente'**
  String get languageChanged;

  /// No description provided for @hello.
  ///
  /// In es, this message translates to:
  /// **'HOLA'**
  String get hello;

  /// No description provided for @account.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get account;

  /// No description provided for @registrationSuccessful.
  ///
  /// In es, this message translates to:
  /// **'¡Registro exitoso!'**
  String get registrationSuccessful;

  /// No description provided for @orderPlaced.
  ///
  /// In es, this message translates to:
  /// **'Pedido Realizado'**
  String get orderPlaced;

  /// No description provided for @orderSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'Tu pedido ha sido realizado con éxito'**
  String get orderSuccessMessage;

  /// No description provided for @addToOrder.
  ///
  /// In es, this message translates to:
  /// **'Agregar al pedido'**
  String get addToOrder;

  /// No description provided for @howToGetThere.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo llegar?'**
  String get howToGetThere;

  /// No description provided for @onTheWay.
  ///
  /// In es, this message translates to:
  /// **'En camino'**
  String get onTheWay;

  /// No description provided for @orderHash.
  ///
  /// In es, this message translates to:
  /// **'Pedido #'**
  String get orderHash;

  /// No description provided for @status.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get status;

  /// No description provided for @loadingProductsStart.
  ///
  /// In es, this message translates to:
  /// **'Iniciando carga de productos...'**
  String get loadingProductsStart;

  /// No description provided for @loadingProducts.
  ///
  /// In es, this message translates to:
  /// **'Cargando productos...'**
  String get loadingProducts;

  /// No description provided for @productsAvailable.
  ///
  /// In es, this message translates to:
  /// **'Productos disponibles'**
  String get productsAvailable;

  /// No description provided for @viewAllProducts.
  ///
  /// In es, this message translates to:
  /// **'Ver todos los productos'**
  String get viewAllProducts;

  /// No description provided for @viewMore.
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get viewMore;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
