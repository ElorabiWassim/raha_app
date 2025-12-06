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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
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

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get dashboardTotalUsers;

  /// No description provided for @dashboardVerifiedSPs.
  ///
  /// In en, this message translates to:
  /// **'Verified SPs'**
  String get dashboardVerifiedSPs;

  /// No description provided for @dashboardActiveBookings.
  ///
  /// In en, this message translates to:
  /// **'Active Bookings'**
  String get dashboardActiveBookings;

  /// No description provided for @dashboardRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get dashboardRevenue;

  /// No description provided for @dashboardRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashboardRecentActivity;

  /// No description provided for @dashboardLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dashboardLogout;

  /// No description provided for @dashboardLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get dashboardLogoutConfirm;

  /// No description provided for @dashboardCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dashboardCancel;

  /// No description provided for @demandsTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Jobs'**
  String get demandsTitle;

  /// No description provided for @demandsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search jobs...'**
  String get demandsSearchHint;

  /// No description provided for @demandsCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get demandsCategory;

  /// No description provided for @demandsWilaya.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get demandsWilaya;

  /// No description provided for @demandsCategoryPlumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get demandsCategoryPlumbing;

  /// No description provided for @demandsCategoryElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get demandsCategoryElectrical;

  /// No description provided for @demandsCategoryGardening.
  ///
  /// In en, this message translates to:
  /// **'Gardening'**
  String get demandsCategoryGardening;

  /// No description provided for @demandsCategoryCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get demandsCategoryCleaning;

  /// No description provided for @demandsPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get demandsPosted;

  /// No description provided for @demandsSendOffer.
  ///
  /// In en, this message translates to:
  /// **'Send Offer'**
  String get demandsSendOffer;

  /// No description provided for @demandsOfferSent.
  ///
  /// In en, this message translates to:
  /// **'Offer sent!'**
  String get demandsOfferSent;

  /// No description provided for @applicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider Applications'**
  String get applicationsTitle;

  /// No description provided for @applicationsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search applications...'**
  String get applicationsSearchHint;

  /// No description provided for @applicationsApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get applicationsApplied;

  /// No description provided for @applicationsServicesOffered.
  ///
  /// In en, this message translates to:
  /// **'Services Offered:'**
  String get applicationsServicesOffered;

  /// No description provided for @applicationsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get applicationsAccept;

  /// No description provided for @applicationsDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get applicationsDecline;

  /// No description provided for @applicationsAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted {name}'**
  String applicationsAccepted(String name);

  /// No description provided for @applicationsDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined {name}'**
  String applicationsDeclined(String name);

  /// No description provided for @plansTitle.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plansTitle;

  /// No description provided for @plansRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get plansRecommended;

  /// No description provided for @plansUpgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get plansUpgradeNow;

  /// No description provided for @plansSelectedPlan.
  ///
  /// In en, this message translates to:
  /// **'Selected plan: {plan}'**
  String plansSelectedPlan(String plan);

  /// No description provided for @plansFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get plansFree;

  /// No description provided for @plansFreePriceValue.
  ///
  /// In en, this message translates to:
  /// **'0 DA'**
  String get plansFreePriceValue;

  /// No description provided for @plansFreeFeature1.
  ///
  /// In en, this message translates to:
  /// **'Create an account and list up to 3 services.'**
  String get plansFreeFeature1;

  /// No description provided for @plansFreeFeature2.
  ///
  /// In en, this message translates to:
  /// **'List contact information.'**
  String get plansFreeFeature2;

  /// No description provided for @plansFreeFeature3.
  ///
  /// In en, this message translates to:
  /// **'Lower priority in the listing of services.'**
  String get plansFreeFeature3;

  /// No description provided for @plansFreeFeature4.
  ///
  /// In en, this message translates to:
  /// **'First 20 providers get Free Plan for 6 months.'**
  String get plansFreeFeature4;

  /// No description provided for @plansPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get plansPro;

  /// No description provided for @plansProPriceValue.
  ///
  /// In en, this message translates to:
  /// **'700 DA/month'**
  String get plansProPriceValue;

  /// No description provided for @plansProPeriodValue.
  ///
  /// In en, this message translates to:
  /// **'7,000 DA/year'**
  String get plansProPeriodValue;

  /// No description provided for @plansProFeature1.
  ///
  /// In en, this message translates to:
  /// **'List up to 10 services.'**
  String get plansProFeature1;

  /// No description provided for @plansProFeature2.
  ///
  /// In en, this message translates to:
  /// **'Receive bookings, requests, and client messages.'**
  String get plansProFeature2;

  /// No description provided for @plansProFeature3.
  ///
  /// In en, this message translates to:
  /// **'Create and publish posts.'**
  String get plansProFeature3;

  /// No description provided for @plansProFeature4.
  ///
  /// In en, this message translates to:
  /// **'Respond to user demands.'**
  String get plansProFeature4;

  /// No description provided for @plansProFeature5.
  ///
  /// In en, this message translates to:
  /// **'Medium priority in search results.'**
  String get plansProFeature5;

  /// No description provided for @plansElite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get plansElite;

  /// No description provided for @plansElitePriceValue.
  ///
  /// In en, this message translates to:
  /// **'1,500 DA/month'**
  String get plansElitePriceValue;

  /// No description provided for @plansElitePeriodValue.
  ///
  /// In en, this message translates to:
  /// **'15,000 DA/year'**
  String get plansElitePeriodValue;

  /// No description provided for @plansEliteFeature1.
  ///
  /// In en, this message translates to:
  /// **'List up to 20 services.'**
  String get plansEliteFeature1;

  /// No description provided for @plansEliteFeature2.
  ///
  /// In en, this message translates to:
  /// **'View detailed profile insights (profile views count).'**
  String get plansEliteFeature2;

  /// No description provided for @plansEliteFeature3.
  ///
  /// In en, this message translates to:
  /// **'Highest priority in displaying search results.'**
  String get plansEliteFeature3;

  /// No description provided for @plansEliteFeature4.
  ///
  /// In en, this message translates to:
  /// **'Obtain a verified badge for increased trust.'**
  String get plansEliteFeature4;

  /// No description provided for @plansEliteFeature5.
  ///
  /// In en, this message translates to:
  /// **'Receive bookings, requests, and messages.'**
  String get plansEliteFeature5;

  /// No description provided for @plansEliteFeature6.
  ///
  /// In en, this message translates to:
  /// **'Create and publish posts.'**
  String get plansEliteFeature6;

  /// No description provided for @plansEliteFeature7.
  ///
  /// In en, this message translates to:
  /// **'Promote services through advertisements in the main feed.'**
  String get plansEliteFeature7;

  /// No description provided for @plansEliteFeature8.
  ///
  /// In en, this message translates to:
  /// **'Respond to user demands.'**
  String get plansEliteFeature8;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Verification'**
  String get verificationTitle;

  /// No description provided for @verificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your documents for verification'**
  String get verificationSubtitle;

  /// No description provided for @verificationNationalID.
  ///
  /// In en, this message translates to:
  /// **'National ID / Passport'**
  String get verificationNationalID;

  /// No description provided for @verificationCertificate.
  ///
  /// In en, this message translates to:
  /// **'Professional Certificate'**
  String get verificationCertificate;

  /// No description provided for @verificationProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get verificationProfilePicture;

  /// No description provided for @verificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get verificationRequired;

  /// No description provided for @verificationClearHeadshot.
  ///
  /// In en, this message translates to:
  /// **'Clear headshot required'**
  String get verificationClearHeadshot;

  /// No description provided for @verificationTapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to Upload'**
  String get verificationTapToUpload;

  /// No description provided for @verificationDocumentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document Uploaded'**
  String get verificationDocumentUploaded;

  /// No description provided for @verificationAcceptedFormats.
  ///
  /// In en, this message translates to:
  /// **'Accepted: JPG, PNG, PDF. Max size: 5MB'**
  String get verificationAcceptedFormats;

  /// No description provided for @verificationSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit for Review'**
  String get verificationSubmit;

  /// No description provided for @verificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Application Submitted!'**
  String get verificationSuccess;

  /// No description provided for @verificationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'re reviewing your documents. You\'ll receive a notification within 2-3 business days.'**
  String get verificationSuccessMessage;

  /// No description provided for @verificationBackToVerification.
  ///
  /// In en, this message translates to:
  /// **'Back to Verification'**
  String get verificationBackToVerification;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Reports'**
  String get reportsTitle;

  /// No description provided for @reportsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search reports...'**
  String get reportsSearchHint;

  /// No description provided for @reportsFilterNew.
  ///
  /// In en, this message translates to:
  /// **'New ({count})'**
  String reportsFilterNew(int count);

  /// No description provided for @reportsFilterInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get reportsFilterInProgress;

  /// No description provided for @reportsFilterResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get reportsFilterResolved;

  /// No description provided for @reportsHomeowner.
  ///
  /// In en, this message translates to:
  /// **'HOMEOWNER'**
  String get reportsHomeowner;

  /// No description provided for @reportsProvider.
  ///
  /// In en, this message translates to:
  /// **'PROVIDER'**
  String get reportsProvider;

  /// No description provided for @reportsDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get reportsDetails;

  /// No description provided for @reportsResolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get reportsResolve;

  /// No description provided for @requestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Requests'**
  String get requestsTitle;

  /// No description provided for @requestsTabRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requestsTabRequests;

  /// No description provided for @requestsTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get requestsTabHistory;

  /// No description provided for @requestsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get requestsStatusPending;

  /// No description provided for @requestsStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get requestsStatusConfirmed;

  /// No description provided for @requestsStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get requestsStatusCompleted;

  /// No description provided for @requestsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get requestsAccept;

  /// No description provided for @requestsDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get requestsDecline;

  /// No description provided for @requestsViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get requestsViewDetails;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInfo;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get updatePassword;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @verifyAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify your account'**
  String get verifyAccount;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @receivePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications'**
  String get receivePushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @receiveEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via email'**
  String get receiveEmailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// No description provided for @receiveSmsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications via SMS'**
  String get receiveSmsNotifications;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @enableDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme'**
  String get enableDarkTheme;

  /// No description provided for @serviceArea.
  ///
  /// In en, this message translates to:
  /// **'Service Area'**
  String get serviceArea;

  /// No description provided for @supportAbout.
  ///
  /// In en, this message translates to:
  /// **'Support & About'**
  String get supportAbout;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @getHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Get help and support'**
  String get getHelpSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readPrivacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @readTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get readTermsOfService;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @signOutAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get signOutAccount;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @permanentlyDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get permanentlyDeleteAccount;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirm;

  /// No description provided for @accountDeletionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Account deletion - Coming Soon'**
  String get accountDeletionComingSoon;

  /// No description provided for @myAddresses.
  ///
  /// In en, this message translates to:
  /// **'My Addresses'**
  String get myAddresses;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @securityPrivacy.
  ///
  /// In en, this message translates to:
  /// **'SECURITY & PRIVACY'**
  String get securityPrivacy;

  /// No description provided for @greetingWassim.
  ///
  /// In en, this message translates to:
  /// **'Salam Wassim'**
  String get greetingWassim;

  /// No description provided for @browseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get browseCategories;

  /// No description provided for @topRatedNearYou.
  ///
  /// In en, this message translates to:
  /// **'Top Rated Near You'**
  String get topRatedNearYou;

  /// No description provided for @professionalAmineFaiz.
  ///
  /// In en, this message translates to:
  /// **'Amine Faiz'**
  String get professionalAmineFaiz;

  /// No description provided for @professionMasterPlumber.
  ///
  /// In en, this message translates to:
  /// **'Master Plumber'**
  String get professionMasterPlumber;

  /// No description provided for @professionalMariaHaniya.
  ///
  /// In en, this message translates to:
  /// **'Maria Haniya'**
  String get professionalMariaHaniya;

  /// No description provided for @professionExpertCarpenter.
  ///
  /// In en, this message translates to:
  /// **'Expert Carpenter'**
  String get professionExpertCarpenter;

  /// No description provided for @professionalAliImem.
  ///
  /// In en, this message translates to:
  /// **'Ali Imem'**
  String get professionalAliImem;

  /// No description provided for @professionGardeningLandscaping.
  ///
  /// In en, this message translates to:
  /// **'Gardening & Landscaping'**
  String get professionGardeningLandscaping;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @verifiedHomeowner.
  ///
  /// In en, this message translates to:
  /// **'Verified Homeowner'**
  String get verifiedHomeowner;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @homeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get homeAddress;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccess;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @navigationTo.
  ///
  /// In en, this message translates to:
  /// **'Navigating to {page}'**
  String navigationTo(String page);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChanged(String language);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @jobsDone.
  ///
  /// In en, this message translates to:
  /// **'Jobs Done'**
  String get jobsDone;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @response.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get response;

  /// No description provided for @backgroundChecked.
  ///
  /// In en, this message translates to:
  /// **'Background Checked'**
  String get backgroundChecked;

  /// No description provided for @licensedInsured.
  ///
  /// In en, this message translates to:
  /// **'Licensed & Insured'**
  String get licensedInsured;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @reviewsTab.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTab;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @reviewsSummary.
  ///
  /// In en, this message translates to:
  /// **'Reviews Summary'**
  String get reviewsSummary;

  /// No description provided for @basedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOn;

  /// No description provided for @portfolioDescription.
  ///
  /// In en, this message translates to:
  /// **'Portfolio items will be displayed here.'**
  String get portfolioDescription;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @demands.
  ///
  /// In en, this message translates to:
  /// **'Demands'**
  String get demands;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications - Coming Soon'**
  String get notificationsComingSoon;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addService.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addService;

  /// No description provided for @myServices.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get myServices;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @accountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Account Deletion'**
  String get accountDeletion;

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to'**
  String get languageChangedTo;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @availableServiceProviders.
  ///
  /// In en, this message translates to:
  /// **'Available Service Providers'**
  String get availableServiceProviders;

  /// No description provided for @selectWilaya.
  ///
  /// In en, this message translates to:
  /// **'Select Wilaya'**
  String get selectWilaya;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @applications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get applications;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @cleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get cleaning;

  /// No description provided for @plumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get plumbing;

  /// No description provided for @electrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get electrical;

  /// No description provided for @gardening.
  ///
  /// In en, this message translates to:
  /// **'Gardening'**
  String get gardening;

  /// No description provided for @handyman.
  ///
  /// In en, this message translates to:
  /// **'Handyman'**
  String get handyman;

  /// No description provided for @painting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get painting;

  /// No description provided for @moving.
  ///
  /// In en, this message translates to:
  /// **'Moving'**
  String get moving;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @cantFindService.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find the right service?'**
  String get cantFindService;

  /// No description provided for @cantFindServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you need, and we\'ll find\nyou the right professional.'**
  String get cantFindServiceDescription;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a service or provider'**
  String get searchHint;

  /// No description provided for @tfa.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get tfa;

  /// No description provided for @myaddress.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get myaddress;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversationsYet;

  /// No description provided for @startBooking.
  ///
  /// In en, this message translates to:
  /// **'Start by booking a service to begin\nchatting with a provider.'**
  String get startBooking;

  /// No description provided for @searchInConversation.
  ///
  /// In en, this message translates to:
  /// **'Search in conversation...'**
  String get searchInConversation;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @reactToMessage.
  ///
  /// In en, this message translates to:
  /// **'React to message'**
  String get reactToMessage;

  /// No description provided for @letUsKnowWhatYouNeed.
  ///
  /// In en, this message translates to:
  /// **'Let us know what you need, and we\'ll find\na professional to help you.'**
  String get letUsKnowWhatYouNeed;

  /// No description provided for @openJobs.
  ///
  /// In en, this message translates to:
  /// **'Open Jobs'**
  String get openJobs;

  /// No description provided for @searchJobs.
  ///
  /// In en, this message translates to:
  /// **'Search jobs...'**
  String get searchJobs;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @wilaya.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get wilaya;

  /// No description provided for @posted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get posted;

  /// No description provided for @sendOffer.
  ///
  /// In en, this message translates to:
  /// **'Send Offer'**
  String get sendOffer;

  /// No description provided for @offerSent.
  ///
  /// In en, this message translates to:
  /// **'Offer Sent!'**
  String get offerSent;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @myDemands.
  ///
  /// In en, this message translates to:
  /// **'My Demands'**
  String get myDemands;

  /// No description provided for @noDemandsFound.
  ///
  /// In en, this message translates to:
  /// **'No demands found'**
  String get noDemandsFound;

  /// No description provided for @tryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingSearch;

  /// No description provided for @postNewDemand.
  ///
  /// In en, this message translates to:
  /// **'Post New Demand'**
  String get postNewDemand;

  /// No description provided for @searchByTitleOrCategory.
  ///
  /// In en, this message translates to:
  /// **'Search by title or category...'**
  String get searchByTitleOrCategory;

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

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @carpentry.
  ///
  /// In en, this message translates to:
  /// **'Carpentry'**
  String get carpentry;

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

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @serviceProvidersApplied.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 service provider applied} other{{count} service providers applied}}'**
  String serviceProvidersApplied(int count);

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
  /// **'Provider Hired'**
  String get providerHired;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @jobFinished.
  ///
  /// In en, this message translates to:
  /// **'Job Finished'**
  String get jobFinished;

  /// No description provided for @viewInvoice.
  ///
  /// In en, this message translates to:
  /// **'View Invoice'**
  String get viewInvoice;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @statsInformation.
  ///
  /// In en, this message translates to:
  /// **'Statistics Information'**
  String get statsInformation;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @responseTime.
  ///
  /// In en, this message translates to:
  /// **'Response Time'**
  String get responseTime;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit Service'**
  String get editService;

  /// No description provided for @deleteServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get deleteServiceTitle;

  /// No description provided for @deleteServiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this service? This action cannot be undone.'**
  String get deleteServiceMessage;

  /// No description provided for @serviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// No description provided for @serviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Title'**
  String get serviceTitle;

  /// No description provided for @enterServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter service title'**
  String get enterServiceTitle;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @enterServicePrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter service price'**
  String get enterServicePrice;

  /// No description provided for @priceExample.
  ///
  /// In en, this message translates to:
  /// **'e.g., \"Starts at 1500 DA\" or \"2500 DA per hour\"'**
  String get priceExample;

  /// No description provided for @serviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Service Status'**
  String get serviceStatus;

  /// No description provided for @visibleToCustomers.
  ///
  /// In en, this message translates to:
  /// **'Service is visible to customers'**
  String get visibleToCustomers;

  /// No description provided for @hiddenFromCustomers.
  ///
  /// In en, this message translates to:
  /// **'Service is hidden from customers'**
  String get hiddenFromCustomers;

  /// No description provided for @pricingTips.
  ///
  /// In en, this message translates to:
  /// **'Pricing Tips'**
  String get pricingTips;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Use clear pricing formats like \"1500 DA\" or \"per hour\"'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Consider offering starting prices for complex jobs'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Be transparent about additional charges'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'Review competitor pricing in your area'**
  String get tip4;

  /// No description provided for @deleteService.
  ///
  /// In en, this message translates to:
  /// **'Delete Service'**
  String get deleteService;

  /// No description provided for @confirmDeleteService.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this service? This action cannot be undone.'**
  String get confirmDeleteService;

  /// No description provided for @serviceVisible.
  ///
  /// In en, this message translates to:
  /// **'Service is visible to customers'**
  String get serviceVisible;

  /// No description provided for @serviceHidden.
  ///
  /// In en, this message translates to:
  /// **'Service is hidden from customers'**
  String get serviceHidden;

  /// No description provided for @tipClearPricing.
  ///
  /// In en, this message translates to:
  /// **'Use clear pricing formats like \"1500 DA\" or \"per hour\"'**
  String get tipClearPricing;

  /// No description provided for @tipStartingPrices.
  ///
  /// In en, this message translates to:
  /// **'Consider offering starting prices for complex jobs'**
  String get tipStartingPrices;

  /// No description provided for @tipTransparency.
  ///
  /// In en, this message translates to:
  /// **'Be transparent about additional charges'**
  String get tipTransparency;

  /// No description provided for @tipCompetitorPricing.
  ///
  /// In en, this message translates to:
  /// **'Review competitor pricing in your area'**
  String get tipCompetitorPricing;

  /// No description provided for @serviceImages.
  ///
  /// In en, this message translates to:
  /// **'Service Images'**
  String get serviceImages;

  /// No description provided for @addPhotosToAttractCustomers.
  ///
  /// In en, this message translates to:
  /// **'Add photos of your work to attract more customers.'**
  String get addPhotosToAttractCustomers;

  /// No description provided for @uploadImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadImages;

  /// No description provided for @tapToSelectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Tap here to select photos from your gallery'**
  String get tapToSelectFromGallery;

  /// No description provided for @imageUploadComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Image upload - Coming Soon'**
  String get imageUploadComingSoon;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get serviceName;

  /// No description provided for @enterServiceName.
  ///
  /// In en, this message translates to:
  /// **'Enter service name'**
  String get enterServiceName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describeYourService.
  ///
  /// In en, this message translates to:
  /// **'Describe your service in detail'**
  String get describeYourService;

  /// No description provided for @pricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// No description provided for @pricingModel.
  ///
  /// In en, this message translates to:
  /// **'Pricing Model'**
  String get pricingModel;

  /// No description provided for @hourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRate;

  /// No description provided for @fixedPrice.
  ///
  /// In en, this message translates to:
  /// **'Fixed Price'**
  String get fixedPrice;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get enterPrice;

  /// No description provided for @pleaseEnterServiceName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a service name'**
  String get pleaseEnterServiceName;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterDescription;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a price'**
  String get pleaseEnterPrice;

  /// No description provided for @serviceAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service added successfully!'**
  String get serviceAddedSuccessfully;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
