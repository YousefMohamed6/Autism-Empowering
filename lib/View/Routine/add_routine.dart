import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/images.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Model/routine_model.dart';
import '../../core/utils/constants/component.dart';
import '../../main.dart';
import 'routine_controller.dart';

class AddRoutineScreen extends StatefulWidget {
  final Routines? routines;

  const AddRoutineScreen({super.key, this.routines});

  @override
  State<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {
  RoutineController routineController = Get.put(RoutineController());
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay initialTime = TimeOfDay(
        hour: _selectedDateTime.hour, minute: _selectedDateTime.minute);
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _saveForm() {
    final newMedication = Routines(
      id: widget.routines?.id ?? DateTime.now().toString(),
      name: nameController.text,
      notes: notesController.text,
      startDate: _selectedDateTime,
    );
    if (widget.routines != null) {
      routineController.updateRoutine(
          pref!.getString('userToken')!, newMedication);
      routineController.scheduleDailyNotification(newMedication);
    } else {
      routineController.addRoutine(
        pref!.getString('userToken')!,
        newMedication,
      );
      routineController.scheduleDailyNotification(newMedication);
    }
    Get.back();
  }

  @override
  void initState() {
    if (widget.routines != null) {
      nameController.text = widget.routines!.name;
      notesController.text = widget.routines!.notes;
      _selectedDateTime = widget.routines!.startDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text(widget.routines == null ? 'Add Routine' : 'Update Routine',
            fontSize: 20),
        centerTitle: true,
        leading: const BackButtons(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                image: AppImages.routines,
                keyboardType: TextInputType.name,
                controller: nameController,
                hint: 'Routine Name',
              ),
              const SizedBox(height: 15),
              ListTile(
                title: text('Routine Time'),
                subtitle: text(DateFormat.jm().format(_selectedDateTime)),
                trailing: SvgPicture.asset(
                  AppImages.time,
                  color: AppColors.primaryColor,
                ),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                image: AppImages.notes,
                keyboardType: TextInputType.name,
                controller: notesController,
                hint: 'Notes',
              ),
              const SizedBox(height: 20),
              CustomButton(
                onTap: _saveForm,
                title: 'Add Routine',
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
