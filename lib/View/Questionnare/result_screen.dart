import 'dart:convert';

import 'package:autism_empowering/Controller/Const/component.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/Model/child_info_model.dart';
import 'package:autism_empowering/View/Check%20Diagonsis/check_by_image.dart';
import 'package:autism_empowering/View/Child%20Info/patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> answers;
  final ChildInfo child;
  const ResultScreen(
      {super.key,
      required this.score,
      required this.totalQuestions,
      required this.answers,
      required this.child});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<int> binary = [];
  String result = 'Autistic';
  @override
  void initState() {
    super.initState();
    createBinaryAnswers();
    createChildBinary();
    getResult();
  }

  void createBinaryAnswers() {
    for (int i = 0; i < widget.answers.length; i++) {
      if (i == 0 || i == 4 || i == 6 || i == 9) {
        if (widget.answers[i]['selectedAnswer'] == "Definitely Agree" ||
            widget.answers[i]['selectedAnswer'] == "Slightly Agree") {
          binary.add(1);
        } else {
          binary.add(0);
        }
      } else {
        if (widget.answers[i]['selectedAnswer'] == "Definitely Disagree" ||
            widget.answers[i]['selectedAnswer'] == "Slightly Disagree") {
          binary.add(1);
        } else {
          binary.add(0);
        }
      }
    }
  }

  Future<void> createChildBinary() async {
    //age
    binary.add(int.parse(widget.child.age));
    //gender
    if (widget.child.gender == "Male") {
      binary.add(1);
    } else {
      binary.add(0);
    }
    //country
    switch (widget.child.countryOfResidence) {
      case 'Asian':
        binary.add(0);
        break;
      case 'Black':
        binary.add(1);
        break;
      case 'Hispanic':
        binary.add(2);
        break;
      case 'Latino':
        binary.add(3);
        break;
      case 'Middle Eastern':
        binary.add(4);
        break;
      case 'Mixed':
        binary.add(5);
        break;
      case 'Native':
        binary.add(6);
        break;
      case 'Others':
        binary.add(7);
        break;
      case 'Pacifica':
        binary.add(8);
        break;
      case 'South Asian':
        binary.add(9);
        break;
      case 'White European':
        binary.add(10);
        break;
    }
    //Jaundice
    if (widget.child.wasBornWithJaundice == "Yes") {
      binary.add(1);
    } else {
      binary.add(0);
    }
    //FamilyWithAutism
    if (widget.child.hasFamilyWithAutism == "Yes") {
      binary.add(1);
    } else {
      binary.add(0);
    }
  }

  Future<void> getResult() async {
    try {
      print(binary);
      final url = Uri.parse("http://192.168.1.4:5000/upload");
      final headers = {"Content-type": "application/json"};

      final autistic = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 14, 1, 5, 1, 0];
      final nonAutistic = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 7, 1, 4, 0, 0];
      final body = jsonEncode({'data': binary});

      final http.Response response =
          await http.post(url, body: body, headers: headers);
      print(response.body);
      setState(() {
        result = response.body;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        while (Navigator.canPop(context)) {
          Get.offAll(() => const PatientScreen(), transition: Transition.zoom);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: text('Result', fontSize: 20.sp),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.offAll(() => const PatientScreen(),
                    transition: Transition.zoom);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                result,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 36.h),
              text(
                'Please, Upload Your Face Image',
                fontSize: 20.sp,
              ),
              SizedBox(height: 20.h),
              CustomButton(
                  title: 'Upload Image',
                  textColor: Colors.white,
                  width: 250,
                  onTap: () {
                    Get.offAll(() => const CheckByImage(),
                        transition: Transition.zoom);
                  }),
              SizedBox(height: 50.h),
              SizedBox(
                width: 250.w,
                child: CustomButton(
                    title: 'Back To Home Page',
                    textColor: Colors.white,
                    onTap: () {
                      Get.offAll(() => const PatientScreen(),
                          transition: Transition.zoom);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
