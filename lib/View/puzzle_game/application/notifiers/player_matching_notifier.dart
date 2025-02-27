import 'dart:developer';


import 'package:autism_empowering/View/puzzle_game/application/states/player_matching_state.dart';
import 'package:autism_empowering/View/puzzle_game/models/user_info.dart';
import 'package:autism_empowering/View/puzzle_game/utils/database_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerMatchingNotifier extends StateNotifier<PlayerMatchingState> {
  final DatabaseClient _databaseClient;

  PlayerMatchingNotifier(this._databaseClient)
      : super(const PlayerMatchingState());

  foundUser({required EUserData myInfo}) async {
    String id = await _databaseClient.foundMatch(myInfo: myInfo);
    state = PlayerMatchingState.isMatched(id);
  }

  triggerMatching({
    required EUserData myInfo,
    required List<int> numbers,
  }) async {
    state = const PlayerMatchingState.processing();

    try {
      log('enter');
      String? id =
          await _databaseClient.matchPlayers(myInfo: myInfo, numbers: numbers);
      log('id: $id');

      state = PlayerMatchingState.isMatched(id!);
    } catch (e) {
      state = PlayerMatchingState.error(message: e.toString());
    }
  }
}
