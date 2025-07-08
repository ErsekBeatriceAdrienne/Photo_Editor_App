import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Demo';

  @override
  String get back_button_text => 'Back';

  @override
  String get collage_page_title => 'Collage maker';

  @override
  String get profile_page_title => 'Profile';

  @override
  String get home_page_title => 'Home';

  @override
  String get edited_page_title => 'Edited photos';

  @override
  String get ai_page_title => 'Generate with AI';

  @override
  String get edit_page_title => 'Edit photo';

  @override
  String get not_logged_in => 'Not signed in';

  @override
  String get logged_in_as => 'Signed in';

  @override
  String get permission_required_title => 'Permission Required';

  @override
  String get permission_required_message => 'To access the gallery and files, please grant permission.';

  @override
  String get go_to_settings => 'Go to Settings';

  @override
  String get cancel => 'Cancel';
}
