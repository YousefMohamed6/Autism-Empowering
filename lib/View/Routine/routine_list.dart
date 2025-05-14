import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/component.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:autism_empowering/Model/routine_model.dart';
import 'package:autism_empowering/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'add_routine.dart';
import 'routine_controller.dart';

class RoutineListScreen extends StatelessWidget {
  const RoutineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoutineController routineController = Get.put(RoutineController());
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: text('Routines', fontSize: 20),
        centerTitle: true,
        leading: const BackButtons(),
      ),
      body: StreamBuilder<List<Routines>>(
          stream: routineController.getRoutines(currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      SpinKitCircle(color: AppColors.primaryColor, size: 30));
            }
            final routines = snapshot.data ?? [];
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: routines.length,
              itemBuilder: (ctx, i) {
                return FadeInRight(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                          () => AddRoutineScreen(
                              routines: Routines(
                                  id: routines[i].id,
                                  name: routines[i].name,
                                  startDate: routines[i].startDate,
                                  notes: routines[i].notes)),
                          transition: Transition.zoom);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryColor.withOpacity(0.1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text('Routines Name : ${routines[i].name}'),
                              text(
                                  'Routine Time : ${DateFormat.jm().format(routines[i].startDate)}'),
                              text('Notes : ${routines[i].notes}'),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: AppColors.primaryColor),
                            onPressed: () {
                              routineController.deleteRoutine(
                                  pref!.getString('userToken')!,
                                  routines[i].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddRoutineScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
