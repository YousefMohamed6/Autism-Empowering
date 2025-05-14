import 'package:autism_empowering/core/services/firebase_auth_service.dart';
import 'package:autism_empowering/features/auth/data/models/user_model.dart';
import 'package:autism_empowering/features/auth/domain/repos/i_auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpUseCase {
  final IAuthRepo authRepo;

  SignUpUseCase({
    required this.authRepo,
    required this.firebaseAuthService,
  });
  final FirebaseAuthService firebaseAuthService;
  Future<void> execute({
    required UserModel user,
    required String password,
  }) async {
    await firebaseAuthService.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    await authRepo.insertUser(user);
  }
}
