import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jainquest/features/resources/data/fundjain_book_data.dart';

void main() {
  test('reader build inserts a quiz after every chapter and a final quiz', () {
    final rawText = File('assets/content/fundjain.txt').readAsStringSync();

    final result = FundJainBookData.buildReader(rawText);
    final quizEntries = result.entries.whereType<FundJainQuizEntry>().toList();

    expect(quizEntries, hasLength(FundJainBookData.chapters.length + 1));
    expect(quizEntries.last.quiz.id, FundJainBookData.finalQuiz.id);
    expect(
      quizEntries
          .take(FundJainBookData.chapters.length)
          .map((entry) => entry.quiz.id),
      FundJainBookData.chapters.map((chapter) => chapter.quiz.id),
    );
  });

  test(
      'reader build keeps front matter and chapter pages before quiz checkpoints',
      () {
    final rawText = File('assets/content/fundjain.txt').readAsStringSync();

    final result = FundJainBookData.buildReader(rawText);
    final firstEntry = result.entries.first;
    final firstQuizIndex =
        result.entries.indexWhere((entry) => entry is FundJainQuizEntry);

    expect(firstEntry, isA<FundJainTextEntry>());
    expect((firstEntry as FundJainTextEntry).isFrontMatter, isTrue);
    expect(firstQuizIndex, greaterThan(0));
    expect(result.textPageCount, greaterThan(FundJainBookData.chapters.length));
  });
}
