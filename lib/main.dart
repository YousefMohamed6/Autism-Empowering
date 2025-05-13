import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/View/SPLASH/splash_screen.dart';
import 'package:autism_empowering/View/clock_game/score/logic/score_cubit.dart';
import 'package:autism_empowering/View/clock_game/settings/logic/settings_cubit.dart';
import 'package:autism_empowering/View/clock_game/storage/storage_shared_preferences.dart';
import 'package:autism_empowering/View/puzzle_game/res/palette.dart';
import 'package:autism_empowering/firebase_options.dart';
import 'package:autism_empowering/l10n/l10n.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controller/Const/texts.dart';

SharedPreferences? pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(oneSignalAppId);

  await OneSignal.Notifications.requestPermission(true);
  OneSignal.User.getOnesignalId();
  await AwesomeNotifications().initialize(
    '',
    [
      NotificationChannel(
        channelKey: 'routine_channel',
        channelName: 'Routine Channel',
        channelDescription: 'Channel for Routine Children Reminders',
        defaultColor: primaryColor,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
    ],
  );
  pref = await SharedPreferences.getInstance();
  await Permission.notification.request();
  await StorageSharedPreferences().initial();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScoreCubit(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            title: 'Autism Empowering',
            debugShowCheckedModeBanner: false,
            color: primaryColor,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme(
                brightness: Theme.of(context).brightness,
                primary: Palette.blue,
                onPrimary: Colors.white,
                secondary: Palette.blue.withOpacity(0.6),
                onSecondary: Palette.blue.withOpacity(0.3),
                error: Theme.of(context).colorScheme.error,
                onError: Theme.of(context).colorScheme.onError,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            home: child,
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
        child: const SplashScreen(),
      ),
    );
  }
}
