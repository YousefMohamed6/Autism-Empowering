import 'package:autism_empowering/core/services/firebase_firestore_service.dart';
import 'package:autism_empowering/core/services/sf_service.dart';
import 'package:autism_empowering/core/utils/constants/app_collections.dart';
import 'package:autism_empowering/core/utils/constants/sf_keys.dart';
import 'package:autism_empowering/features/auth/data/models/user_model.dart';
import 'package:autism_empowering/features/auth/domain/repos/i_auth_repo.dart';

class AuthRepoImpl implements IAuthRepo {
  final FirebaseFirestoreService firestoreService;

  AuthRepoImpl({
    required this.firestoreService,
  });

  @override
  Future<UserModel> getUser(String email) async {
    final response = await firestoreService.getDocument(
        collectionId: AppCollections.userCollection, documentId: email);
    final user = UserModel.fromJson(response.data() as Map<String, dynamic>);
    return user;
  }

  @override
  Future<void> insertUser(UserModel user) async {
    await firestoreService.addDocumentUsingId(
      collectionId: AppCollections.userCollection,
      documentId: user.email,
      data: user.toJson(),
    );
  }

  @override
  Future<void> cacheUserRole(String userRole) async {
    await SharedPreferencesService.saveString(
      SfKeys.userRole,
      userRole,
    );
  }

  @override
  Future<void> clearCacheUserRole() async {
    await SharedPreferencesService.prefs.remove(
      SfKeys.userRole,
    );
  }
}
