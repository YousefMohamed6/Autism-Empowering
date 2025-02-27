import 'package:autism_empowering/View/puzzle_game/res/palette.dart';
import 'package:autism_empowering/View/puzzle_game/screens/puzzle/puzzle_starter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // To remove the hash in web

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Puzzle',
      debugShowCheckedModeBanner: false,
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
          surface: Palette.crimson,
          onSurface: Colors.white38,
        ),
      ),
      home: const PuzzleStarterScreen(),
    );
  }
}
