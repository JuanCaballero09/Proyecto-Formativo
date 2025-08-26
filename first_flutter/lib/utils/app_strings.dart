import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Helper class for easy access to localized strings throughout the app
class AppStrings {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
  
  // Quick access to common strings
  static String welcome(BuildContext context) => of(context).welcome;
  static String loading(BuildContext context) => of(context).loading;
  static String error(BuildContext context) => of(context).error;
  static String success(BuildContext context) => of(context).success;
  static String cancel(BuildContext context) => of(context).cancel;
  static String confirm(BuildContext context) => of(context).confirm;
  static String ok(BuildContext context) => of(context).ok;
  static String retry(BuildContext context) => of(context).retry;
  
  // Navigation
  static String home(BuildContext context) => of(context).home;
  static String menu(BuildContext context) => of(context).menu;
  static String cart(BuildContext context) => of(context).cart;
  static String profile(BuildContext context) => of(context).profile;
  static String orders(BuildContext context) => of(context).orders;
  static String notifications(BuildContext context) => of(context).notifications;
  static String location(BuildContext context) => of(context).location;
  
  // Cart & Shopping
  static String addToCart(BuildContext context) => of(context).addToCart;
  static String cartEmpty(BuildContext context) => of(context).cartEmpty;
  static String cartEmptyMessage(BuildContext context) => of(context).cartEmptyMessage;
  static String startShopping(BuildContext context) => of(context).startShopping;
  static String total(BuildContext context) => of(context).total;
  static String quantity(BuildContext context) => of(context).quantity;
  
  // Authentication
  static String login(BuildContext context) => of(context).login;
  static String register(BuildContext context) => of(context).register;
  static String email(BuildContext context) => of(context).email;
  static String password(BuildContext context) => of(context).password;
  static String firstName(BuildContext context) => of(context).firstName;
  static String lastName(BuildContext context) => of(context).lastName;
  
  // Validation
  static String fieldRequired(BuildContext context) => of(context).fieldRequired;
  static String enterValidEmail(BuildContext context) => of(context).enterValidEmail;
  static String enterValidName(BuildContext context) => of(context).enterValidName;
  static String passwordTooShort(BuildContext context) => of(context).passwordTooShort;
  
  // Product & Menu
  static String ourMenu(BuildContext context) => of(context).ourMenu;
  static String todaysOffers(BuildContext context) => of(context).todaysOffers;
  static String popularProducts(BuildContext context) => of(context).popularProducts;
  static String searchProducts(BuildContext context) => of(context).searchProducts;
  static String noProductsFound(BuildContext context) => of(context).noProductsFound;
  static String productDetails(BuildContext context) => of(context).productDetails;
  static String ingredients(BuildContext context) => of(context).ingredients;
  
  // Categories
  static String burgers(BuildContext context) => of(context).burgers;
  static String pizzas(BuildContext context) => of(context).pizzas;
  static String tacos(BuildContext context) => of(context).tacos;
  static String salads(BuildContext context) => of(context).salads;
  
  // Orders & Status
  static String orderPlaced(BuildContext context) => of(context).orderPlaced;
  static String thankYou(BuildContext context) => of(context).thankYou;
  static String orderReceived(BuildContext context) => of(context).orderReceived;
  static String preparing(BuildContext context) => of(context).preparing;
  static String onTheWay(BuildContext context) => of(context).onTheWay;
  static String delivered(BuildContext context) => of(context).delivered;
  
  // Profile & Settings
  static String myProfile(BuildContext context) => of(context).myProfile;
  static String personalInfo(BuildContext context) => of(context).personalInfo;
  static String editProfile(BuildContext context) => of(context).editProfile;
  static String logout(BuildContext context) => of(context).logout;
  static String language(BuildContext context) => of(context).language;
  static String selectLanguage(BuildContext context) => of(context).selectLanguage;
  static String addresses(BuildContext context) => of(context).addresses;
  static String helpSupport(BuildContext context) => of(context).helpSupport;
  static String privacyPolicy(BuildContext context) => of(context).privacyPolicy;
  static String termsConditions(BuildContext context) => of(context).termsConditions;
  
  // Location & Delivery
  static String selectLocation(BuildContext context) => of(context).selectLocation;
  static String currentLocation(BuildContext context) => of(context).currentLocation;
  static String deliveryAddress(BuildContext context) => of(context).deliveryAddress;
  
  // Notifications
  static String notificationsPage(BuildContext context) => of(context).notificationsPage;
  static String noNotifications(BuildContext context) => of(context).noNotifications;
  
  // Success Messages
  static String registrationSuccess(BuildContext context) => of(context).registrationSuccess;
  static String loginSuccess(BuildContext context) => of(context).loginSuccess;
  static String addedToCart(BuildContext context) => of(context).addedToCart;
  static String cartUpdated(BuildContext context) => of(context).cartUpdated;
  
  // Error Messages
  static String networkError(BuildContext context) => of(context).networkError;
  static String dataNotFound(BuildContext context) => of(context).dataNotFound;
  static String loginFailed(BuildContext context) => of(context).loginFailed;
  static String registrationFailed(BuildContext context) => of(context).registrationFailed;
  
  // Common questions
  static String alreadyHaveAccount(BuildContext context) => of(context).alreadyHaveAccount;
  static String dontHaveAccount(BuildContext context) => of(context).dontHaveAccount;
}
