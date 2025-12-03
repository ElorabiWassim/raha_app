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
