import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ra7a'**
  String get appTitle;

  /// No description provided for @splashWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get splashWelcome;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseLanguage;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Find trusted service providers near you.'**
  String get onboardingTitle1;

  /// First onboarding screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Easily book verified local professionals for all your home needs.'**
  String get onboardingSubtitle1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Schedule & Track your bookings'**
  String get onboardingTitle2;

  /// Second onboarding screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your appointments and stay updated on your service.'**
  String get onboardingSubtitle2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Rate & Review Providers'**
  String get onboardingTitle3;

  /// Third onboarding screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Share your experience and help others make informed choices.'**
  String get onboardingSubtitle3;

  /// Skip button text on onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Next button text on onboarding
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Welcome message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcomeBack;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsername;

  /// Username field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get loginUsernameHint;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// Password field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Divider text between login options
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOr;

  /// Google login button text
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginContinueWithGoogle;

  /// Text before sign up link
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccount;

  /// Sign up link text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUp;

  /// Error message for invalid username
  ///
  /// In en, this message translates to:
  /// **'Invalid username. Please use: homeowner, serviceprovider, or admin'**
  String get loginInvalidUsername;

  /// Title on role selection screen
  ///
  /// In en, this message translates to:
  /// **'Continue as'**
  String get roleSelectionTitle;

  /// Subtitle on role selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose your role to start using Raha'**
  String get roleSelectionSubtitle;

  /// Homeowner role button text
  ///
  /// In en, this message translates to:
  /// **'Homeowner'**
  String get roleHomeowner;

  /// Homeowner role description
  ///
  /// In en, this message translates to:
  /// **'Looking for help'**
  String get roleHomeownerDescription;

  /// Service provider role button text
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get roleServiceProvider;

  /// Service provider role description
  ///
  /// In en, this message translates to:
  /// **'Offering my skills'**
  String get roleServiceProviderDescription;

  /// Back to login button text
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get roleSelectionBackToLogin;

  /// Title for homeowner signup screen
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get signupCreateAccount;

  /// Title for provider signup screen
  ///
  /// In en, this message translates to:
  /// **'Create Provider Account'**
  String get signupCreateProviderAccount;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get signupFullName;

  /// Full name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get signupFullNameHint;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signupEmail;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get signupEmailHint;

  /// Date of birth label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get signupDateOfBirth;

  /// Date picker hint
  ///
  /// In en, this message translates to:
  /// **'mm/dd/yyyy'**
  String get signupDateHint;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get signupPhoneNumber;

  /// Phone number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get signupPhoneNumberHint;

  /// City field label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get signupCity;

  /// City field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Algiers'**
  String get signupCityHint;

  /// Neighborhood field label
  ///
  /// In en, this message translates to:
  /// **'Neighborhood / Street'**
  String get signupNeighborhood;

  /// Neighborhood field hint
  ///
  /// In en, this message translates to:
  /// **'e.g. 123 Main St'**
  String get signupNeighborhoodHint;

  /// Use current location button
  ///
  /// In en, this message translates to:
  /// **'Use My Current Location'**
  String get signupUseCurrentLocation;

  /// Property type label
  ///
  /// In en, this message translates to:
  /// **'Property Type (Optional)'**
  String get signupPropertyType;

  /// Property type dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select property type'**
  String get signupSelectPropertyType;

  /// Apartment property type
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get signupPropertyTypeApartment;

  /// Villa property type
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get signupPropertyTypeVilla;

  /// Studio property type
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get signupPropertyTypeStudio;

  /// Service type label
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get signupServiceType;

  /// Service type dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select your service type'**
  String get signupSelectServiceType;

  /// Service type validation error
  ///
  /// In en, this message translates to:
  /// **'Please select a service type'**
  String get signupSelectServiceTypeError;

  /// Plumbing service type
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get signupServiceTypePlumbing;

  /// Electrical service type
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get signupServiceTypeElectrical;

  /// Cleaning service type
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get signupServiceTypeCleaning;

  /// Painting service type
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get signupServiceTypePainting;

  /// Carpentry service type
  ///
  /// In en, this message translates to:
  /// **'Carpentry'**
  String get signupServiceTypeCarpentry;

  /// HVAC service type
  ///
  /// In en, this message translates to:
  /// **'HVAC'**
  String get signupServiceTypeHVAC;

  /// Gardening service type
  ///
  /// In en, this message translates to:
  /// **'Gardening'**
  String get signupServiceTypeGardening;

  /// Other service type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get signupServiceTypeOther;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signupPassword;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get signupPasswordHint;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signupConfirmPassword;

  /// Confirm password field hint
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get signupConfirmPasswordHint;

  /// Terms acceptance text prefix
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get signupAcceptTerms;

  /// Terms and conditions link text
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get signupTermsAndConditions;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButton;

  /// Verify account button text for provider
  ///
  /// In en, this message translates to:
  /// **'Verify Your Account'**
  String get signupVerifyAccount;

  /// Divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get signupOr;

  /// Google sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signupWithGoogle;

  /// Text before login link
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signupAlreadyHaveAccount;

  /// No description provided for @myServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get myServicesTitle;

  /// No description provided for @myBookingsTab.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookingsTab;

  /// No description provided for @myDemandsTab.
  ///
  /// In en, this message translates to:
  /// **'My Demands'**
  String get myDemandsTab;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @actionRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get actionRate;

  /// No description provided for @actionDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get actionDetails;

  /// No description provided for @noDemandsFound.
  ///
  /// In en, this message translates to:
  /// **'No demands found'**
  String get noDemandsFound;

  /// No description provided for @noDemandsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get noDemandsSubtitle;

  /// No description provided for @postNewDemand.
  ///
  /// In en, this message translates to:
  /// **'Post New Demand'**
  String get postNewDemand;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by title or category...'**
  String get searchPlaceholder;

  /// No description provided for @filterAndSort.
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get filterAndSort;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @sortDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortDate;

  /// No description provided for @sortBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get sortBudget;

  /// No description provided for @sortStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sortStatus;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @categoryElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get categoryElectrical;

  /// No description provided for @categoryPlumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get categoryPlumbing;

  /// No description provided for @categoryPainting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get categoryPainting;

  /// No description provided for @categoryCarpentry.
  ///
  /// In en, this message translates to:
  /// **'Carpentry'**
  String get categoryCarpentry;

  /// No description provided for @categoryCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get categoryCleaning;

  /// No description provided for @budgetRange.
  ///
  /// In en, this message translates to:
  /// **'Budget Range'**
  String get budgetRange;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @providersApplied.
  ///
  /// In en, this message translates to:
  /// **'{count} Service Providers Applied'**
  String providersApplied(int count);

  /// No description provided for @viewRequests.
  ///
  /// In en, this message translates to:
  /// **'View Requests'**
  String get viewRequests;

  /// No description provided for @editDemand.
  ///
  /// In en, this message translates to:
  /// **'Edit Demand'**
  String get editDemand;

  /// No description provided for @cancelDemand.
  ///
  /// In en, this message translates to:
  /// **'Cancel Demand'**
  String get cancelDemand;

  /// No description provided for @providerHired.
  ///
  /// In en, this message translates to:
  /// **'Provider hired'**
  String get providerHired;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @jobFinished.
  ///
  /// In en, this message translates to:
  /// **'Job finished'**
  String get jobFinished;

  /// No description provided for @viewInvoice.
  ///
  /// In en, this message translates to:
  /// **'View Invoice'**
  String get viewInvoice;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
