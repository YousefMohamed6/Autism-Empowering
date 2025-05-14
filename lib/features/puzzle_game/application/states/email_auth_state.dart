import 'package:autism_empowering/features/puzzle_game/models/user_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_auth_state.freezed.dart';

@freezed
class EmailAuthState with _$EmailAuthState {
  const factory EmailAuthState() = EmailAuthIdle;
  const factory EmailAuthState.processing() = EmailAuthProcessing;
  const factory EmailAuthState.done(EUserData user) = EmailAuthDone;
  const factory EmailAuthState.storingInfo() = UserStorageProcessing;
  const factory EmailAuthState.storageDone(EUserData userData) =
      UserStorageDone;
  const factory EmailAuthState.error({String? message}) = EmailAuthError;
}
