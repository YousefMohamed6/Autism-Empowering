import 'package:autism_empowering/View/puzzle_game/application/states/add_user_database_state.dart';
import 'package:autism_empowering/View/puzzle_game/models/user_info.dart';
import 'package:autism_empowering/View/puzzle_game/utils/database_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserDatabaseNotifier extends StateNotifier<AddUserDatabaseState> {
  final DatabaseClient _databaseClient;

  AddUserDatabaseNotifier(this._databaseClient)
      : super(const AddUserDatabaseState());

  triggerAddUser({required EUserData user}) async {
    state = const AddUserDatabaseState.processing();

    try {
      await _databaseClient.addUser(userInfo: user);
      state = AddUserDatabaseState.done(user);
    } catch (e) {
      state = AddUserDatabaseState.error(message: e.toString());
    }
  }
}
