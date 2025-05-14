import 'package:autism_empowering/features/auth/data/models/user_model.dart';

abstract interface class IAuthRepo {
  Future<void> insertUser(UserModel user);
  Future<UserModel> getUser(String email);
  Future<void> cacheUserRole(String userRole);
  Future<void> clearCacheUserRole();
}
