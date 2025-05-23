import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('en'),
    Locale('ar'),
    Locale('tr')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

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

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @verify_email.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email'**
  String get verify_email;

  /// No description provided for @please_enter.
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get please_enter;

  /// No description provided for @have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Signup Now'**
  String get have_an_account;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login Now'**
  String get already_have_an_account;

  /// No description provided for @signup_as.
  ///
  /// In en, this message translates to:
  /// **'SignUp as '**
  String get signup_as;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User Not Found'**
  String get userNotFound;

  /// No description provided for @invalidEmailorPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email Or Password'**
  String get invalidEmailorPassword;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Weak Password'**
  String get weakPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email Already In Use'**
  String get emailAlreadyInUse;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong;

  /// No description provided for @networkRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Network Request Failed'**
  String get networkRequestFailed;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @appClockGame.
  ///
  /// In en, this message translates to:
  /// **'Clock Game'**
  String get appClockGame;

  /// No description provided for @appErrorText.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get appErrorText;

  /// No description provided for @dialogAreYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get dialogAreYouSure;

  /// No description provided for @dialogCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancelButton;

  /// No description provided for @dialogClearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get dialogClearButton;

  /// No description provided for @dialogClearScoreAttentionText.
  ///
  /// In en, this message translates to:
  /// **'Attention!\nScore will be reset!'**
  String get dialogClearScoreAttentionText;

  /// No description provided for @gamePageCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get gamePageCongratulations;

  /// No description provided for @gamePageGameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over - Restart'**
  String get gamePageGameOver;

  /// No description provided for @gamePageGameOverRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get gamePageGameOverRestart;

  /// No description provided for @gamePageNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get gamePageNext;

  /// No description provided for @gamePageTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get gamePageTryAgain;

  /// No description provided for @homePageHighScoreButton.
  ///
  /// In en, this message translates to:
  /// **'High Score'**
  String get homePageHighScoreButton;

  /// No description provided for @homePagePlayButton.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get homePagePlayButton;

  /// No description provided for @homePageSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homePageSettingsButton;

  /// No description provided for @scorePageNoData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get scorePageNoData;

  /// No description provided for @scorePageTitle.
  ///
  /// In en, this message translates to:
  /// **'High Score'**
  String get scorePageTitle;

  /// No description provided for @settingsPageChangeButton.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get settingsPageChangeButton;

  /// No description provided for @settingsPageChooseClock.
  ///
  /// In en, this message translates to:
  /// **'Choose Clock'**
  String get settingsPageChooseClock;

  /// No description provided for @settingsPageNumberedOrUnnumbered.
  ///
  /// In en, this message translates to:
  /// **'Numbered or unnumbered'**
  String get settingsPageNumberedOrUnnumbered;

  /// No description provided for @settingsPageSnackBarSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get settingsPageSnackBarSaved;

  /// No description provided for @settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @settingsPageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsPageEnglish;

  /// No description provided for @settingsPageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get settingsPageTurkish;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
