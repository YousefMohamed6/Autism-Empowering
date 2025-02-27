import 'package:autism_empowering/View/puzzle_game/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerTestScreen extends ConsumerWidget {
  const TimerTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerNotifierProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state),
          ElevatedButton(
            onPressed: () =>
                ref.read(timerNotifierProvider.notifier).startTimer(),
            child: const Text('Start timer'),
          ),
          ElevatedButton(
            onPressed: () =>
                ref.read(timerNotifierProvider.notifier).stopTimer(),
            child: const Text('Stop timer'),
          ),
        ],
      ),
    );
  }
}
