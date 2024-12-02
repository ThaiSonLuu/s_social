import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:s_social/common/app_constants/constants.dart';
import 'package:s_social/core/presentation/logic/cubit/app_language/app_language_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/app_theme/app_theme_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/auth/auth_cubit.dart';
import 'package:s_social/core/presentation/logic/cubit/profile_user/profile_user_cubit.dart';
import 'package:s_social/core/utils/app_localize/app_theme.dart';
import 'package:s_social/core/utils/app_router/app_router.dart';
import 'package:s_social/di/injection_container.dart';
import 'package:s_social/features/notifications/presentation/logic/unread_notification_cubit.dart';
import 'package:s_social/generated/l10n.dart';
import 'package:s_social/features/screen/home/logic/reaction_cubit.dart';
import 'core/domain/repository/reation_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  createNotificationChannel();

  runApp(const MyApp());
}

void createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    Constants.notificationChannelId,
    Constants.notificationChannelName,
    importance: Importance.high,
  );

  // Create the channel
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthCubit _authCubit;
  late final UnreadNotificationsCubit _unreadNotificationsCubit;
  late final AppRouter _appRouter;
  late final ProfileUserCubit _profileUserCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(
      userRepository: serviceLocator(),
    )..checkLogin();
    _unreadNotificationsCubit = UnreadNotificationsCubit(
      serviceLocator(),
    )..listenToUnreadCount();

    _appRouter = AppRouter(_authCubit, _unreadNotificationsCubit);
    _profileUserCubit = ProfileUserCubit(
      userRepository: serviceLocator(),
      notificationRepository: serviceLocator(),
    );

    _profileUserCubit.getUserInfo();

    _setUpNotification();
  }

  void _setUpNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("On click inside notification: ${details.payload}");
        if (details.payload != null) {
          _appRouter.routers.push(details.payload!);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _appRouter.routers.push(event.data["route"]);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Receive message: ${message.notification?.title}");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Display notification
        await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                Constants.notificationChannelId,
                Constants.notificationChannelName,
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
            payload: message.data["route"]);
      }
    });
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
          create: (context) => _profileUserCubit,
        ),
        BlocProvider(
          create: (context) => _unreadNotificationsCubit,
        ),
        BlocProvider(
          create: (context) => ReactionCubit(
            serviceLocator<ReactionRepository>(),
          ),
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
