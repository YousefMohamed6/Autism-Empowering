import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/account/account_screen_large.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/account/account_screen_medium.dart';
import 'package:autism_empowering/features/puzzle_game/screens/multiplayer/account/account_screen_small.dart';
import 'package:autism_empowering/features/puzzle_game/utils/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ResponsiveLayout(
      largeChild: AccountScreenLarge(),
      mediumChild: AccountScreenMedium(),
      smallChild: AccountScreenSmall(),
    );
  }
}
