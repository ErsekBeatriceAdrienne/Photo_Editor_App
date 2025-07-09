import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

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
    Locale('hu')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get title;

  /// No description provided for @back_button_text.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back_button_text;

  /// No description provided for @collage_page_title.
  ///
  /// In en, this message translates to:
  /// **'Collage maker'**
  String get collage_page_title;

  /// No description provided for @profile_page_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_page_title;

  /// No description provided for @home_page_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_page_title;

  /// No description provided for @ai_page_title.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get ai_page_title;

  /// No description provided for @edit_page_title.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit_page_title;

  /// No description provided for @photo_editing_page_title.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photo_editing_page_title;

  /// No description provided for @videos_editing_page_title.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos_editing_page_title;

  /// No description provided for @generate_ai_page_title.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate_ai_page_title;

  /// No description provided for @edited_page_title.
  ///
  /// In en, this message translates to:
  /// **'Edited photos and videos'**
  String get edited_page_title;

  /// No description provided for @not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get not_logged_in;

  /// No description provided for @logged_in_as.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get logged_in_as;

  /// No description provided for @permission_required_title.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permission_required_title;

  /// No description provided for @permission_required_message.
  ///
  /// In en, this message translates to:
  /// **'To access the gallery and files, please grant permission.'**
  String get permission_required_message;

  /// No description provided for @go_to_settings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get go_to_settings;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @collage_button_text.
  ///
  /// In en, this message translates to:
  /// **'Create collages'**
  String get collage_button_text;

  /// No description provided for @generate_button_text.
  ///
  /// In en, this message translates to:
  /// **'Generate with Ai'**
  String get generate_button_text;

  /// No description provided for @filters_for_image_button_text.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get filters_for_image_button_text;

  /// No description provided for @crop_image_button_text.
  ///
  /// In en, this message translates to:
  /// **'Crop and resize'**
  String get crop_image_button_text;

  /// No description provided for @frames_button_text.
  ///
  /// In en, this message translates to:
  /// **'Frames'**
  String get frames_button_text;

  /// No description provided for @photos_section_text.
  ///
  /// In en, this message translates to:
  /// **'Edit photo'**
  String get photos_section_text;

  /// No description provided for @videos_section_text.
  ///
  /// In en, this message translates to:
  /// **'Edit video'**
  String get videos_section_text;

  /// No description provided for @clips_button_text.
  ///
  /// In en, this message translates to:
  /// **'Clips'**
  String get clips_button_text;

  /// No description provided for @movies_button_text.
  ///
  /// In en, this message translates to:
  /// **'Movie maker'**
  String get movies_button_text;

  /// No description provided for @subtitles_button_text.
  ///
  /// In en, this message translates to:
  /// **'Create subtitle'**
  String get subtitles_button_text;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hu': return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
