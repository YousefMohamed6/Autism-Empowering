import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:autism_empowering/main.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../View/Auth/login.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  bool isLoading = false;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String name, String age, String notes, String role, String phone) async {
    isLoading = true;
    update();
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        // Save user data to Firestore
        await _usersCollection.doc(user.uid).set({
          'email': email,
          'name': name,
          'age': age,
          'notes': notes,
          'phone': phone,
          'role': role,
          'fcmToken': OneSignal.User.pushSubscription.id,
        });

        // Update user model with ID
        await user.updateDisplayName(name); // Optional: Update user display name
        isLoading = false;
        update();
        return user;
      }

      return null;
    } catch (e) {
      isLoading = false;
      update();
      debugPrint('Error signing up: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    isLoading = true;
    update();
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading = false;
      update();
      return result.user;
    } catch (e) {
      isLoading = false;
      update();
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    isLoading = true;
    update();
    await _auth.signOut();
    pref!.remove('userToken');
    isLoading = false;
    update();
    Get.offAll(() => LoginScreen(), transition: Transition.zoom);
  }

  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _usersCollection.doc(user.uid).get();
      return doc['role'];
    }
    return null;
  }
}
