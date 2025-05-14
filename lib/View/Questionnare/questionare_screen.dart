import 'package:autism_empowering/core/utils/toast.dart';
import 'package:autism_empowering/Model/child_info_model.dart';
import 'package:autism_empowering/View/Questionnare/result_screen.dart';
import 'package:autism_empowering/core/enums/toast_type.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/component.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../Model/question_model.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  List<int> selectedAnswersIndexs = [];
  void _answerQuestion(int selectedAnswerIndex) {
    setState(() {
      if (selectedAnswerIndex ==
          questions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
      _selectedAnswerIndex = selectedAnswerIndex;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
      });

      if (_currentQuestionIndex >= questions.length) {
        showResult();
      }
    });
  }

  Future<ChildInfo?> fetchChildInfo() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('childInfo')
          .doc('info')
          .get();
      var child = ChildInfo.fromMap(data.data()!);
      return child;
    } on Exception catch (_) {
      return null;
    }
  }

  void showResult() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('questionnaire')
        .doc('result')
        .set({
      'answers': questions
          .map((q) => {
                'question': q.questionText,
                'selectedAnswer':
                    q.answers[selectedAnswersIndexs[questions.indexOf(q)]],
              })
          .toList(),
      'score': _score,
    });
    var child = await fetchChildInfo();
    Get.to(
        () => ResultScreen(
              child: child!,
              score: _score,
              totalQuestions: questions.length,
              answers: questions
                  .map((q) => {
                        'question': q.questionText,
                        'selectedAnswer': q.answers[
                            selectedAnswersIndexs[questions.indexOf(q)]],
                      })
                  .toList(),
            ),
        transition: Transition.zoom);
  }

  bool completedQuestionnaire = false;
  Future<void> checkQuestionnaireCompletion() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('questionnaire')
        .get();

    setState(() {
      completedQuestionnaire = snapshot.docs.isNotEmpty;
    });

    if (completedQuestionnaire) {
      displayToast(
        title: 'Questionnaire Complete',
        description: 'You have already completed the questionnaire.',
        status: ToastStatus.success,
      );
    }
  }

  @override
  void initState() {
    checkQuestionnaireCompletion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text('Questionnaire', fontSize: 17.sp),
        centerTitle: true,
        leading: const BackButtons(),
      ),
      body: completedQuestionnaire
          ? Center(
              child: SizedBox(
                width: 250.w,
                child: CustomButton(
                  onTap: () {
                    setState(() {
                      completedQuestionnaire = false;
                    });
                  },
                  title: 'Reload Questionnaire',
                  textColor: Colors.white,
                ),
              ),
            )
          : _currentQuestionIndex < questions.length
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: AppColors.primaryColor.withOpacity(0.3)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        text(questions[_currentQuestionIndex].questionText,
                            fontSize: 20),
                        SizedBox(height: 20.h),
                        ...questions[_currentQuestionIndex]
                            .answers
                            .asMap()
                            .entries
                            .map((entry) {
                          int idx = entry.key;
                          String answer = entry.value;
                          return ListTile(
                            title: text(answer),
                            leading: Checkbox(
                              value: _selectedAnswerIndex == idx,
                              onChanged: (bool? value) {
                                if (value == true) {
                                  selectedAnswersIndexs.add(idx);
                                  _answerQuestion(idx);
                                }
                              },
                              checkColor: Colors.white,
                              activeColor: _selectedAnswerIndex == idx
                                  ? Colors.green
                                  : null,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: SpinKitCircle(
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                ),
    );
  }
}
