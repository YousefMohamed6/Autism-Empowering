import 'package:autism_empowering/core/services/firebase_auth_service.dart';
import 'package:autism_empowering/features/auth/domain/repos/i_auth_repo.dart';

class SignOutUseCase {
  final IAuthRepo authRepo;
  final FirebaseAuthService firebaseAuthService;
  SignOutUseCase({required this.authRepo, required this.firebaseAuthService});

  Future<void> execute() async {
    await authRepo.clearCacheUserRole();
    await firebaseAuthService.signOut();
  }
}
