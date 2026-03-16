import 'package:flutter/material.dart';

import '../../../core/models/lesson_models.dart';
import '../../lesson_runner/presentation/screens/quiz_screen.dart';
import '../data/fundjain_book_data.dart';

class ReadingQuizSessionScreen extends StatefulWidget {
  const ReadingQuizSessionScreen({
    super.key,
    required this.quiz,
    required this.hearts,
  });

  final FundJainQuizDefinition quiz;
  final int hearts;

  @override
  State<ReadingQuizSessionScreen> createState() =>
      _ReadingQuizSessionScreenState();
}

class _ReadingQuizSessionScreenState extends State<ReadingQuizSessionScreen> {
  int _currentQuestionIndex = 0;

  QuizScreen get _screen => QuizScreen(questions: widget.quiz.questions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuizScreenWidget(
        screen: _screen,
        currentQuestionIndex: _currentQuestionIndex,
        hearts: widget.hearts,
        onAnswer: (_) async {},
        onNextQuestion: () {
          setState(() {
            _currentQuestionIndex += 1;
          });
        },
        onComplete: () async {
          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}
