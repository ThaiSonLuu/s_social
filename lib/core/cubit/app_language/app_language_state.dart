part of 'app_language_cubit.dart';

final class AppLanguageState extends Equatable {
  const AppLanguageState(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}
