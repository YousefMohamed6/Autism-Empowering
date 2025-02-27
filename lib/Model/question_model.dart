class Question {
  final String questionText;
  final List<String> answers;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

final List<Question> questions = [
  // Add your questions here
  Question(
    questionText: '- S/he often notices small sounds when others do not',
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText:
        '- S/he usually concentrates more on the whole picture, rather than the small details',
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText:
        "- In a social group, s/he can easily keep track of several different people's conversations",
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText:
        '- S/he finds it easy to go back and forth between different activities',
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText:
        "- S/he doesn't know how to keep a conversation going with his/her peers",
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: '- S/he is good at social chit-chat',
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText:
        "- When s/he is read a story, s/he finds it difficult  to work out the character's intentions or feelings",
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: '- When s/he was in preschool, s/he used to enjoy playing games involving pretending with other children',
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: '- S/he finds it easy to work out what someone is thinking or feeling just by looking at their face',
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText:
        '- S/he finds it hard to make new friends',
    answers: [
      'Definitely Agree',
      'Slightly Agree',
      'Slightly Disagree',
      'Definitely Disagree',
    ],
    correctAnswerIndex: 0,
  ),
];
