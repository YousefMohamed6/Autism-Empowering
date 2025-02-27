import 'package:autism_empowering/View/puzzle_game/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerStatefulWidget {
  const SignInButton({
    super.key,
    required this.loginFormKey,
    required this.email,
    required this.password,
  });

  final GlobalKey<FormState> loginFormKey;
  final String email;
  final String password;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInButtonState();
}

class _SignInButtonState extends ConsumerState<SignInButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          if (widget.loginFormKey.currentState!.validate()) {
            ref
                .read(emailAuthNotificationProvider.notifier)
                .signIn(email: widget.email, password: widget.password);
          }
        },
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(emailAuthNotificationProvider);

            return state.maybeWhen(
              () => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              done: (_) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.check,
                  size: 36,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              error: (_) => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              orElse: () => Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
