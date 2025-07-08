import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get title => 'Demó';

  @override
  String get back_button_text => 'Vissza';

  @override
  String get collage_page_title => 'Készíts kollázsokat';

  @override
  String get profile_page_title => 'Fiók';

  @override
  String get not_logged_in => 'Nincs bejelentkezve';

  @override
  String get logged_in_as => 'Bejelentkezve';

  @override
  String get permission_required_title => 'Engedély szükséges';

  @override
  String get permission_required_message => 'A teljes funkcionalitás érdekében kérlek, adj engedélyt a galéria és fájlok elérésére.';

  @override
  String get go_to_settings => 'Beállítások megnyitása';

  @override
  String get cancel => 'Mégse';
}
