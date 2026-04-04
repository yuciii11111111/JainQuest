import 'package:flutter_test/flutter_test.dart';
import 'package:jainquest/core/content/unit1_content.dart';

void main() {
  test('unit 1 keeps the foundational lessons before later generated content',
      () {
    final lessonIds =
        Unit1Content.unit.lessons.map((lesson) => lesson.lessonId).toList();

    expect(
      lessonIds.take(5).toList(),
      ['U01_L01', 'U01_L02', 'U01_L03', 'U01_L04', 'U01_L05'],
    );
    expect(lessonIds.last, 'U01_MASTER_TEST');
  });
}
