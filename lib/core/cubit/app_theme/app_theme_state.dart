part of 'app_theme_cubit.dart';

final class AppThemeState extends Equatable {
  const AppThemeState(this.isDarkTheme);

  final bool isDarkTheme;

  @override
  List<Object?> get props => [isDarkTheme];
}
