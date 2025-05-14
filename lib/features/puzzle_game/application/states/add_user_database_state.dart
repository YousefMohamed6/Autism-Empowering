import 'package:autism_empowering/features/puzzle_game/models/user_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_user_database_state.freezed.dart';

@freezed
class AddUserDatabaseState with _$AddUserDatabaseState {
  const factory AddUserDatabaseState() = AddUserDatabaseIdle;
  const factory AddUserDatabaseState.processing() = AddUserDatabaseProcessing;
  const factory AddUserDatabaseState.done(EUserData user) = AddUserDatabaseDone;
  const factory AddUserDatabaseState.error({String? message}) =
      AddUserDatabaseError;
}
