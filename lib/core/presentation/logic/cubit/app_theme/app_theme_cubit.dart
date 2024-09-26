import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme_state.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(const AppThemeState(false));

  static const _themeKey = "appThemeKey";

  Future<void> loadTheme() async {
    final sharePref = await SharedPreferences.getInstance();
    bool languageCode = sharePref.getBool(_themeKey) ?? false;
    emit(AppThemeState(languageCode));
  }

  Future<void> setTheme(bool isDarkTheme) async {
    emit(AppThemeState(isDarkTheme));
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.setBool(_themeKey, isDarkTheme);
  }
  
}
