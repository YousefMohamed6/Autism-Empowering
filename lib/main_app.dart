import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/View/Doctors/doctor_list.dart';
import 'package:autism_empowering/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'View/Child Info/patient_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  String? token = pref!.getString('userToken');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(token).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SpinKitCircle(color: primaryColor, size: 30));
          } else if (snapshot.hasError) {
            return Center(child: text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            var userDoc = snapshot.data!;
            var userData = userDoc.data() as Map<String, dynamic>;
            String role = userData['role'];
            if (role == 'Parent') {
              return const PatientScreen();
            } else if (role == 'Doctor') {
              return  DoctorList();
            } else {
              return Center(child: text('Invalid role'));
            }
          } else {
            return Center(child: text('User not found'));
          }
        },
      ),
    );
  }
}
