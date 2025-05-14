import 'package:autism_empowering/core/services/router_manager.dart';
import 'package:autism_empowering/core/utils/app_initilizer.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/features/clock_game/score/logic/score_cubit.dart';
import 'package:autism_empowering/features/clock_game/settings/logic/settings_cubit.dart';
import 'package:autism_empowering/features/puzzle_game/res/palette.dart';
import 'package:autism_empowering/firebase_options.dart';
import 'package:autism_empowering/generated/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppInitilizer.init();
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
          return MaterialApp.router(
            routerConfig: RouterManager.routeConfig,
            title: 'Autism Empowering',
            debugShowCheckedModeBanner: false,
            color: AppColors.primaryColor,
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
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
