import '../models/lesson_models.dart';
import '../models/badge_definition.dart';

/// Complete Unit 1 content: Foundations of Jainism
/// Contains 6 lessons with all screens defined
class Unit1Content {
  static const Unit unit = Unit(
    id: 'UNIT_01',
    title: 'Foundations of Jainism',
    level: 'Beginner',
    lessons: [
      _lesson1,
      _lesson2,
      _lesson3,
      _lesson4,
      _lesson5,
      _masterTest,
    ],
  );

  // =========================================================================
  // Lesson 1.1: What is Jainism?
  // =========================================================================

  static const _lesson1 = Lesson(
    lessonId: 'U01_L01',
    title: 'What is Jainism?',
    learningObjectives: [
      'Define Jainism in simple terms',
      'Explain who Jinas are',
      'Differentiate Jina, Jinendra, Tirthankara',
      'State the core purpose of Jain life',
      'Explain Ahimsa as a practical path',
    ],
    screens: LessonScreens(
      questionIntro: QuestionIntroScreen(
        title: 'Warm-up',
        prompt: 'Which idea is closest to the core direction of Jainism?',
        choices: [
          Choice(
            choiceId: 'a',
            label: 'Gaining power over others',
            isCorrect: false,
            feedbackCorrect: 'Correct.',
            feedbackWrong: 'Not this. The focus is self-control and reducing harm.',
          ),
          Choice(
            choiceId: 'b',
            label: 'Non-violence and self-mastery',
            isCorrect: true,
            feedbackCorrect: 'Correct. Jainism emphasizes non-violence and inner discipline.',
            feedbackWrong: 'Incorrect.',
          ),
          Choice(
            choiceId: 'c',
            label: 'Winning arguments',
            isCorrect: false,
            feedbackCorrect: 'Correct.',
            feedbackWrong: 'Not this. Jainism is more about choices and character than debate.',
          ),
        ],
      ),
      shortText: ShortTextScreen(
        cards: [
          TextCard(
            title: 'What is Jainism?',
            body: 'Jainism is a way of living that trains you to reduce harm, strengthen self-control, and become calmer and clearer in daily life.',
          ),
          TextCard(
            title: 'Who are Jinas?',
            body: 'A Jina is someone who has conquered inner enemies like anger, ego, greed, and jealousy. The real victory is inside.',
          ),
          TextCard(
            title: 'Key terms',
            body: 'Jina: victor over inner enemies. Jinendra: respectful title linked to Jina. Tirthankara: a teacher who re-shows the path to liberation.',
          ),
        ],
      ),
      youtubeVideo: YoutubeVideoScreen(
        title: 'Story clip',
        note: 'Watch a short snippet that connects the ideas to a quick story.',
        searchKeywords: [],
        videoAsset: 'assets/videos/youtubevideo.mp4',
        clipStartSeconds: 0,
        clipEndSeconds: 10,
      ),
      explanation: ExplanationScreen(
        sections: [
          ExplanationSection(
            title: 'Core purpose',
            body: 'The purpose is to reduce harm and attachment so the soul becomes clearer, like cleaning a foggy mirror.',
          ),
          ExplanationSection(
            title: 'Ahimsa in real life',
            body: 'Ahimsa is not only physical non-violence. It includes how we speak, how we react, and how we treat living beings and nature.',
            scientificConnection: 'Pausing before reacting helps the brain\'s self-control systems engage, reducing impulsive behavior.',
            realLifeAnalogy: 'A pause button before replying to an angry message.',
          ),
        ],
      ),
      quiz: QuizScreen(
        questions: [
          QuizQuestion(
            questionId: 'U01_L01_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'A Jina is someone who:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Wins wars',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'Not quite. Jina refers to inner victory.',
              ),
              Choice(
                choiceId: 'b',
                label: 'Conquers inner enemies',
                isCorrect: true,
                feedbackCorrect: 'That\'s right! A Jina conquers anger, ego, greed, and jealousy.',
                feedbackWrong: '',
              ),
            ],
          ),
        ],
      ),
      lessonComplete: LessonCompleteScreen(
        title: 'Lesson complete',
        rewardText: 'Badge unlocked: Inner Mastery Starter',
        nextLessonId: 'U01_L02',
      ),
    ),
  );

  // =========================================================================
  // Lesson 1.2: Jiva and Ajiva
  // =========================================================================

  static const _lesson2 = Lesson(
    lessonId: 'U01_L02',
    title: 'Jiva and Ajiva',
    learningObjectives: [
      'Define Jiva',
      'Define Ajiva',
      'Explain consciousness simply',
      'Identify life forms by 1-5 senses',
    ],
    screens: LessonScreens(
      questionIntro: QuestionIntroScreen(
        title: 'Warm-up',
        prompt: 'Which is definitely Jiva (living)?',
        choices: [
          Choice(
            choiceId: 'a',
            label: 'A rock',
            isCorrect: false,
            feedbackCorrect: 'Correct.',
            feedbackWrong: 'A rock is Ajiva (non-living).',
          ),
          Choice(
            choiceId: 'b',
            label: 'An ant',
            isCorrect: true,
            feedbackCorrect: 'Correct. An ant is Jiva (living).',
            feedbackWrong: 'Incorrect.',
          ),
          Choice(
            choiceId: 'c',
            label: 'A phone',
            isCorrect: false,
            feedbackCorrect: 'Correct.',
            feedbackWrong: 'A phone is Ajiva (non-living).',
          ),
        ],
      ),
      shortText: ShortTextScreen(
        cards: [
          TextCard(
            title: 'Jiva vs Ajiva',
            body: 'Jiva is living (has awareness). Ajiva is non-living (no awareness).',
          ),
          TextCard(
            title: 'Consciousness',
            body: 'Consciousness means experiencing and responding in some form.',
          ),
          TextCard(
            title: '1-5 senses',
            body: 'Living beings are grouped by senses, from 1-sense to 5-sense beings.',
          ),
        ],
      ),
      youtubeVideo: YoutubeVideoScreen(
        title: 'Story clip',
        note: 'Short clip on living vs non-living in Jain thought.',
        searchKeywords: [],
        videoAsset: 'assets/videos/youtubevideo.mp4',
        clipStartSeconds: 12,
        clipEndSeconds: 22,
      ),
      explanation: ExplanationScreen(
        sections: [
          ExplanationSection(
            title: 'Living (Jiva)',
            body: 'Humans, animals, insects, and plants are living because they have awareness.',
          ),
          ExplanationSection(
            title: 'Non-living (Ajiva)',
            body: 'Objects lack awareness. Jain philosophy also discusses time and space as non-living categories.',
          ),
          ExplanationSection(
            title: 'Senses ladder',
            body: '1-sense: touch. 2: taste. 3: smell. 4: sight. 5: hearing.',
            scientificConnection: 'In biology, living things respond to stimuli; non-living objects do not respond on their own.',
            realLifeAnalogy: 'Signal on vs signal off.',
          ),
        ],
      ),
      quiz: QuizScreen(
        questions: [
          QuizQuestion(
            questionId: 'U01_L02_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'Jiva means:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Living',
                isCorrect: true,
                feedbackCorrect: 'Right! Jiva means living or having consciousness.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Non-living',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'That\'s Ajiva. Jiva means living.',
              ),
            ],
          ),
        ],
      ),
      lessonComplete: LessonCompleteScreen(
        title: 'Lesson complete',
        rewardText: 'Badge unlocked: Life Observer',
        nextLessonId: 'U01_L03',
      ),
    ),
  );

  // =========================================================================
  // Lesson 1.3: The Soul (Jiva)
  // =========================================================================

  static const _lesson3 = Lesson(
    lessonId: 'U01_L03',
    title: 'The Soul (Jiva)',
    learningObjectives: [
      'Explain the soul as eternal',
      'Explain infinite qualities as infinite potential',
      'Explain why the soul feels bound',
    ],
    screens: LessonScreens(
      questionIntro: QuestionIntroScreen(
        title: 'Warm-up',
        prompt: 'In Jain philosophy, the soul is:',
        choices: [
          Choice(
            choiceId: 'a',
            label: 'Temporary',
            isCorrect: false,
            feedbackCorrect: 'Correct.',
            feedbackWrong: 'Jainism describes the soul as eternal.',
          ),
          Choice(
            choiceId: 'b',
            label: 'Eternal',
            isCorrect: true,
            feedbackCorrect: 'Correct. The soul is described as eternal.',
            feedbackWrong: 'Incorrect.',
          ),
        ],
      ),
      shortText: ShortTextScreen(
        cards: [
          TextCard(
            title: 'The real you',
            body: 'Bodies change. The soul continues through change.',
          ),
          TextCard(
            title: 'Infinite qualities',
            body: 'This means the soul has limitless potential for clarity, peace, and understanding when obstacles are removed.',
          ),
          TextCard(
            title: 'Why it feels limited',
            body: 'Karma covers the soul like dust on a mirror or blur on a lens.',
          ),
        ],
      ),
      youtubeVideo: YoutubeVideoScreen(
        title: 'Story clip',
        note: 'Short clip on the soul and clarity.',
        searchKeywords: [],
        videoAsset: 'assets/videos/youtubevideo.mp4',
        clipStartSeconds: 24,
        clipEndSeconds: 34,
      ),
      explanation: ExplanationScreen(
        sections: [
          ExplanationSection(
            title: 'Eternal does not mean unchanging body',
            body: 'The body changes like a costume; the soul is the experiencer.',
          ),
          ExplanationSection(
            title: 'Why binding happens',
            body: 'Karma binds more when actions are mixed with intense anger, ego, greed, or attachment.',
            scientificConnection: 'Strong emotions can hijack decision-making; calm improves self-control.',
            realLifeAnalogy: 'Clean lens vs dirty lens: same world, different clarity.',
          ),
        ],
      ),
      quiz: QuizScreen(
        questions: [
          QuizQuestion(
            questionId: 'U01_L03_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'The soul is described as:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Eternal',
                isCorrect: true,
                feedbackCorrect: 'Right! The soul is eternal in Jain philosophy.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Temporary',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'The soul is eternal, only the body is temporary.',
              ),
            ],
          ),
        ],
      ),
      lessonComplete: LessonCompleteScreen(
        title: 'Lesson complete',
        rewardText: 'Badge unlocked: Soul Explorer',
        nextLessonId: 'U01_L04',
      ),
    ),
  );

  // =========================================================================
  // Lesson 1.4: Fundamentals of Karma
  // =========================================================================

  static const _lesson4 = Lesson(
    lessonId: 'U01_L04',
    title: 'Fundamentals of Karma',
    learningObjectives: [
      'Explain karma as pudgal (matter)',
      'Explain karma binding',
      'Explain pure vs impure soul states',
    ],
    screens: LessonScreens(
      questionIntro: QuestionIntroScreen(
        title: 'Warm-up',
        prompt: 'Karma in Jainism is best described as:',
        choices: [
          Choice(
            choiceId: 'a',
            label: 'Magic punishment',
            isCorrect: false,
            feedbackCorrect: 'Correct.',
            feedbackWrong: 'Jain karma is not magic punishment.',
          ),
          Choice(
            choiceId: 'b',
            label: 'Subtle matter that can attach',
            isCorrect: true,
            feedbackCorrect: 'Correct. Karma is described as pudgal (matter).',
            feedbackWrong: 'Incorrect.',
          ),
        ],
      ),
      shortText: ShortTextScreen(
        cards: [
          TextCard(
            title: 'What is karma?',
            body: 'Karma is pudgal: subtle matter that can attach to the soul.',
          ),
          TextCard(
            title: 'How it binds',
            body: 'Actions plus intense emotion create stronger binding, like glue.',
          ),
          TextCard(
            title: 'States',
            body: 'Calm awareness supports a cleaner state; anger and attachment support a stickier state.',
          ),
        ],
      ),
      youtubeVideo: YoutubeVideoScreen(
        title: 'Story clip',
        note: 'Short clip on karma as subtle matter.',
        searchKeywords: [],
        videoAsset: 'assets/videos/youtubevideo.mp4',
        clipStartSeconds: 36,
        clipEndSeconds: 46,
      ),
      explanation: ExplanationScreen(
        sections: [
          ExplanationSection(
            title: 'Emotion as glue',
            body: 'The same action can bind differently depending on the emotion behind it.',
            scientificConnection: 'Stress increases impulsive reactions; calm reduces harmful choices.',
            realLifeAnalogy: 'Dust sticks more to wet hands than dry hands.',
          ),
          ExplanationSection(
            title: 'Pure vs impure states',
            body: 'Pure state: more awareness and less attachment. Impure state: more anger, ego, and craving.',
          ),
        ],
      ),
      quiz: QuizScreen(
        questions: [
          QuizQuestion(
            questionId: 'U01_L04_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'Karma is:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Pudgal (subtle matter)',
                isCorrect: true,
                feedbackCorrect: 'Correct! Karma is pudgal - subtle matter.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Random luck',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'Karma is not random. It follows cause and effect.',
              ),
            ],
          ),
        ],
      ),
      lessonComplete: LessonCompleteScreen(
        title: 'Lesson complete',
        rewardText: 'Badge unlocked: Karma Basics',
        nextLessonId: 'U01_L05',
      ),
    ),
  );

  // =========================================================================
  // Lesson 1.5: The Tirthankaras
  // =========================================================================

  static const _lesson5 = Lesson(
    lessonId: 'U01_L05',
    title: 'The Tirthankaras',
    learningObjectives: [
      'Define a Tirthankara',
      'Explain why they are called path-makers',
      'Name a few well-known Tirthankaras',
    ],
    screens: LessonScreens(
      questionIntro: QuestionIntroScreen(
        title: 'Warm-up',
        prompt: 'A Tirthankara is best described as:',
        choices: [
          Choice(
            choiceId: 'a',
            label: 'A warrior-king',
            isCorrect: false,
            feedbackCorrect: 'Correct.',
            feedbackWrong: 'Not quite. Tirthankaras are teachers, not conquerors.',
          ),
          Choice(
            choiceId: 'b',
            label: 'A path-maker who teaches liberation',
            isCorrect: true,
            feedbackCorrect: 'Correct. A Tirthankara re-shows the path to liberation.',
            feedbackWrong: 'Incorrect.',
          ),
        ],
      ),
      shortText: ShortTextScreen(
        cards: [
          TextCard(
            title: 'Who are they?',
            body: 'Tirthankaras are teachers who re-open the path to liberation in each time cycle.',
          ),
          TextCard(
            title: 'Why the name?',
            body: 'Tirtha means a crossing. They help souls cross from suffering to freedom.',
          ),
          TextCard(
            title: 'Key examples',
            body: 'Rishabhanatha (first), Parshvanatha, and Mahavira (24th) are well-known.',
          ),
        ],
      ),
      youtubeVideo: YoutubeVideoScreen(
        title: 'Story clip',
        note: 'Short clip on the Tirthankaras and their role.',
        searchKeywords: [],
        videoAsset: 'assets/videos/youtubevideo.mp4',
        clipStartSeconds: 48,
        clipEndSeconds: 58,
      ),
      explanation: ExplanationScreen(
        sections: [
          ExplanationSection(
            title: 'Path-makers',
            body: 'They rediscover and teach the Jain path when it is forgotten.',
          ),
          ExplanationSection(
            title: 'Why 24?',
            body: 'In this time cycle, 24 Tirthankaras are described, each renewing the teachings.',
          ),
        ],
      ),
      quiz: QuizScreen(
        questions: [
          QuizQuestion(
            questionId: 'U01_L05_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'A Tirthankara primarily:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Re-shows the path to liberation',
                isCorrect: true,
                feedbackCorrect: 'Correct! Tirthankaras are path-makers.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Leads armies',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'Not this. Their role is spiritual teaching.',
              ),
            ],
          ),
        ],
      ),
      lessonComplete: LessonCompleteScreen(
        title: 'Lesson complete',
        rewardText: 'Badge unlocked: Tirthankara Guide',
        nextLessonId: 'U01_MASTER_TEST',
      ),
    ),
  );

  // =========================================================================
  // Master Test: Mixed Quiz
  // =========================================================================

  static const _masterTest = Lesson(
    lessonId: 'U01_MASTER_TEST',
    title: 'Master Test',
    learningObjectives: [
      'Review key ideas from all lessons',
      'Apply core concepts across topics',
    ],
    screens: LessonScreens(
      questionIntro: QuestionIntroScreen(
        title: 'Master Test',
        prompt: 'Ready to mix everything you learned?',
        choices: [
          Choice(
            choiceId: 'a',
            label: 'Yes, let\'s go',
            isCorrect: true,
            feedbackCorrect: 'Great! Let\'s start.',
            feedbackWrong: '',
          ),
          Choice(
            choiceId: 'b',
            label: 'Not yet',
            isCorrect: false,
            feedbackCorrect: '',
            feedbackWrong: 'Take a breath and try anyway.',
          ),
        ],
      ),
      shortText: ShortTextScreen(
        cards: [
          TextCard(
            title: 'Mixed Review',
            body: 'This quiz blends questions from every course in Unit 1.',
          ),
        ],
      ),
      youtubeVideo: YoutubeVideoScreen(
        title: 'Story clip',
        note: 'Quick recap before the master test.',
        searchKeywords: [],
        videoAsset: 'assets/videos/youtubevideo.mp4',
        clipStartSeconds: 60,
        clipEndSeconds: 70,
      ),
      explanation: ExplanationScreen(
        sections: [
          ExplanationSection(
            title: 'Focus on clarity',
            body: 'Answer slowly and carefully. This is a summary of your progress.',
          ),
        ],
      ),
      quiz: QuizScreen(
        questions: [
          QuizQuestion(
            questionId: 'U01_MT_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'A Jina is someone who:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Conquers inner enemies',
                isCorrect: true,
                feedbackCorrect: 'Correct! Inner victory is the key.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Wins arguments',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'Not quite. Jainism focuses on inner discipline.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'U01_MT_q2',
            format: QuestionFormat.multipleChoice,
            prompt: 'Jiva means:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Living',
                isCorrect: true,
                feedbackCorrect: 'Right! Jiva is living.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Non-living',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'That\'s Ajiva.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'U01_MT_q3',
            format: QuestionFormat.multipleChoice,
            prompt: 'The soul is described as:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Eternal',
                isCorrect: true,
                feedbackCorrect: 'Correct! The soul is eternal.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Temporary',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'The soul is eternal; the body changes.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'U01_MT_q4',
            format: QuestionFormat.multipleChoice,
            prompt: 'Karma is best described as:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Subtle matter that can attach',
                isCorrect: true,
                feedbackCorrect: 'Correct! Karma is pudgal.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Random luck',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'Not in Jain philosophy.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'U01_MT_q5',
            format: QuestionFormat.multipleChoice,
            prompt: 'A Tirthankara is a:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Path-maker who teaches liberation',
                isCorrect: true,
                feedbackCorrect: 'Correct! They re-show the path.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Warrior-king',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'Not this. Their role is spiritual teaching.',
              ),
            ],
          ),
        ],
      ),
      lessonComplete: LessonCompleteScreen(
        title: 'Master test complete',
        rewardText: 'Badge unlocked: Unit Master',
        nextLessonId: null,
      ),
    ),
  );

  // =========================================================================
  // Badge definitions
  // =========================================================================

  static const List<BadgeDefinition> badges = [
    BadgeDefinition(
      id: 'BADGE_INNER_MASTERY_STARTER',
      name: 'Inner Mastery Starter',
      description: 'Completed your first lesson on Jainism fundamentals',
      trigger: 'complete_U01_L01',
    ),
    BadgeDefinition(
      id: 'BADGE_LIFE_OBSERVER',
      name: 'Life Observer',
      description: 'Learned the difference between Jiva and Ajiva',
      trigger: 'complete_U01_L02',
    ),
    BadgeDefinition(
      id: 'BADGE_SOUL_EXPLORER',
      name: 'Soul Explorer',
      description: 'Discovered the nature of the eternal soul',
      trigger: 'complete_U01_L03',
    ),
    BadgeDefinition(
      id: 'BADGE_KARMA_BASICS',
      name: 'Karma Basics',
      description: 'Understood the fundamentals of karma',
      trigger: 'complete_U01_L04',
    ),
    BadgeDefinition(
      id: 'BADGE_TIRTHANKARA_GUIDE',
      name: 'Tirthankara Guide',
      description: 'Learned the role of the Tirthankaras',
      trigger: 'complete_U01_L05',
    ),
    BadgeDefinition(
      id: 'BADGE_UNIT_MASTER',
      name: 'Unit Master',
      description: 'Passed the Unit 1 master test',
      trigger: 'complete_U01_MASTER_TEST',
    ),
  ];
}

