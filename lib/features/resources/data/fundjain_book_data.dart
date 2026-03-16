import '../../../core/models/lesson_models.dart';

class FundJainQuizDefinition {
  const FundJainQuizDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    this.isFinalQuiz = false,
  });

  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final bool isFinalQuiz;
}

class FundJainChapterDefinition {
  const FundJainChapterDefinition({
    required this.id,
    required this.title,
    required this.marker,
    required this.quiz,
  });

  final String id;
  final String title;
  final String marker;
  final FundJainQuizDefinition quiz;
}

abstract class FundJainReaderEntry {
  const FundJainReaderEntry({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}

class FundJainTextEntry extends FundJainReaderEntry {
  const FundJainTextEntry({
    required super.id,
    required super.title,
    required this.body,
    required this.chapterId,
    required this.pageNumber,
    required this.totalChapterPages,
    this.isFrontMatter = false,
  });

  final String body;
  final String chapterId;
  final int pageNumber;
  final int totalChapterPages;
  final bool isFrontMatter;
}

class FundJainQuizEntry extends FundJainReaderEntry {
  const FundJainQuizEntry({
    required super.id,
    required super.title,
    required this.quiz,
  });

  final FundJainQuizDefinition quiz;
}

class FundJainReaderBuildResult {
  const FundJainReaderBuildResult({
    required this.entries,
    required this.textPageCount,
  });

  final List<FundJainReaderEntry> entries;
  final int textPageCount;
}

class FundJainBookData {
  const FundJainBookData._();

  static const int pageSize = 1200;

  static const List<FundJainChapterDefinition> chapters = [
    FundJainChapterDefinition(
      id: 'introduction',
      title: 'Introduction',
      marker: 'Introduction\nTHE METHOD OF PHILOSOPHY (ANEKANTVAD)',
      quiz: FundJainQuizDefinition(
        id: 'quiz_introduction',
        title: 'Chapter Quiz: Introduction',
        description:
            'Review the three jewels and the logic of standpoints before moving on.',
        questions: [
          QuizQuestion(
            questionId: 'intro_q1',
            format: QuestionFormat.multipleChoice,
            prompt:
                'Which three elements does the book describe as the path of salvation?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Right Belief, Right Knowledge, and Right Conduct',
                isCorrect: true,
                feedbackCorrect:
                    'Yes. The introduction presents these as the three jewels that guide liberation.',
                feedbackWrong:
                    'Not quite. The chapter centers the path on Right Belief, Right Knowledge, and Right Conduct.',
              ),
              Choice(
                choiceId: 'b',
                label: 'Faith, ritual, and austerity',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The opening chapter is more precise: it names the three jewels, not a general trio of practices.',
              ),
              Choice(
                choiceId: 'c',
                label: 'Knowledge, charity, and devotion',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Charity and devotion matter, but the chapter specifically names the three jewels instead.',
              ),
              Choice(
                choiceId: 'd',
                label: 'Meditation, silence, and study',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Those are useful disciplines, but they are not the three jewels named in the introduction.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'intro_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'The Saptabhangi system teaches that a statement should be treated as coming from a particular standpoint.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'tattvas',
      title: 'The Tattvas',
      marker: 'THE TATTVAS',
      quiz: FundJainQuizDefinition(
        id: 'quiz_tattvas',
        title: 'Chapter Quiz: The Tattvas',
        description:
            'Check your grasp of the basic substances and what makes Jiva unique.',
        questions: [
          QuizQuestion(
            questionId: 'tattvas_q1',
            format: QuestionFormat.multipleChoice,
            prompt:
                'According to this chapter, what distinguishes Jiva from Ajiva?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Jiva is endowed with intelligence',
                isCorrect: true,
                feedbackCorrect:
                    'Correct. The chapter says intelligence is what separates Jiva from the other substances.',
                feedbackWrong:
                    'Look for the quality unique to living substance: the text identifies intelligence as the key distinction.',
              ),
              Choice(
                choiceId: 'b',
                label: 'Jiva exists only in human form',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The book treats Jiva as soul, not something limited to human birth.',
              ),
              Choice(
                choiceId: 'c',
                label: 'Jiva is made of the finest atoms',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'That describes matter more than soul. The chapter separates Jiva from material substance.',
              ),
              Choice(
                choiceId: 'd',
                label: 'Jiva cannot change form',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The book does not use fixed physical form as the defining trait of Jiva.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'tattvas_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'Dharma and Adharma are described here as substances that help motion and rest.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'karma',
      title: 'The Nature of Karma',
      marker: 'THE NATURE OF KARMA (Karma ka swroop)',
      quiz: FundJainQuizDefinition(
        id: 'quiz_karma',
        title: 'Chapter Quiz: The Nature of Karma',
        description:
            'Test the chapter’s explanation of bondage, transmigration, and karmic matter.',
        questions: [
          QuizQuestion(
            questionId: 'karma_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'How does the book describe the bondage of sin or karma?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'As a subtle material bondage affecting the soul',
                isCorrect: true,
                feedbackCorrect:
                    'Right. The chapter argues that bondage must involve a real, subtle material force.',
                feedbackWrong:
                    'The text pushes beyond metaphor and describes karmic bondage as a subtle material reality.',
              ),
              Choice(
                choiceId: 'b',
                label: 'As only a social label created by religion',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The chapter does the opposite: it insists bondage is real, not just a social label.',
              ),
              Choice(
                choiceId: 'c',
                label: 'As something removed automatically at death',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Death is not presented as a shortcut to freedom in this chapter.',
              ),
              Choice(
                choiceId: 'd',
                label: 'As a punishment assigned by chance',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The argument here rejects chance as the basis of liberation or bondage.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'karma_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'The Karman sharira is described as staying with the soul until Moksha is attained.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'asrava',
      title: 'Asrava',
      marker: 'ASRAVA',
      quiz: FundJainQuizDefinition(
        id: 'quiz_asrava',
        title: 'Chapter Quiz: Asrava',
        description:
            'Make sure the causes of karmic influx are clear before you continue.',
        questions: [
          QuizQuestion(
            questionId: 'asrava_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'What does Asrava mean in this chapter?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'The influx of karmic matter into the soul',
                isCorrect: true,
                feedbackCorrect:
                    'Exactly. Asrava is the inflow of matter into the soul’s constitution.',
                feedbackWrong:
                    'The chapter defines Asrava specifically as the inflow of karmic matter.',
              ),
              Choice(
                choiceId: 'b',
                label: 'The final destruction of all karmas',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'That belongs to later stages like Nirjara and Moksha, not Asrava.',
              ),
              Choice(
                choiceId: 'c',
                label: 'A temporary state of heavenly pleasure',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'This chapter is about karmic inflow, not heavenly enjoyment.',
              ),
              Choice(
                choiceId: 'd',
                label: 'The fixed destiny of a soul at birth',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The book treats Asrava as an active inflow process, not a fixed birth destiny.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'asrava_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'The chapter lists passions, negligence, wrong belief, moral failing, and yoga among the causes of Asrava.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'bandha',
      title: 'Bandha',
      marker: 'BANDHA',
      quiz: FundJainQuizDefinition(
        id: 'quiz_bandha',
        title: 'Chapter Quiz: Bandha',
        description:
            'Review how karmic bondage forms and how the major karma groups are organized.',
        questions: [
          QuizQuestion(
            questionId: 'bandha_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'In the context of this chapter, what is Bandha?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'The binding of karmic matter to the soul',
                isCorrect: true,
                feedbackCorrect:
                    'Yes. Bandha is the soul’s bondage through karmic matter.',
                feedbackWrong:
                    'Bandha here is about karmic binding, not merely a mental mood or social bond.',
              ),
              Choice(
                choiceId: 'b',
                label: 'The stopping of karmic inflow',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Stopping inflow belongs to Samvara, which comes after this chapter.',
              ),
              Choice(
                choiceId: 'c',
                label: 'The ordinary fading of karmas over time',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'That is closer to savipaka nirjara, not Bandha.',
              ),
              Choice(
                choiceId: 'd',
                label: 'The final ascent of the liberated soul',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Liberated ascent belongs with Moksha, not Bandha.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'bandha_q2',
            format: QuestionFormat.trueFalse,
            prompt: 'The chapter classifies karma into eight main groups.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'samvara',
      title: 'Samvara',
      marker: 'SAMVARA',
      quiz: FundJainQuizDefinition(
        id: 'quiz_samvara',
        title: 'Chapter Quiz: Samvara',
        description:
            'Pause here to check the practices used to stop fresh karmic inflow.',
        questions: [
          QuizQuestion(
            questionId: 'samvara_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'What is the basic aim of Samvara in this chapter?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'To stop fresh karmic matter from flowing in',
                isCorrect: true,
                feedbackCorrect:
                    'Correct. Samvara is the checking of fresh inflow through disciplined control.',
                feedbackWrong:
                    'Samvara is defined here as stopping further karmic inflow.',
              ),
              Choice(
                choiceId: 'b',
                label: 'To classify karmas into many subtypes',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'That detailed classification belongs more to the Bandha discussion.',
              ),
              Choice(
                choiceId: 'c',
                label: 'To describe the heavens in detail',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The chapter mentions cosmic reflection, but its main aim is stopping karmic inflow.',
              ),
              Choice(
                choiceId: 'd',
                label: 'To prove that actions have no karmic effect',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The text assumes actions do have karmic effect, which is why Samvara matters.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'samvara_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'The chapter says control of mind, speech, and body is central to Samvara.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'nirjara',
      title: 'Nirjara',
      marker: 'NIRJARA',
      quiz: FundJainQuizDefinition(
        id: 'quiz_nirjara',
        title: 'Chapter Quiz: Nirjara',
        description:
            'Check the distinction between ordinary karmic falling away and deliberate austerity.',
        questions: [
          QuizQuestion(
            questionId: 'nirjara_q1',
            format: QuestionFormat.multipleChoice,
            prompt:
                'Which form of Nirjara does the chapter call the direct cause of Moksha?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Avipaka Nirjara',
                isCorrect: true,
                feedbackCorrect:
                    'Right. The chapter distinguishes avipaka nirjara as removal through deliberate exertion.',
                feedbackWrong:
                    'The chapter contrasts ordinary karmic fading with avipaka nirjara, and names the latter as the direct path to release.',
              ),
              Choice(
                choiceId: 'b',
                label: 'Savipaka Nirjara',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Savipaka nirjara is described as the ordinary mechanical falling away of karmas.',
              ),
              Choice(
                choiceId: 'c',
                label: 'Mithyatva Nirjara',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'That term is not the chapter’s twofold division of Nirjara.',
              ),
              Choice(
                choiceId: 'd',
                label: 'Bhoga Nirjara',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The chapter instead divides Nirjara into savipaka and avipaka.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'nirjara_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'The chapter divides Tapa into external austerity and internal austerity.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'moksha',
      title: 'Moksha',
      marker: 'MOKSHA',
      quiz: FundJainQuizDefinition(
        id: 'quiz_moksha',
        title: 'Chapter Quiz: Moksha',
        description:
            'Confirm the book’s picture of liberation, concentration, and the perfected soul.',
        questions: [
          QuizQuestion(
            questionId: 'moksha_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'How is Moksha presented in this chapter?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'As complete freedom from karmic bondage and matter',
                isCorrect: true,
                feedbackCorrect:
                    'Yes. The chapter treats Moksha as complete liberation from karmic bondage.',
                feedbackWrong:
                    'The book presents Moksha as total freedom from karmic bondage, not a temporary mood or place.',
              ),
              Choice(
                choiceId: 'b',
                label: 'As a reward granted only by outside intervention',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'This chapter strongly emphasizes self-conquest and right contemplation, not outside rescue.',
              ),
              Choice(
                choiceId: 'c',
                label: 'As the extinction of all individuality',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The discussion argues that liberated souls share a status of perfection while retaining individuality.',
              ),
              Choice(
                choiceId: 'd',
                label: 'As a temporary stay in a higher heaven',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The text treats Moksha as final liberation, not a temporary heavenly residence.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'moksha_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'The chapter presents Dhyana, or concentrated contemplation, as the direct means to Moksha.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'stages',
      title: 'Stages on the Path',
      marker: 'STAGES ON THE PATH',
      quiz: FundJainQuizDefinition(
        id: 'quiz_stages',
        title: 'Chapter Quiz: Stages on the Path',
        description:
            'Review the structure of the fourteen Gunasthanas before advancing.',
        questions: [
          QuizQuestion(
            questionId: 'stages_q1',
            format: QuestionFormat.multipleChoice,
            prompt:
                'Into how many stages does the book divide the path to Nirvana?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Fourteen stages',
                isCorrect: true,
                feedbackCorrect:
                    'Correct. The Gunasthana system is presented as fourteen stages.',
                feedbackWrong:
                    'This chapter gives a fourteen-stage ladder of development called the Gunasthanas.',
              ),
              Choice(
                choiceId: 'b',
                label: 'Seven stages',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Seven appears elsewhere in the book, but not as the count of Gunasthanas.',
              ),
              Choice(
                choiceId: 'c',
                label: 'Ten stages',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The path here is longer and more detailed than ten steps.',
              ),
              Choice(
                choiceId: 'd',
                label: 'Twenty-one stages',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The chapter is explicit: there are fourteen stages on the path.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'stages_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'The thirteenth stage, Sayoga Kevali, is associated with omniscience while bodily association still remains.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
    FundJainChapterDefinition(
      id: 'dharma_practice',
      title: 'Dharma in Practice',
      marker: 'DHARMA IN PRACTICE',
      quiz: FundJainQuizDefinition(
        id: 'quiz_dharma_practice',
        title: 'Chapter Quiz: Dharma in Practice',
        description:
            'Close the final chapter by checking the vows and householder-to-ascetic progression.',
        questions: [
          QuizQuestion(
            questionId: 'practice_q1',
            format: QuestionFormat.multipleChoice,
            prompt:
                'How many primary vows does the chapter assign to the layperson?',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Twelve vows',
                isCorrect: true,
                feedbackCorrect:
                    'Right. The layperson is guided through twelve vows in this chapter.',
                feedbackWrong:
                    'This chapter lays out twelve primary vows for the householder.',
              ),
              Choice(
                choiceId: 'b',
                label: 'Five vows',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Five great vows are central for the ascetic, but the householder chapter expands beyond that.',
              ),
              Choice(
                choiceId: 'c',
                label: 'Eight vows',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The chapter is more expansive than eight and explicitly names twelve.',
              ),
              Choice(
                choiceId: 'd',
                label: 'Fourteen vows',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Fourteen belongs to the Gunasthanas, not the lay vows.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'practice_q2',
            format: QuestionFormat.trueFalse,
            prompt:
                'The chapter presents the monk’s five great vows as stricter versions of the layperson’s vows.',
            answerKey: 'true',
          ),
        ],
      ),
    ),
  ];

  static const FundJainQuizDefinition finalQuiz = FundJainQuizDefinition(
    id: 'quiz_final_book',
    title: 'Final Book Quiz',
    description:
        'One last review across the whole book before you close the reader.',
    isFinalQuiz: true,
    questions: [
      QuizQuestion(
        questionId: 'final_q1',
        format: QuestionFormat.multipleChoice,
        prompt: 'Which chapter explains the stopping of fresh karmic inflow?',
        choices: [
          Choice(
            choiceId: 'a',
            label: 'Samvara',
            isCorrect: true,
            feedbackCorrect:
                'Correct. Samvara is the chapter on stopping fresh karmic inflow.',
            feedbackWrong:
                'The book reserves Samvara for the checking of new karmic influx.',
          ),
          Choice(
            choiceId: 'b',
            label: 'Bandha',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong:
                'Bandha focuses on karmic binding rather than stopping new influx.',
          ),
          Choice(
            choiceId: 'c',
            label: 'Moksha',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong:
                'Moksha is the culmination, but Samvara is the stage that stops fresh inflow.',
          ),
          Choice(
            choiceId: 'd',
            label: 'The Tattvas',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong:
                'That chapter lays foundations, but Samvara is the one about stopping inflow.',
          ),
        ],
      ),
      QuizQuestion(
        questionId: 'final_q2',
        format: QuestionFormat.trueFalse,
        prompt:
            'The book treats right faith, right knowledge, and right conduct as recurring foundations across the path.',
        answerKey: 'true',
      ),
      QuizQuestion(
        questionId: 'final_q3',
        format: QuestionFormat.multipleChoice,
        prompt: 'Which pair best matches the book’s explanation of Nirjara?',
        choices: [
          Choice(
            choiceId: 'a',
            label:
                'Savipaka is ordinary karmic fading; Avipaka is deliberate shedding through exertion',
            isCorrect: true,
            feedbackCorrect:
                'Exactly. The final review should bring back that twofold description of Nirjara.',
            feedbackWrong:
                'The book contrasts ordinary karmic fading with deliberate shedding through austerity and effort.',
          ),
          Choice(
            choiceId: 'b',
            label: 'Savipaka is liberation; Avipaka is heavenly rebirth',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong:
                'Neither term is defined that way in the Nirjara chapter.',
          ),
          Choice(
            choiceId: 'c',
            label: 'Savipaka concerns belief; Avipaka concerns speech',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong:
                'Those are not the categories used for Nirjara in the book.',
          ),
          Choice(
            choiceId: 'd',
            label: 'Savipaka and Avipaka are both names for the same process',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong: 'The chapter clearly distinguishes the two kinds.',
          ),
        ],
      ),
      QuizQuestion(
        questionId: 'final_q4',
        format: QuestionFormat.trueFalse,
        prompt:
            'The Gunasthana chapter describes fourteen stages of spiritual development.',
        answerKey: 'true',
      ),
      QuizQuestion(
        questionId: 'final_q5',
        format: QuestionFormat.multipleChoice,
        prompt:
            'What recurring message ties the practical chapters together near the end of the book?',
        choices: [
          Choice(
            choiceId: 'a',
            label:
                'Self-discipline, meditation, and right conduct transform the soul',
            isCorrect: true,
            feedbackCorrect:
                'Yes. The closing chapters keep returning to self-discipline, contemplation, and right conduct.',
            feedbackWrong:
                'The later chapters repeatedly stress disciplined conduct and contemplation as the working path.',
          ),
          Choice(
            choiceId: 'b',
            label: 'Liberation comes mainly through external rescue',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong:
                'The book consistently emphasizes self-effort, not passive rescue.',
          ),
          Choice(
            choiceId: 'c',
            label: 'Ritual alone is enough without understanding',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong:
                'The book keeps linking understanding with belief and conduct.',
          ),
          Choice(
            choiceId: 'd',
            label: 'Worldly success is the true sign of liberation',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong:
                'Worldly success is not presented as the aim; liberation and purity are.',
          ),
        ],
      ),
    ],
  );

  static FundJainReaderBuildResult buildReader(String rawText) {
    final prepared = _prepareReaderText(rawText);
    final slices = _buildChapterSlices(prepared);
    final entries = <FundJainReaderEntry>[];
    var textPageCount = 0;

    final frontMatter = prepared.substring(0, slices.first.start).trim();
    if (frontMatter.isNotEmpty) {
      final frontMatterPages = _paginate(frontMatter);
      for (var index = 0; index < frontMatterPages.length; index++) {
        textPageCount += 1;
        entries.add(
          FundJainTextEntry(
            id: 'front-matter-$index',
            title: 'Preface & Forward',
            body: frontMatterPages[index],
            chapterId: 'front_matter',
            pageNumber: index + 1,
            totalChapterPages: frontMatterPages.length,
            isFrontMatter: true,
          ),
        );
      }
    }

    for (var index = 0; index < slices.length; index++) {
      final slice = slices[index];
      final sectionText = prepared.substring(slice.start, slice.end).trim();
      final pages = _paginate(sectionText);
      for (var pageIndex = 0; pageIndex < pages.length; pageIndex++) {
        textPageCount += 1;
        entries.add(
          FundJainTextEntry(
            id: '${slice.chapter.id}-page-$pageIndex',
            title: slice.chapter.title,
            body: pages[pageIndex],
            chapterId: slice.chapter.id,
            pageNumber: pageIndex + 1,
            totalChapterPages: pages.length,
          ),
        );
      }
      entries.add(
        FundJainQuizEntry(
          id: 'quiz-entry-${slice.chapter.quiz.id}',
          title: slice.chapter.quiz.title,
          quiz: slice.chapter.quiz,
        ),
      );
    }

    entries.add(
      FundJainQuizEntry(
        id: 'quiz-entry-${finalQuiz.id}',
        title: finalQuiz.title,
        quiz: finalQuiz,
      ),
    );

    return FundJainReaderBuildResult(
      entries: entries,
      textPageCount: textPageCount,
    );
  }

  static String _prepareReaderText(String rawText) {
    final cleaned = rawText
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();

    final sections = cleaned.split('\n\n');
    return sections.length > 1 ? sections.skip(1).join('\n\n').trim() : cleaned;
  }

  static List<String> _paginate(String text) {
    if (text.trim().isEmpty) return const [];

    final words = text.split(RegExp(r'\s+'));
    final pages = <String>[];
    final buffer = StringBuffer();

    for (final word in words) {
      if (buffer.length + word.length + 1 > pageSize) {
        pages.add(buffer.toString().trim());
        buffer.clear();
      }
      buffer.write(word);
      buffer.write(' ');
    }

    if (buffer.isNotEmpty) {
      pages.add(buffer.toString().trim());
    }

    return pages;
  }

  static List<_ChapterSlice> _buildChapterSlices(String text) {
    final slices = <_ChapterSlice>[];
    var searchFrom = 0;

    for (final chapter in chapters) {
      final start = text.indexOf(chapter.marker, searchFrom);
      if (start == -1) {
        throw StateError('Could not find chapter marker: ${chapter.marker}');
      }

      if (slices.isNotEmpty) {
        final previous = slices.removeLast();
        slices.add(
          _ChapterSlice(
            chapter: previous.chapter,
            start: previous.start,
            end: start,
          ),
        );
      }

      slices
          .add(_ChapterSlice(chapter: chapter, start: start, end: text.length));
      searchFrom = start + chapter.marker.length;
    }

    return slices;
  }
}

class _ChapterSlice {
  const _ChapterSlice({
    required this.chapter,
    required this.start,
    required this.end,
  });

  final FundJainChapterDefinition chapter;
  final int start;
  final int end;
}
