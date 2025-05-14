import 'package:autism_empowering/core/extentions/getit_extension.dart';
import 'package:autism_empowering/core/services/firebase_auth_service.dart';
import 'package:autism_empowering/core/services/firebase_firestore_service.dart';
import 'package:autism_empowering/features/auth/data/repos/auth_repo.dart';
import 'package:autism_empowering/features/auth/domain/repos/i_auth_repo.dart';
import 'package:autism_empowering/features/auth/domain/usecases/login_use_case.dart';
import 'package:autism_empowering/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:autism_empowering/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:autism_empowering/features/auth/presentation/manager/auth_cubit.dart';
import 'package:get_it/get_it.dart';

class AuthService {
  final sl = GetIt.instance;

  void initDi() {
    sl.registerLazySingletonSafely<FirebaseFirestoreService>(
      () => FirebaseFirestoreService(),
    );
    sl.registerLazySingletonSafely<FirebaseAuthService>(
      () => FirebaseAuthService(),
    );
    sl.registerLazySingletonSafely<IAuthRepo>(
      () => AuthRepoImpl(firestoreService: sl<FirebaseFirestoreService>()),
    );
    sl.registerLazySingletonSafely<IAuthRepo>(
      () => AuthRepoImpl(firestoreService: sl<FirebaseFirestoreService>()),
    );
    sl.registerLazySingletonSafely<LoginUseCase>(
      () => LoginUseCase(
        authRepo: sl<IAuthRepo>(),
        firebaseAuthService: sl<FirebaseAuthService>(),
      ),
    );
    sl.registerLazySingletonSafely<SignUpUseCase>(
      () => SignUpUseCase(
        authRepo: sl<IAuthRepo>(),
        firebaseAuthService: sl<FirebaseAuthService>(),
      ),
    );
    sl.registerLazySingletonSafely<SignOutUseCase>(
      () => SignOutUseCase(
        authRepo: sl<IAuthRepo>(),
        firebaseAuthService: sl<FirebaseAuthService>(),
      ),
    );
    sl.registerFactorySafely(() => AuthCubit(
          sl<LoginUseCase>(),
          sl<SignUpUseCase>(),
          sl<SignOutUseCase>(),
        ));
  }
}
