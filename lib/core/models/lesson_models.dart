import 'package:equatable/equatable.dart';

// ============================================================================
// Unit Model
// ============================================================================

class Unit extends Equatable {
  final String id;
  final String title;
  final String level;
  final List<Lesson> lessons;

  const Unit({
    required this.id,
    required this.title,
    required this.level,
    required this.lessons,
  });

  @override
  List<Object?> get props => [id, title, level, lessons];
}

// ============================================================================
// Lesson Model
// ============================================================================

class Lesson extends Equatable {
  final String lessonId;
  final String title;
  final List<String> learningObjectives;
  final LessonScreens screens;

  const Lesson({
    required this.lessonId,
    required this.title,
    required this.learningObjectives,
    required this.screens,
  });

  @override
  List<Object?> get props => [lessonId, title, learningObjectives, screens];
}

// ============================================================================
// Lesson Screens Container
// ============================================================================

class LessonScreens extends Equatable {
  final QuestionIntroScreen questionIntro;
  final ShortTextScreen shortText;
  final YoutubeVideoScreen youtubeVideo;
  final ExplanationScreen explanation;
  final QuizScreen quiz;
  final LessonCompleteScreen lessonComplete;

  const LessonScreens({
    required this.questionIntro,
    required this.shortText,
    required this.youtubeVideo,
    required this.explanation,
    required this.quiz,
    required this.lessonComplete,
  });

  @override
  List<Object?> get props => [
        questionIntro,
        shortText,
        youtubeVideo,
        explanation,
        quiz,
        lessonComplete,
      ];
}

// ============================================================================
// Question Intro Screen
// ============================================================================

class QuestionIntroScreen extends Equatable {
  final String title;
  final String prompt;
  final List<Choice> choices;

  const QuestionIntroScreen({
    required this.title,
    required this.prompt,
    required this.choices,
  });

  @override
  List<Object?> get props => [title, prompt, choices];
}

// ============================================================================
// Choice Model
// ============================================================================

class Choice extends Equatable {
  final String choiceId;
  final String label;
  final bool isCorrect;
  final String feedbackCorrect;
  final String feedbackWrong;

  const Choice({
    required this.choiceId,
    required this.label,
    required this.isCorrect,
    required this.feedbackCorrect,
    required this.feedbackWrong,
  });

  String get feedback => isCorrect ? feedbackCorrect : feedbackWrong;

  @override
  List<Object?> get props => [
        choiceId,
        label,
        isCorrect,
        feedbackCorrect,
        feedbackWrong,
      ];
}

// ============================================================================
// Short Text Screen
// ============================================================================

class ShortTextScreen extends Equatable {
  final List<TextCard> cards;

  const ShortTextScreen({required this.cards});

  @override
  List<Object?> get props => [cards];
}

class TextCard extends Equatable {
  final String title;
  final String body;

  const TextCard({
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [title, body];
}

// ============================================================================
// Youtube Video Screen
// ============================================================================

class YoutubeVideoScreen extends Equatable {
  final String title;
  final String note;
  final List<String> searchKeywords;
  final String? videoUrl;

  const YoutubeVideoScreen({
    required this.title,
    required this.note,
    required this.searchKeywords,
    this.videoUrl,
  });

  @override
  List<Object?> get props => [title, note, searchKeywords, videoUrl];
}

// ============================================================================
// Explanation Screen
// ============================================================================

class ExplanationScreen extends Equatable {
  final List<ExplanationSection> sections;

  const ExplanationScreen({required this.sections});

  @override
  List<Object?> get props => [sections];
}

class ExplanationSection extends Equatable {
  final String title;
  final String body;
  final String? scientificConnection;
  final String? realLifeAnalogy;
  final List<String>? imageIdeas;
  final String? imagePath;

  const ExplanationSection({
    required this.title,
    required this.body,
    this.scientificConnection,
    this.realLifeAnalogy,
    this.imageIdeas,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
        title,
        body,
        scientificConnection,
        realLifeAnalogy,
        imageIdeas,
        imagePath,
      ];
}

// ============================================================================
// Quiz Screen
// ============================================================================

class QuizScreen extends Equatable {
  final List<QuizQuestion> questions;

  const QuizScreen({required this.questions});

  @override
  List<Object?> get props => [questions];
}

class QuizQuestion extends Equatable {
  final String questionId;
  final QuestionFormat format;
  final String prompt;
  final List<Choice>? choices;
  final String? answerKey; // For true/false

  const QuizQuestion({
    required this.questionId,
    required this.format,
    required this.prompt,
    this.choices,
    this.answerKey,
  });

  @override
  List<Object?> get props => [questionId, format, prompt, choices, answerKey];
}

enum QuestionFormat {
  multipleChoice,
  trueFalse,
  matchPairs,
  reorder,
}

// ============================================================================
// Lesson Complete Screen
// ============================================================================

class LessonCompleteScreen extends Equatable {
  final String title;
  final String rewardText;
  final String? nextLessonId;

  const LessonCompleteScreen({
    required this.title,
    required this.rewardText,
    this.nextLessonId,
  });

  @override
  List<Object?> get props => [title, rewardText, nextLessonId];
}
