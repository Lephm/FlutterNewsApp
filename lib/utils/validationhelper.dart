import 'package:centranews/models/language_localization.dart';

final RegExp emailValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

String? isPasswordValid(String? value, LanguageLocalizationTexts localization) {
  if (value == null || value.isEmpty) {
    return "Please enter a password";
  }
  if (value.length < 6) {
    return "Password must be longer than 6 characters";
  }
  return null;
}

String? isEmailValid(String? value, LanguageLocalizationTexts localization) {
  if (value == null || value.isEmpty) {
    return "Please enter an email";
  } else if (!emailValid.hasMatch(value)) {
    return "Please enter a valid email";
  }

  return null;
}

String? isTheSamePassword(
  String? password,
  String? confirmedPassword,
  LanguageLocalizationTexts localization,
) {
  if (confirmedPassword == null || confirmedPassword.isEmpty) {
    return "Please confirm your password";
  }
  if (confirmedPassword != password) {
    return "Passwords do not match";
  }

  return null;
}
