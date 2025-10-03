import 'package:centranews/models/language_localization.dart';
import 'package:flutter_riverpod/legacy.dart';

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, LanguageLocalizationTexts>(
      (ref) => LocalizationNotifier(),
    );

class LocalizationNotifier extends StateNotifier<LanguageLocalizationTexts> {
  LocalizationNotifier() : super(engLocalization);
}
