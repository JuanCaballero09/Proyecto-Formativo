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
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurant App'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingProducts.
  ///
  /// In en, this message translates to:
  /// **'Loading products...'**
  String get loadingProducts;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @dataNotFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get dataNotFound;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newProduct;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @todaysOffers.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Offers'**
  String get todaysOffers;

  /// No description provided for @popularProducts.
  ///
  /// In en, this message translates to:
  /// **'Popular Products'**
  String get popularProducts;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResults;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @productsAndCategories.
  ///
  /// In en, this message translates to:
  /// **'Products and categories'**
  String get productsAndCategories;

  /// No description provided for @productCategories.
  ///
  /// In en, this message translates to:
  /// **'Product Categories'**
  String get productCategories;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @quickOrder.
  ///
  /// In en, this message translates to:
  /// **'Quick Order'**
  String get quickOrder;

  /// No description provided for @deliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Delivery time: 30-45 min'**
  String get deliveryTime;

  /// No description provided for @freeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free delivery on orders over \$25'**
  String get freeDelivery;

  /// No description provided for @ourMenu.
  ///
  /// In en, this message translates to:
  /// **'Our Menu'**
  String get ourMenu;

  /// No description provided for @selectCategoryToSeeProducts.
  ///
  /// In en, this message translates to:
  /// **'Select a category to see all our products'**
  String get selectCategoryToSeeProducts;

  /// No description provided for @viewProducts.
  ///
  /// In en, this message translates to:
  /// **'View products'**
  String get viewProducts;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @burgers.
  ///
  /// In en, this message translates to:
  /// **'Burgers'**
  String get burgers;

  /// No description provided for @pizzas.
  ///
  /// In en, this message translates to:
  /// **'Pizzas'**
  String get pizzas;

  /// No description provided for @salads.
  ///
  /// In en, this message translates to:
  /// **'Salads'**
  String get salads;

  /// No description provided for @tacos.
  ///
  /// In en, this message translates to:
  /// **'Tacos'**
  String get tacos;

  /// No description provided for @beverages.
  ///
  /// In en, this message translates to:
  /// **'Beverages'**
  String get beverages;

  /// No description provided for @desserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get desserts;

  /// No description provided for @appetizers.
  ///
  /// In en, this message translates to:
  /// **'Appetizers'**
  String get appetizers;

  /// No description provided for @mainCourses.
  ///
  /// In en, this message translates to:
  /// **'Main Courses'**
  String get mainCourses;

  /// No description provided for @sortByPrice.
  ///
  /// In en, this message translates to:
  /// **'Sort by Price'**
  String get sortByPrice;

  /// No description provided for @sortByPopularity.
  ///
  /// In en, this message translates to:
  /// **'Sort by Popularity'**
  String get sortByPopularity;

  /// No description provided for @sortByRating.
  ///
  /// In en, this message translates to:
  /// **'Sort by Rating'**
  String get sortByRating;

  /// No description provided for @lowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Low to High'**
  String get lowToHigh;

  /// No description provided for @highToLow.
  ///
  /// In en, this message translates to:
  /// **'High to Low'**
  String get highToLow;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @noProductsConnection.
  ///
  /// In en, this message translates to:
  /// **'No products found. Check your connection and try again.'**
  String get noProductsConnection;

  /// No description provided for @showingAllProductsDebug.
  ///
  /// In en, this message translates to:
  /// **'(Showing all products for debug)'**
  String get showingAllProductsDebug;

  /// No description provided for @seeAllProductsDebug.
  ///
  /// In en, this message translates to:
  /// **'See all products (Debug)'**
  String get seeAllProductsDebug;

  /// No description provided for @availableProducts.
  ///
  /// In en, this message translates to:
  /// **'Available products'**
  String get availableProducts;

  /// No description provided for @loadingProductsError.
  ///
  /// In en, this message translates to:
  /// **'Error loading products'**
  String get loadingProductsError;

  /// No description provided for @unknownState.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknownState;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @totalProductsLoaded.
  ///
  /// In en, this message translates to:
  /// **'Total products loaded'**
  String get totalProductsLoaded;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Information'**
  String get nutrition;

  /// No description provided for @addIngredients.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredients'**
  String get addIngredients;

  /// No description provided for @removeIngredients.
  ///
  /// In en, this message translates to:
  /// **'Remove Ingredients'**
  String get removeIngredients;

  /// No description provided for @specialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get specialInstructions;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart!'**
  String get addedToCart;

  /// No description provided for @selectSize.
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get selectSize;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @extraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extraLarge;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add some delicious items to get started!'**
  String get cartEmptyMessage;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get startShopping;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @removeFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove from cart'**
  String get removeFromCart;

  /// No description provided for @updateQuantity.
  ///
  /// In en, this message translates to:
  /// **'Update quantity'**
  String get updateQuantity;

  /// No description provided for @itemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item removed from cart'**
  String get itemRemoved;

  /// No description provided for @cartUpdated.
  ///
  /// In en, this message translates to:
  /// **'Cart updated'**
  String get cartUpdated;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCode;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get applyCoupon;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied successfully!'**
  String get couponApplied;

  /// No description provided for @invalidCoupon.
  ///
  /// In en, this message translates to:
  /// **'Invalid coupon code'**
  String get invalidCoupon;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'Order Notes'**
  String get orderNotes;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get orderPlaced;

  /// No description provided for @orderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to place order'**
  String get orderFailed;

  /// No description provided for @estimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Estimated delivery'**
  String get estimatedDelivery;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @orderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmation'**
  String get orderConfirmation;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @orderID.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderID;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get orderStatus;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order!'**
  String get thankYou;

  /// No description provided for @orderReceived.
  ///
  /// In en, this message translates to:
  /// **'Order Received'**
  String get orderReceived;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get preparing;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get onTheWay;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @trackYourOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Your Order'**
  String get trackYourOrder;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated time'**
  String get estimatedTime;

  /// No description provided for @contactDelivery.
  ///
  /// In en, this message translates to:
  /// **'Contact Delivery'**
  String get contactDelivery;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @myOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'My Order History'**
  String get myOrderHistory;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get orLoginWith;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent!'**
  String get resetPasswordSent;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDontMatch;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterValidPhone;

  /// No description provided for @enterValidName.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name'**
  String get enterValidName;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get emailAlreadyExists;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddresses;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddress;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get addressLine1;

  /// No description provided for @addressLine2.
  ///
  /// In en, this message translates to:
  /// **'Address Line 2 (Optional)'**
  String get addressLine2;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCode;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @addressType.
  ///
  /// In en, this message translates to:
  /// **'Address Type'**
  String get addressType;

  /// No description provided for @homeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeAddress;

  /// No description provided for @workAddress.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get workAddress;

  /// No description provided for @otherAddress.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherAddress;

  /// No description provided for @locationPermission.
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get locationPermission;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'We need location permission to show nearby restaurants and delivery options'**
  String get locationPermissionMessage;

  /// No description provided for @allowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow Location'**
  String get allowLocation;

  /// No description provided for @denyLocation.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get denyLocation;

  /// No description provided for @deliveryNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Delivery not available in your area'**
  String get deliveryNotAvailable;

  /// No description provided for @selectDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Select delivery address'**
  String get selectDeliveryAddress;

  /// No description provided for @notificationsPage.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPage;

  /// No description provided for @orderUpdates.
  ///
  /// In en, this message translates to:
  /// **'Order Updates'**
  String get orderUpdates;

  /// No description provided for @promotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotions;

  /// No description provided for @newsUpdates.
  ///
  /// In en, this message translates to:
  /// **'News & Updates'**
  String get newsUpdates;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get notificationPermission;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get allowNotifications;

  /// No description provided for @denyNotifications.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get denyNotifications;

  /// No description provided for @newOrderUpdate.
  ///
  /// In en, this message translates to:
  /// **'New order update'**
  String get newOrderUpdate;

  /// No description provided for @promotionAlert.
  ///
  /// In en, this message translates to:
  /// **'Special promotion available!'**
  String get promotionAlert;

  /// No description provided for @orderReady.
  ///
  /// In en, this message translates to:
  /// **'Your order is ready!'**
  String get orderReady;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Order delivered successfully'**
  String get orderDelivered;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network connection error'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again'**
  String get serverError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get timeoutError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDenied;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired, please login again'**
  String get sessionExpired;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get orderNotFound;

  /// No description provided for @productOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Product is out of stock'**
  String get productOutOfStock;

  /// No description provided for @minimumOrderAmount.
  ///
  /// In en, this message translates to:
  /// **'Minimum order amount is \$15'**
  String get minimumOrderAmount;

  /// No description provided for @deliveryAreaRestricted.
  ///
  /// In en, this message translates to:
  /// **'Delivery not available in your area'**
  String get deliveryAreaRestricted;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @addressAdded.
  ///
  /// In en, this message translates to:
  /// **'Address added successfully'**
  String get addressAdded;

  /// No description provided for @addressUpdated.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get addressUpdated;

  /// No description provided for @addressDeleted.
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully'**
  String get addressDeleted;

  /// No description provided for @paymentMethodAdded.
  ///
  /// In en, this message translates to:
  /// **'Payment method added'**
  String get paymentMethodAdded;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully'**
  String get reviewSubmitted;

  /// No description provided for @feedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Feedback sent successfully'**
  String get feedbackSent;

  /// No description provided for @subscriptionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Subscription preferences updated'**
  String get subscriptionUpdated;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delicious food delivered to your door'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skipIntro.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipIntro;

  /// No description provided for @slide1Title.
  ///
  /// In en, this message translates to:
  /// **'Order Your Favorite Food'**
  String get slide1Title;

  /// No description provided for @slide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse through our diverse menu and order your favorite meals'**
  String get slide1Subtitle;

  /// No description provided for @slide2Title.
  ///
  /// In en, this message translates to:
  /// **'Fast Delivery'**
  String get slide2Title;

  /// No description provided for @slide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Get your food delivered quickly and safely to your location'**
  String get slide2Subtitle;

  /// No description provided for @slide3Title.
  ///
  /// In en, this message translates to:
  /// **'Track Your Order'**
  String get slide3Title;

  /// No description provided for @slide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your order in real-time from preparation to delivery'**
  String get slide3Subtitle;

  /// No description provided for @productsLabel.
  ///
  /// In en, this message translates to:
  /// **'products'**
  String get productsLabel;

  /// No description provided for @exampleAddress.
  ///
  /// In en, this message translates to:
  /// **'123 Main Street, Apt 456'**
  String get exampleAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @invalidAddress.
  ///
  /// In en, this message translates to:
  /// **'Address is not valid'**
  String get invalidAddress;

  /// No description provided for @completeAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all fields'**
  String get completeAllFields;

  /// No description provided for @loadingOrdersError.
  ///
  /// In en, this message translates to:
  /// **'Error loading orders'**
  String get loadingOrdersError;

  /// No description provided for @searchOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Orders'**
  String get searchOrdersTitle;

  /// No description provided for @searchOrdersPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to search for orders'**
  String get searchOrdersPrompt;

  /// No description provided for @guestMode.
  ///
  /// In en, this message translates to:
  /// **'Guest Mode'**
  String get guestMode;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get noOrders;

  /// No description provided for @searchWithAnotherEmail.
  ///
  /// In en, this message translates to:
  /// **'Search with another email'**
  String get searchWithAnotherEmail;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get orderCancelled;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusInPreparation.
  ///
  /// In en, this message translates to:
  /// **'In preparation'**
  String get statusInPreparation;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusSent;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get statusFinished;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionsDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions denied'**
  String get locationPermissionsDenied;

  /// No description provided for @locationPermissionsPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions permanently denied'**
  String get locationPermissionsPermanentlyDenied;

  /// No description provided for @errorGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error getting location'**
  String get errorGettingLocation;

  /// No description provided for @couldNotGetAddress.
  ///
  /// In en, this message translates to:
  /// **'Could not get address'**
  String get couldNotGetAddress;

  /// No description provided for @selectedAddress.
  ///
  /// In en, this message translates to:
  /// **'Selected Address'**
  String get selectedAddress;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get codeLabel;

  /// No description provided for @activeAccount.
  ///
  /// In en, this message translates to:
  /// **'Active Account'**
  String get activeAccount;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @billingDetails.
  ///
  /// In en, this message translates to:
  /// **'Billing Details'**
  String get billingDetails;

  /// No description provided for @authenticationError.
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get authenticationError;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @typeToSearch.
  ///
  /// In en, this message translates to:
  /// **'Type to search'**
  String get typeToSearch;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @categorySelected.
  ///
  /// In en, this message translates to:
  /// **'Category selected'**
  String get categorySelected;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @guestAuthPrompt.
  ///
  /// In en, this message translates to:
  /// **'Login or register to continue'**
  String get guestAuthPrompt;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @viewProductsOfThisCategory.
  ///
  /// In en, this message translates to:
  /// **'View products from this category'**
  String get viewProductsOfThisCategory;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodLabel;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsLabel;

  /// No description provided for @backLabel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backLabel;

  /// No description provided for @loginSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginSessionLabel;

  /// No description provided for @enterLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enterLabel;

  /// No description provided for @signupHereLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign up here'**
  String get signupHereLabel;

  /// No description provided for @systemDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Restaurant ordering and delivery system.'**
  String get systemDescriptionLabel;

  /// No description provided for @unknownStateLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknownStateLabel;

  /// No description provided for @reloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reloadLabel;

  /// No description provided for @paymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatusLabel;

  /// No description provided for @exampleAddressHint.
  ///
  /// In en, this message translates to:
  /// **'E.g: Street 123 #45-67, Bogotá'**
  String get exampleAddressHint;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @exampleEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get exampleEmailHint;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @phoneExampleHint.
  ///
  /// In en, this message translates to:
  /// **'E.g: 3001234567'**
  String get phoneExampleHint;

  /// No description provided for @createAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountLabel;

  /// No description provided for @passwordMinCharsLabel.
  ///
  /// In en, this message translates to:
  /// **'Password (minimum 6 characters)'**
  String get passwordMinCharsLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLabel;

  /// No description provided for @cardNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumberLabel;

  /// No description provided for @cardHolderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardHolderNameLabel;

  /// No description provided for @cardHolderExample.
  ///
  /// In en, this message translates to:
  /// **'JOHN DOE'**
  String get cardHolderExample;

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthLabel;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLabel;

  /// No description provided for @cvcLabel.
  ///
  /// In en, this message translates to:
  /// **'CVC'**
  String get cvcLabel;

  /// No description provided for @installmentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of Installments'**
  String get installmentsLabel;

  /// No description provided for @installmentSingular.
  ///
  /// In en, this message translates to:
  /// **'installment'**
  String get installmentSingular;

  /// No description provided for @installmentPlural.
  ///
  /// In en, this message translates to:
  /// **'installments'**
  String get installmentPlural;

  /// No description provided for @cellphoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Cell Phone Number'**
  String get cellphoneNumberLabel;

  /// No description provided for @nequiAppRequirement.
  ///
  /// In en, this message translates to:
  /// **'Make sure you have the Nequi app installed'**
  String get nequiAppRequirement;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressLabel;

  /// No description provided for @yourEmailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get yourEmailPlaceholder;

  /// No description provided for @acceptTermsStart.
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get acceptTermsStart;

  /// No description provided for @termsAndConditionsLink.
  ///
  /// In en, this message translates to:
  /// **'terms and conditions'**
  String get termsAndConditionsLink;

  /// No description provided for @acceptTermsEnd.
  ///
  /// In en, this message translates to:
  /// **' of Wompi'**
  String get acceptTermsEnd;

  /// No description provided for @authorizeDataStart.
  ///
  /// In en, this message translates to:
  /// **'I authorize the '**
  String get authorizeDataStart;

  /// No description provided for @personalDataTreatmentLink.
  ///
  /// In en, this message translates to:
  /// **'personal data processing'**
  String get personalDataTreatmentLink;

  /// No description provided for @newAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'New address'**
  String get newAddressLabel;

  /// No description provided for @newAddressExample.
  ///
  /// In en, this message translates to:
  /// **'E.g: Street 123 #45-67, Apt 101'**
  String get newAddressExample;

  /// No description provided for @resendConfirmationLabel.
  ///
  /// In en, this message translates to:
  /// **'Resend confirmation'**
  String get resendConfirmationLabel;

  /// No description provided for @registerLabel.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerLabel;

  /// No description provided for @enterNequiNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your Nequi cell phone number'**
  String get enterNequiNumberLabel;

  /// No description provided for @nequiNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'You will receive a notification in your Nequi app to approve the payment'**
  String get nequiNotificationMessage;

  /// No description provided for @cashPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get cashPaymentLabel;

  /// No description provided for @paymentInstructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment instructions'**
  String get paymentInstructionsLabel;

  /// No description provided for @prepareExactAmount.
  ///
  /// In en, this message translates to:
  /// **'Prepare the exact amount:'**
  String get prepareExactAmount;

  /// No description provided for @deliverMoneyToDriver.
  ///
  /// In en, this message translates to:
  /// **'Deliver the money to the delivery person when you receive your order'**
  String get deliverMoneyToDriver;

  /// No description provided for @requestReceipt.
  ///
  /// In en, this message translates to:
  /// **'Request your payment receipt'**
  String get requestReceipt;

  /// No description provided for @orderSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummaryLabel;

  /// No description provided for @orderCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code:'**
  String get orderCodeLabel;

  /// No description provided for @totalToPayLabel.
  ///
  /// In en, this message translates to:
  /// **'Total to Pay:'**
  String get totalToPayLabel;

  /// No description provided for @selectCardTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select card type'**
  String get selectCardTypeLabel;

  /// No description provided for @creditCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get creditCardLabel;

  /// No description provided for @debitCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debitCardLabel;

  /// No description provided for @upTo36Installments.
  ///
  /// In en, this message translates to:
  /// **'Up to 36 installments'**
  String get upTo36Installments;

  /// No description provided for @cashPaymentSingle.
  ///
  /// In en, this message translates to:
  /// **'Single payment'**
  String get cashPaymentSingle;

  /// No description provided for @deliveryAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddressLabel;

  /// No description provided for @personalInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfoLabel;

  /// No description provided for @finalizeOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Finalize Order'**
  String get finalizeOrderLabel;

  /// No description provided for @productSingular.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get productSingular;

  /// No description provided for @productPlural.
  ///
  /// In en, this message translates to:
  /// **'products'**
  String get productPlural;

  /// No description provided for @confirmOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrderLabel;

  /// No description provided for @nequiPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Nequi Payment'**
  String get nequiPaymentLabel;

  /// No description provided for @cashEffectiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment'**
  String get cashEffectiveLabel;

  /// No description provided for @myProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfileLabel;

  /// No description provided for @configurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get configurationLabel;

  /// No description provided for @informationLabel.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get informationLabel;

  /// No description provided for @adjustmentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get adjustmentsLabel;

  /// No description provided for @privacyPolicyMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyMenuLabel;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutLabel;

  /// No description provided for @logoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutLabel;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutDialogMessage;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @guestLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestLabel;

  /// No description provided for @guestMessage.
  ///
  /// In en, this message translates to:
  /// **'Login to save your preferences'**
  String get guestMessage;

  /// No description provided for @accountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountLabel;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Bitevia. All rights reserved.'**
  String get allRightsReserved;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. This policy explains how we collect, use, and protect your information within our fast food application.'**
  String get privacyPolicyIntro;

  /// No description provided for @privacySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Information we collect'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Item1.
  ///
  /// In en, this message translates to:
  /// **'Personal data such as name, email and phone number.'**
  String get privacySection1Item1;

  /// No description provided for @privacySection1Item2.
  ///
  /// In en, this message translates to:
  /// **'Delivery addresses.'**
  String get privacySection1Item2;

  /// No description provided for @privacySection1Item3.
  ///
  /// In en, this message translates to:
  /// **'Device information to improve the experience.'**
  String get privacySection1Item3;

  /// No description provided for @privacySection1Item4.
  ///
  /// In en, this message translates to:
  /// **'Order history.'**
  String get privacySection1Item4;

  /// No description provided for @privacySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Use of information'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Item1.
  ///
  /// In en, this message translates to:
  /// **'Process orders and deliveries.'**
  String get privacySection2Item1;

  /// No description provided for @privacySection2Item2.
  ///
  /// In en, this message translates to:
  /// **'Improve user experience.'**
  String get privacySection2Item2;

  /// No description provided for @privacySection2Item3.
  ///
  /// In en, this message translates to:
  /// **'Send notifications related to your orders.'**
  String get privacySection2Item3;

  /// No description provided for @privacySection2Item4.
  ///
  /// In en, this message translates to:
  /// **'Offer promotions and discounts.'**
  String get privacySection2Item4;

  /// No description provided for @privacySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Data protection'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Text.
  ///
  /// In en, this message translates to:
  /// **'We use modern security standards to protect your data, including encryption and secure protocols. We do not sell your information.'**
  String get privacySection3Text;

  /// No description provided for @privacySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Third parties'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Text.
  ///
  /// In en, this message translates to:
  /// **'We may share your information only with services necessary to operate the app, such as payment processors or delivery services.'**
  String get privacySection4Text;

  /// No description provided for @privacySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. User rights'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Item1.
  ///
  /// In en, this message translates to:
  /// **'Request account deletion.'**
  String get privacySection5Item1;

  /// No description provided for @privacySection5Item2.
  ///
  /// In en, this message translates to:
  /// **'Update your personal data.'**
  String get privacySection5Item2;

  /// No description provided for @privacySection5Item3.
  ///
  /// In en, this message translates to:
  /// **'Access the information we store.'**
  String get privacySection5Item3;

  /// No description provided for @privacySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Policy changes'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Text.
  ///
  /// In en, this message translates to:
  /// **'We may update this policy at any time. We will notify you if important changes are made.'**
  String get privacySection6Text;

  /// No description provided for @privacyLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last updated: 2025'**
  String get privacyLastUpdate;

  /// No description provided for @finalizeOrderDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Finalize Order'**
  String get finalizeOrderDialogTitle;

  /// No description provided for @productCountSingular.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get productCountSingular;

  /// No description provided for @productCountPlural.
  ///
  /// In en, this message translates to:
  /// **'products'**
  String get productCountPlural;

  /// No description provided for @totalToPayTitle.
  ///
  /// In en, this message translates to:
  /// **'Total to pay'**
  String get totalToPayTitle;

  /// No description provided for @itemSingular.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get itemSingular;

  /// No description provided for @itemPlural.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get itemPlural;

  /// No description provided for @proceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedToPayment;

  /// No description provided for @selectPaymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your payment method'**
  String get selectPaymentMethodTitle;

  /// No description provided for @orderLabel.
  ///
  /// In en, this message translates to:
  /// **'Order:'**
  String get orderLabel;

  /// No description provided for @creditDebitCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get creditDebitCardTitle;

  /// No description provided for @creditDebitCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay securely with your card'**
  String get creditDebitCardDesc;

  /// No description provided for @nequiTitle.
  ///
  /// In en, this message translates to:
  /// **'Nequi'**
  String get nequiTitle;

  /// No description provided for @nequiDesc.
  ///
  /// In en, this message translates to:
  /// **'Quick payment from your Nequi app'**
  String get nequiDesc;

  /// No description provided for @cashTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cashTitle;

  /// No description provided for @cashDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay cash when you receive your order'**
  String get cashDesc;

  /// No description provided for @goToPayButton.
  ///
  /// In en, this message translates to:
  /// **'Go to Pay'**
  String get goToPayButton;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get loginSubtitle;

  /// No description provided for @emailAddressField.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressField;

  /// No description provided for @passwordField.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordField;

  /// No description provided for @resendConfirmationLink.
  ///
  /// In en, this message translates to:
  /// **'Resend confirmation'**
  String get resendConfirmationLink;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPasswordLink;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @dontHaveAccountText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccountText;

  /// No description provided for @registerHereLink.
  ///
  /// In en, this message translates to:
  /// **'Register here'**
  String get registerHereLink;

  /// No description provided for @loginSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessTitle;

  /// No description provided for @welcomeBackMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBackMessage;

  /// No description provided for @pleaseEnterCredentials.
  ///
  /// In en, this message translates to:
  /// **'Please enter username and password'**
  String get pleaseEnterCredentials;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register to get started'**
  String get registerSubtitle;

  /// No description provided for @firstNameField.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameField;

  /// No description provided for @lastNameField.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameField;

  /// No description provided for @phoneField.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneField;

  /// No description provided for @passwordMinChars.
  ///
  /// In en, this message translates to:
  /// **'Password (minimum 6 characters)'**
  String get passwordMinChars;

  /// No description provided for @confirmPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordField;

  /// No description provided for @termsAndConditionsText.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditionsText;

  /// No description provided for @registerButtonText.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButtonText;

  /// No description provided for @alreadyHaveAccountText.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountText;

  /// No description provided for @resendConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Resend Confirmation'**
  String get resendConfirmationTitle;

  /// No description provided for @resendConfirmationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll resend the confirmation link.'**
  String get resendConfirmationSubtitle;

  /// No description provided for @resendButton.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendButton;

  /// No description provided for @backToLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLoginLink;

  /// No description provided for @recoverPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover Password'**
  String get recoverPasswordTitle;

  /// No description provided for @recoverPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you instructions to reset your password.'**
  String get recoverPasswordSubtitle;

  /// No description provided for @sendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendButton;

  /// No description provided for @mustAcceptTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and conditions'**
  String get mustAcceptTermsAndConditions;

  /// No description provided for @firstNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequiredError;

  /// No description provided for @lastNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequiredError;

  /// No description provided for @phoneRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequiredError;

  /// No description provided for @phoneMustBe10DigitsError.
  ///
  /// In en, this message translates to:
  /// **'Phone must be 10 digits'**
  String get phoneMustBe10DigitsError;

  /// No description provided for @phoneMustStartWith3Error.
  ///
  /// In en, this message translates to:
  /// **'Phone must start with 3'**
  String get phoneMustStartWith3Error;

  /// No description provided for @emailRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequiredError;

  /// No description provided for @enterValidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmailError;

  /// No description provided for @passwordWithMinimumHint.
  ///
  /// In en, this message translates to:
  /// **'Password (minimum 6 characters)'**
  String get passwordWithMinimumHint;

  /// No description provided for @passwordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequiredError;

  /// No description provided for @minimumSixCharactersError.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minimumSixCharactersError;

  /// No description provided for @confirmYourPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPasswordError;

  /// No description provided for @passwordsDoNotMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatchError;
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
      'that was used.');
}
