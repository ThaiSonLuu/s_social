import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:s_social/core/presentation/logic/cubit/app_language/app_language_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/app_theme/app_theme_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/auth/auth_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/utils/app_localize/app_theme.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthCubit _authCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit()..checkLogin();
    _appRouter = AppRouter(_authCubit);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppLanguageCubit()..loadLanguageCode(),
        ),
        BlocProvider(
          create: (context) => AppThemeCubit()..loadTheme(),
        ),
        BlocProvider(
          create: (context) => _authCubit,
        ),
        BlocProvider(
          create: (context) => ProfileUserCubit(userRepository: serviceLocator())..getUserInfo(),
        ),
      ],
      child: BlocBuilder<AppLanguageCubit, AppLanguageState>(
        builder: (context, appLanguageState) {
          return BlocBuilder<AppThemeCubit, AppThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                themeMode:
                    themeState.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                locale: Locale(appLanguageState.languageCode),
                supportedLocales: S.delegate.supportedLocales,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: ThemeData(
                  brightness: Brightness.light,
                  colorScheme: lightColorScheme,
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  colorScheme: darkColorScheme,
                  useMaterial3: true,
                ),
                routerConfig: _appRouter.routers,
              );
            },
          );
        },
      ),
    );
  }
}
