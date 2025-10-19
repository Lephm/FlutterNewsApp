import 'package:centranews/models/language_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

final localizationProvider =
    NotifierProvider<LocalizationNotifier, LanguageLocalizationTexts>(
      () => LocalizationNotifier(),
    );

class LocalizationNotifier extends Notifier<LanguageLocalizationTexts> {
  @override
  LanguageLocalizationTexts build() {
    var langPref = localStorage.getItem("language");
    if (langPref == null) {
      return engLocalization;
    }
    switch (langPref) {
      case "en":
        return engLocalization;
      case "vn":
        return vietLocalization;
      default:
        return engLocalization;
    }
  }

  //TODO implement this
  void changeLanguageToVietnamese() {
    state = vietLocalization;
  }

  void changeLanguageToEnglish() {
    state = engLocalization;
  }
}
