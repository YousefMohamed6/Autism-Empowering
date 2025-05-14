import 'package:autism_empowering/core/enums/user_type.dart';
import 'package:autism_empowering/core/exceptions/user_verified_exception.dart';
import 'package:autism_empowering/core/services/firebase_auth_service.dart';
import 'package:autism_empowering/features/auth/domain/repos/i_auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUseCase {
  final IAuthRepo authRepo;
  final FirebaseAuthService firebaseAuthService;
  LoginUseCase({
    required this.authRepo,
    required this.firebaseAuthService,
  });

  Future<UserType> execute(String email, String password) async {
    await firebaseAuthService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final isEmailVerified =
        FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    if (!isEmailVerified) throw UserVerifiedException();
    final user = await authRepo.getUser(email);
    await authRepo.cacheUserRole(user.role.name);
    return user.role;
  }
}
