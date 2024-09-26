import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_language_state.dart';

class AppLanguageCubit extends Cubit<AppLanguageState> {
  AppLanguageCubit() : super(const AppLanguageState("en"));

  static const _languageKey = "appLanguageKey";

  Future<void> loadLanguageCode() async {
    final sharePref = await SharedPreferences.getInstance();
    String? languageCode = sharePref.getString(_languageKey);

    if (languageCode == null) {
      final systemLanguageCode =
          Platform.localeName.split("_").first; // Ex: en_US

      if (S.delegate.supportedLocales
          .map((e) => e.languageCode)
          .contains(systemLanguageCode)) {
        languageCode = systemLanguageCode;
      } else {
        languageCode = "en"; // Default language
      }

      await sharePref.setString(_languageKey, systemLanguageCode);
    }

    emit(AppLanguageState(languageCode));
  }

  Future<void> setLanguageCode(String newLanguageCode) async {
    emit(AppLanguageState(newLanguageCode));
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.setString(_languageKey, newLanguageCode);
  }
}
