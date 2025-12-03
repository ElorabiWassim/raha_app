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

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

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
  /// **'Navigation to'**
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

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
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
  /// **'Account deletion'**
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
  /// **'Can\'t find a service?'**
  String get cantFindService;

  /// No description provided for @cantFindServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Let us know what you need, and we\'ll find\na professional for you.'**
  String get cantFindServiceDescription;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a service or a provider'**
  String get searchHint;

  /// No description provided for @tfa.
  ///
  /// In en, this message translates to:
  /// **'Two Factor Authentication'**
  String get tfa;

  /// No description provided for @myaddress.
  ///
  /// In en, this message translates to:
  /// **'Myaddress'**
  String get myaddress;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Conversations Yet'**
  String get noConversationsYet;

  /// No description provided for @startBooking.
  ///
  /// In en, this message translates to:
  /// **'Start booking a service to begin\nchatting with a provider.'**
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
  /// **'Let us know what you need, and we\'ll find\na professional for you.'**
  String get letUsKnowWhatYouNeed;
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
