import 'package:autism_empowering/core/enums/user_type.dart';
import 'package:autism_empowering/features/auth/data/models/user_model.dart';
import 'package:autism_empowering/features/auth/domain/usecases/login_use_case.dart';
import 'package:autism_empowering/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:autism_empowering/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  AuthCubit(this.loginUseCase, this.signUpUseCase, this.signOutUseCase)
      : super(AuthState.initial());
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final ageTextController = TextEditingController();
  final notesTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  UserType userRole = UserType.patient;
  final formKey = GlobalKey<FormState>();
  UserModel get user => UserModel(
        email: emailTextController.text,
        name: nameTextController.text,
        age: ageTextController.text,
        notes: notesTextController.text,
        role: userRole,
        phone: phoneTextController.text,
      );
  Future<void> login() async {
    try {
      if (formKey.currentState!.validate()) {
        emit(AuthState<UserType>.loading());
        final UserType userRole = await loginUseCase.execute(
          emailTextController.text,
          passwordTextController.text,
        );
        emit(AuthState<UserType>.success(userRole));
      }
    } catch (e) {
      emit(AuthState<UserType>.error(e.toString()));
    }
  }

  Future<void> signUp() async {
    emit(AuthState<UserType>.loading());
    try {
      if (formKey.currentState!.validate()) {
        await signUpUseCase.execute(
          user: user,
          password: passwordTextController.text,
        );
        emit(AuthState<UserModel>.success(user));
      }
    } catch (e) {
      emit(AuthState<UserModel>.error(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthState<bool>.loading());
      await signOutUseCase.execute();
      emit(AuthState<bool>.success(true));
    } catch (e) {
      emit(AuthState<bool>.error(e.toString()));
    }
  }
}
