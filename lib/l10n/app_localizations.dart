import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @selectThemeTxt.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectThemeTxt;

  /// No description provided for @continueTxt.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueTxt;

  /// No description provided for @darkTxt.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTxt;

  /// No description provided for @lightTxt.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTxt;

  /// No description provided for @systemTxt.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTxt;

  /// No description provided for @welcomeBkTxt.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBkTxt;

  /// No description provided for @signInTxt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInTxt;

  /// No description provided for @emailTxt.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailTxt;

  /// No description provided for @passwordTxt.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordTxt;

  /// No description provided for @forgetTxt.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgetTxt;

  /// No description provided for @loginTxt.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTxt;

  /// No description provided for @enterEmailTxt.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmailTxt;

  /// No description provided for @enterPassTxt.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassTxt;

  /// No description provided for @welcomeTxt.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTxt;

  /// No description provided for @patientLstTxt.
  ///
  /// In en, this message translates to:
  /// **'List of Patient\'s'**
  String get patientLstTxt;

  /// No description provided for @basicInfoTxt.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfoTxt;

  /// No description provided for @nameTxt.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameTxt;

  /// No description provided for @pronounTxt.
  ///
  /// In en, this message translates to:
  /// **'Pronouns'**
  String get pronounTxt;

  /// No description provided for @bgTxt.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get bgTxt;

  /// No description provided for @historiesTxt.
  ///
  /// In en, this message translates to:
  /// **'Histories'**
  String get historiesTxt;

  /// No description provided for @historyTxt.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTxt;

  /// No description provided for @mediTxt.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get mediTxt;

  /// No description provided for @familyTxt.
  ///
  /// In en, this message translates to:
  /// **'Family History'**
  String get familyTxt;

  /// No description provided for @socialTxt.
  ///
  /// In en, this message translates to:
  /// **'Social History'**
  String get socialTxt;

  /// No description provided for @prevTxt.
  ///
  /// In en, this message translates to:
  /// **'Previous History/Treatment'**
  String get prevTxt;

  /// No description provided for @recordTxt.
  ///
  /// In en, this message translates to:
  /// **'Record Notes'**
  String get recordTxt;

  /// No description provided for @sessionlstTxt.
  ///
  /// In en, this message translates to:
  /// **'Session List'**
  String get sessionlstTxt;

  /// No description provided for @sessiondtlTxt.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessiondtlTxt;

  /// No description provided for @sessionSumTxt.
  ///
  /// In en, this message translates to:
  /// **'Session Summary'**
  String get sessionSumTxt;

  /// No description provided for @summaryTxt.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTxt;

  /// No description provided for @noSessionTxt.
  ///
  /// In en, this message translates to:
  /// **'No session yet'**
  String get noSessionTxt;

  /// No description provided for @pullrefTxt.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh or'**
  String get pullrefTxt;

  /// No description provided for @sessiPullTxt.
  ///
  /// In en, this message translates to:
  /// **'start a new recording.'**
  String get sessiPullTxt;

  /// No description provided for @summaryErrTxt.
  ///
  /// In en, this message translates to:
  /// **'No summary available'**
  String get summaryErrTxt;

  /// No description provided for @themeTxt.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTxt;

  /// No description provided for @langTxt.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get langTxt;

  /// No description provided for @homeTxt.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTxt;

  /// No description provided for @fullnameTxt.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullnameTxt;

  /// No description provided for @addPatientTxt.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get addPatientTxt;

  /// No description provided for @reqNameTxt.
  ///
  /// In en, this message translates to:
  /// **'Full Name required'**
  String get reqNameTxt;

  /// No description provided for @reqEmailTxt.
  ///
  /// In en, this message translates to:
  /// **'Email required'**
  String get reqEmailTxt;

  /// No description provided for @emlValiTxt.
  ///
  /// In en, this message translates to:
  /// **'Enter valid email'**
  String get emlValiTxt;

  /// No description provided for @noPatientTxt.
  ///
  /// In en, this message translates to:
  /// **'No Patients yet'**
  String get noPatientTxt;

  /// No description provided for @patientPullTxt.
  ///
  /// In en, this message translates to:
  /// **'add a patients.'**
  String get patientPullTxt;

  /// No description provided for @notprovTxt.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notprovTxt;

  /// No description provided for @shareSummTxt.
  ///
  /// In en, this message translates to:
  /// **'Share Summary'**
  String get shareSummTxt;

  /// No description provided for @shareErrTxt.
  ///
  /// In en, this message translates to:
  /// **'Session Summary is empty cant share.'**
  String get shareErrTxt;

  /// No description provided for @sheherTxt.
  ///
  /// In en, this message translates to:
  /// **'She/Her'**
  String get sheherTxt;

  /// No description provided for @hehimTxt.
  ///
  /// In en, this message translates to:
  /// **'He/Him'**
  String get hehimTxt;

  /// No description provided for @theythemTxt.
  ///
  /// In en, this message translates to:
  /// **'They/Them'**
  String get theythemTxt;

  /// No description provided for @prefnotTxt.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get prefnotTxt;

  /// No description provided for @otherTxt.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherTxt;

  /// No description provided for @logoutTxt.
  ///
  /// In en, this message translates to:
  /// **'LogOut'**
  String get logoutTxt;

  /// No description provided for @logoutqueTxt.
  ///
  /// In en, this message translates to:
  /// **'You want to LogOut?'**
  String get logoutqueTxt;

  /// No description provided for @noTxt.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noTxt;

  /// No description provided for @initRecTxt.
  ///
  /// In en, this message translates to:
  /// **'Hi Start Recording Notes'**
  String get initRecTxt;

  /// No description provided for @progRecTxt.
  ///
  /// In en, this message translates to:
  /// **'Recording in progress'**
  String get progRecTxt;

  /// No description provided for @complRecTxt.
  ///
  /// In en, this message translates to:
  /// **'Recording is Completed'**
  String get complRecTxt;

  /// No description provided for @pauseRecTxt.
  ///
  /// In en, this message translates to:
  /// **'Recording is Paused'**
  String get pauseRecTxt;

  /// No description provided for @startTxt.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get startTxt;

  /// No description provided for @pauseTxt.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseTxt;

  /// No description provided for @resumeTxt.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeTxt;

  /// No description provided for @complTxt.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get complTxt;

  /// No description provided for @stopTxt.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopTxt;

  /// No description provided for @waveformTxt.
  ///
  /// In en, this message translates to:
  /// **'Waveform appear here'**
  String get waveformTxt;

  /// No description provided for @trnscrptTxt.
  ///
  /// In en, this message translates to:
  /// **'Transcript appear here'**
  String get trnscrptTxt;

  /// No description provided for @wCmplRecTxt.
  ///
  /// In en, this message translates to:
  /// **'Complete Recording?'**
  String get wCmplRecTxt;

  /// No description provided for @recQue1Txt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to complete this recording?'**
  String get recQue1Txt;

  /// No description provided for @recQue2Txt.
  ///
  /// In en, this message translates to:
  /// **'You won’t be able to add more audio.'**
  String get recQue2Txt;

  /// No description provided for @conRecTxt.
  ///
  /// In en, this message translates to:
  /// **'Continue Recording'**
  String get conRecTxt;

  /// No description provided for @tryLaterTxt.
  ///
  /// In en, this message translates to:
  /// **'Try Sometimes later...'**
  String get tryLaterTxt;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
