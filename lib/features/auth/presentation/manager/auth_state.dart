part of 'auth_cubit.dart';

@freezed
class AuthState<T> with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.success(T data) = Success;
  const factory AuthState.error(String message) = Error;
}
