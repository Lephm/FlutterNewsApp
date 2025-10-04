import 'package:centranews/models/language_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localizationProvider =
    NotifierProvider<LocalizationNotifier, LanguageLocalizationTexts>(
      () => LocalizationNotifier(),
    );

class LocalizationNotifier extends Notifier<LanguageLocalizationTexts> {
  @override
  LanguageLocalizationTexts build() {
    return engLocalization;
  }
}
