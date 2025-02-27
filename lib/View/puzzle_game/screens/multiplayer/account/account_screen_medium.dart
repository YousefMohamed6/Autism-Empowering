import 'package:autism_empowering/View/puzzle_game/providers.dart';
import 'package:autism_empowering/View/puzzle_game/screens/multiplayer/account/login/login_screen_medium.dart';
import 'package:autism_empowering/View/puzzle_game/screens/multiplayer/account/register/register_screen_medium.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenMedium extends ConsumerWidget {
  const AccountScreenMedium({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(isLoginNotifier);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child:
              state ? const LoginScreenMedium() : const RegisterScreenMedium(),
        );
      },
    );
  }
}
