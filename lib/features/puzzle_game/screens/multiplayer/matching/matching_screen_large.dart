import 'package:autism_empowering/features/puzzle_game/models/user_info.dart';
import 'package:autism_empowering/features/puzzle_game/providers.dart';
import 'package:autism_empowering/features/puzzle_game/utils/database_client.dart';
import 'package:autism_empowering/features/puzzle_game/utils/puzzle_solver.dart';
import 'package:autism_empowering/features/puzzle_game/widgets/multiplayer_screen/puzzle_side_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchingScreenLarge extends ConsumerWidget {
  MatchingScreenLarge({
    required this.user,
    required this.solverClient,
    super.key,
  });
  final EUserData user;

  final _databaseClient = DatabaseClient();
  final PuzzleSolverClient solverClient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          PuzzleSideImage(width: screenSize.width * 0.45),
          SizedBox(
            width: screenSize.width * 0.55,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Consumer(
                    builder: (context, ref, child) {
                      final state =
                          ref.watch(multiPuzzleNotifierProvider(solverClient));

                      return state.maybeWhen(
                        () => const CircularProgressIndicator(),
                        current: (puzzleData) => Consumer(
                          builder: (context, ref, child) {
                            final state =
                                ref.watch(playerMatchingNotifierProvider);

                            return state.when(
                              () => SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(playerMatchingNotifierProvider
                                            .notifier)
                                        .triggerMatching(
                                          myInfo: user,
                                          numbers: puzzleData.board1D,
                                        );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Start Game',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                              ),
                              processing: () => SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Finding player ...',
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        const Spacer(),
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              isMatched: (id) => SizedBox(
                                width: double.maxFinite,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Found player',
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        const Spacer(),
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              isQueued: () => StreamBuilder<DocumentSnapshot>(
                                stream: _databaseClient.isMatched(myInfo: user),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.data() != null) {
                                    final queuedUserData = snapshot.data!.data()
                                        as Map<String, dynamic>;
                                    bool isMatched =
                                        queuedUserData['ismatched'];

                                    if (isMatched) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        ref
                                            .read(playerMatchingNotifierProvider
                                                .notifier)
                                            .foundUser(myInfo: user);
                                      });
                                    }
                                  }

                                  return SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      onPressed: null,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'You are in queue ...',
                                              style: TextStyle(fontSize: 22),
                                            ),
                                            const Spacer(),
                                            CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              error: (message) => Text(
                                message.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            );
                          },
                        ),
                        orElse: () => const CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
