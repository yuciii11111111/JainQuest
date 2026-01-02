import '../models/lesson_models.dart';
import '../models/badge_definition.dart';

class _LessonSeed {
  final String lessonId;
  final String title;
  final List<String> objectives;
  final String warmupPrompt;
  final String warmupCorrect;
  final String warmupWrong;
  final String coreIdea;
  final String whyItMatters;
  final String practiceTip;
  final String explanationKey;
  final String explanationPractice;
  final String quizPrompt;
  final String quizCorrect;
  final String quizWrong;
  final String nextLessonId;

  const _LessonSeed({
    required this.lessonId,
    required this.title,
    required this.objectives,
    required this.warmupPrompt,
    required this.warmupCorrect,
    required this.warmupWrong,
    required this.coreIdea,
    required this.whyItMatters,
    required this.practiceTip,
    required this.explanationKey,
    required this.explanationPractice,
    required this.quizPrompt,
    required this.quizCorrect,
    required this.quizWrong,
    required this.nextLessonId,
  });
}

const List<_LessonSeed> _lessonSeeds = [
  _LessonSeed(
    lessonId: 'U01_L06',
    title: 'Three Jewels (Ratnatraya)',
    objectives: [
      'Name the three jewels',
      'Explain why they work together',
      'Apply the trio to a daily choice',
    ],
    warmupPrompt: 'Which set is called the Three Jewels?',
    warmupCorrect: 'Right view, right knowledge, right conduct',
    warmupWrong: 'Wealth, health, fame',
    coreIdea:
        'The Three Jewels are right view, right knowledge, and right conduct. They guide how to see, understand, and act.',
    whyItMatters:
        'Without all three, growth is uneven. Understanding needs action to become real.',
    practiceTip:
        'Before a choice, check if it fits right view, right knowledge, and right conduct.',
    explanationKey:
        'Right view is basic belief in non-violence and the soul. Right knowledge is accurate understanding. Right conduct is living those insights.',
    explanationPractice:
        'Use the three jewels as a quick compass for everyday decisions.',
    quizPrompt: 'Which trio makes up the Three Jewels?',
    quizCorrect: 'Right view, right knowledge, right conduct',
    quizWrong: 'Faith, luck, ritual',
    nextLessonId: 'U01_L07',
  ),
  _LessonSeed(
    lessonId: 'U01_L07',
    title: 'Five Great Vows (Mahavrata)',
    objectives: [
      'List the five great vows',
      'Know who takes the Mahavrata',
      'Describe their purpose',
    ],
    warmupPrompt: 'How many great vows are there?',
    warmupCorrect: 'Five',
    warmupWrong: 'Three',
    coreIdea:
        'Mahavrata are strict vows for monks and nuns: ahimsa, satya, asteya, brahmacharya, aparigraha.',
    whyItMatters:
        'They reduce harm and attachment at the deepest level.',
    practiceTip:
        'Householders use the same values in lighter, realistic ways.',
    explanationKey:
        'The five great vows are full commitments to non-violence, truth, non-stealing, celibacy, and non-attachment.',
    explanationPractice:
        'Even small choices can move toward these vows.',
    quizPrompt: 'Which list matches the five great vows?',
    quizCorrect:
        'Ahimsa, satya, asteya, brahmacharya, aparigraha',
    quizWrong: 'Prayer, fasting, charity, pilgrimage, ritual',
    nextLessonId: 'U01_L08',
  ),
  _LessonSeed(
    lessonId: 'U01_L08',
    title: 'Anuvrata (Small Vows)',
    objectives: [
      'Define anuvrata',
      'Know who practices them',
      'Explain their daily value',
    ],
    warmupPrompt: 'Anuvrata are mainly for:',
    warmupCorrect: 'Householders',
    warmupWrong: 'Only monks',
    coreIdea:
        'Anuvrata are smaller vows for laypeople, adapting the same values to daily life.',
    whyItMatters:
        'They make spiritual practice practical in family and work life.',
    practiceTip: 'Set one clear boundary like mindful speech.',
    explanationKey:
        'Anuvrata balance spiritual aims with real responsibilities.',
    explanationPractice:
        'Consistency matters more than intensity.',
    quizPrompt: 'Anuvrata are:',
    quizCorrect: 'Smaller vows for laypeople',
    quizWrong: 'Secret teachings for scholars',
    nextLessonId: 'U01_L09',
  ),
  _LessonSeed(
    lessonId: 'U01_L09',
    title: 'Ahimsa in Thought, Speech, Action',
    objectives: [
      'Explain ahimsa at three levels',
      'Recognize intention as part of action',
      'Practice a simple pause',
    ],
    warmupPrompt: 'Ahimsa includes:',
    warmupCorrect: 'Mind, speech, and body',
    warmupWrong: 'Only actions',
    coreIdea:
        'Non-violence starts in thoughts, shows in speech, and ends in actions.',
    whyItMatters:
        'Harm often begins in the mind before it appears outside.',
    practiceTip:
        'Pause before reacting and soften inner language.',
    explanationKey:
        'Jain ethics treats intention as part of the act.',
    explanationPractice:
        'Replace harsh judgment with curiosity.',
    quizPrompt: 'Ahimsa applies to which levels?',
    quizCorrect: 'Thought, speech, and action',
    quizWrong: 'Only physical action',
    nextLessonId: 'U01_L10',
  ),
  _LessonSeed(
    lessonId: 'U01_L10',
    title: 'Satya (Truthfulness)',
    objectives: [
      'Define satya',
      'Connect truth with non-violence',
      'Apply kind speech',
    ],
    warmupPrompt: 'Satya means:',
    warmupCorrect: 'Truthfulness with care',
    warmupWrong: 'Brutal honesty',
    coreIdea: 'Satya is truthful speech that avoids harm.',
    whyItMatters:
        'Truth without kindness can still hurt; Jainism balances both.',
    practiceTip: 'Speak what is true, useful, and gentle.',
    explanationKey: 'Satya is aligned with ahimsa.',
    explanationPractice:
        'Choose timing and tone that reduce harm.',
    quizPrompt: 'Satya is best described as:',
    quizCorrect: 'Truth spoken without harm',
    quizWrong: 'Saying everything you think',
    nextLessonId: 'U01_L11',
  ),
  _LessonSeed(
    lessonId: 'U01_L11',
    title: 'Asteya (Non-Stealing)',
    objectives: [
      'Define asteya',
      'Identify subtle forms of stealing',
      'Practice respect for resources',
    ],
    warmupPrompt: 'Asteya encourages:',
    warmupCorrect: 'Not taking what is not given',
    warmupWrong: 'Taking only small things',
    coreIdea: 'Asteya is non-stealing in actions and intentions.',
    whyItMatters: 'It builds trust and reduces greed.',
    practiceTip: 'Respect time, credit, and resources.',
    explanationKey:
        'Stealing includes subtle forms like plagiarism or wasting others time.',
    explanationPractice: 'Ask permission and give credit.',
    quizPrompt: 'Asteya means:',
    quizCorrect: 'Non-stealing',
    quizWrong: 'Non-speaking',
    nextLessonId: 'U01_L12',
  ),
  _LessonSeed(
    lessonId: 'U01_L12',
    title: 'Brahmacharya (Self-Restraint)',
    objectives: [
      'Define brahmacharya',
      'Explain householders practice',
      'See how restraint protects clarity',
    ],
    warmupPrompt: 'Brahmacharya focuses on:',
    warmupCorrect: 'Self-control in desires',
    warmupWrong: 'Ignoring relationships',
    coreIdea:
        'Brahmacharya is channeling energy wisely, not impulsively.',
    whyItMatters:
        'It protects clarity and prevents attachment from driving choices.',
    practiceTip: 'Notice triggers and choose moderation.',
    explanationKey:
        'For monks it is celibacy; for householders it is fidelity and restraint.',
    explanationPractice:
        'Respect boundaries in media and conversation.',
    quizPrompt: 'For householders, brahmacharya is closest to:',
    quizCorrect: 'Fidelity and restraint',
    quizWrong: 'Complete avoidance of all contact',
    nextLessonId: 'U01_L13',
  ),
  _LessonSeed(
    lessonId: 'U01_L13',
    title: 'Aparigraha (Non-Attachment)',
    objectives: [
      'Define aparigraha',
      'Explain attachment vs ownership',
      'Try a simplicity practice',
    ],
    warmupPrompt: 'Aparigraha is:',
    warmupCorrect: 'Non-attachment',
    warmupWrong: 'Collecting more',
    coreIdea: 'Aparigraha means limiting possessions and clinging.',
    whyItMatters:
        'Less attachment reduces fear and jealousy.',
    practiceTip: 'Simplify one area and share what you do not use.',
    explanationKey: 'Possessions are tools, not identity.',
    explanationPractice: 'Ask: do I own this, or does it own me?',
    quizPrompt: 'Aparigraha teaches:',
    quizCorrect: 'Non-attachment and simplicity',
    quizWrong: 'Luxury and display',
    nextLessonId: 'U01_L14',
  ),
  _LessonSeed(
    lessonId: 'U01_L14',
    title: 'Anekantavada (Many-Sided Reality)',
    objectives: [
      'Define anekantavada',
      'Reduce dogmatism',
      'Apply perspective-taking',
    ],
    warmupPrompt: 'Anekantavada teaches:',
    warmupCorrect: 'Many-sided reality',
    warmupWrong: 'Only one view',
    coreIdea:
        'Reality has many aspects; no single view captures all.',
    whyItMatters: 'It reduces dogmatism and conflict.',
    practiceTip: 'Ask what might be true from another angle.',
    explanationKey: 'Truth is complex, so humility is required.',
    explanationPractice: 'Listen to others to complete the picture.',
    quizPrompt: 'Anekantavada is the doctrine of:',
    quizCorrect: 'Many-sidedness',
    quizWrong: 'Single absolute view',
    nextLessonId: 'U01_L15',
  ),
  _LessonSeed(
    lessonId: 'U01_L15',
    title: 'Syadvada (Conditional Truth)',
    objectives: [
      'Define syadvada',
      'Use context in statements',
      'Avoid extremes',
    ],
    warmupPrompt: 'Syadvada is about:',
    warmupCorrect: 'Conditional statements',
    warmupWrong: 'No truth at all',
    coreIdea:
        'Syadvada uses "in some ways" to express partial truth.',
    whyItMatters: 'It helps communicate without extremes.',
    practiceTip: 'Add context before making strong claims.',
    explanationKey: 'Statements are valid in certain conditions.',
    explanationPractice: 'Use "from this perspective" to be precise.',
    quizPrompt: 'Syadvada emphasizes:',
    quizCorrect: 'Conditional truth',
    quizWrong: 'Random opinions',
    nextLessonId: 'U01_L16',
  ),
  _LessonSeed(
    lessonId: 'U01_L16',
    title: 'Nayavada (Viewpoints)',
    objectives: [
      'Define nayavada',
      'Understand partial viewpoints',
      'Combine perspectives for balance',
    ],
    warmupPrompt: 'Nayavada focuses on:',
    warmupCorrect: 'Viewpoints',
    warmupWrong: 'Ignoring evidence',
    coreIdea:
        'Nayavada is the study of viewpoints to understand reality.',
    whyItMatters: 'It trains careful thinking and fairness.',
    practiceTip: 'Separate the part from the whole in arguments.',
    explanationKey: 'Each naya highlights one aspect, not the whole.',
    explanationPractice:
        'Combine viewpoints for fuller understanding.',
    quizPrompt: 'Nayavada is best described as:',
    quizCorrect: 'A method of viewpoints',
    quizWrong: 'A rule of silence',
    nextLessonId: 'U01_L17',
  ),
  _LessonSeed(
    lessonId: 'U01_L17',
    title: 'Nav Tattva (Nine Realities)',
    objectives: [
      'Define nav tattva',
      'Recognize key categories',
      'Use them as a learning map',
    ],
    warmupPrompt: 'Nav Tattva means:',
    warmupCorrect: 'Nine realities',
    warmupWrong: 'Nine rituals',
    coreIdea:
        'Nine realities explain how the soul binds and frees from karma.',
    whyItMatters:
        'They provide a map of spiritual progress.',
    practiceTip: 'Identify what increases bondage and what stops it.',
    explanationKey:
        'Key categories include jiva, ajiva, asrava, bandha, samvara, nirjara, moksha, punya, papa.',
    explanationPractice:
        'Use them to review actions daily.',
    quizPrompt: 'Nav Tattva refers to:',
    quizCorrect: 'Nine fundamental realities',
    quizWrong: 'Nine temple festivals',
    nextLessonId: 'U01_L18',
  ),
  _LessonSeed(
    lessonId: 'U01_L18',
    title: 'Eight Types of Karma',
    objectives: [
      'Know there are eight main karma types',
      'Connect karma with experience',
      'Identify clarity-blocking karma',
    ],
    warmupPrompt: 'How many main karma types are taught?',
    warmupCorrect: 'Eight',
    warmupWrong: 'Four',
    coreIdea:
        'Jainism describes eight main karma types affecting knowledge, perception, energy, and more.',
    whyItMatters: 'It shows why souls experience limits.',
    practiceTip: 'Notice how emotions cloud clarity.',
    explanationKey:
        'Knowledge-obscuring and perception-obscuring karma are key categories.',
    explanationPractice: 'Cultivate calm to reduce new binding.',
    quizPrompt: 'Jainism describes how many main karma types?',
    quizCorrect: 'Eight',
    quizWrong: 'Ten',
    nextLessonId: 'U01_L19',
  ),
  _LessonSeed(
    lessonId: 'U01_L19',
    title: 'Leshya (Inner Colorations)',
    objectives: [
      'Define leshya',
      'Link emotions to inner color',
      'Shift toward brighter states',
    ],
    warmupPrompt: 'Leshya refers to:',
    warmupCorrect: 'Colorations of the soul',
    warmupWrong: 'Temple architecture',
    coreIdea:
        'Leshya are inner colorations shaped by emotions and intentions.',
    whyItMatters:
        'They show the quality of your inner state.',
    practiceTip: 'Shift from harsh to gentle intentions.',
    explanationKey:
        'Dark leshya come from anger and greed; bright leshya from compassion.',
    explanationPractice:
        'Choose thoughts that lighten your inner color.',
    quizPrompt: 'Leshya describes:',
    quizCorrect: 'Inner colorations from emotions',
    quizWrong: 'Outer clothing rules',
    nextLessonId: 'U01_L20',
  ),
  _LessonSeed(
    lessonId: 'U01_L20',
    title: 'Samvara (Stoppage)',
    objectives: [
      'Define samvara',
      'Explain how karma inflow stops',
      'Practice mindful restraint',
    ],
    warmupPrompt: 'Samvara means:',
    warmupCorrect: 'Stopping karma inflow',
    warmupWrong: 'Increasing karma',
    coreIdea:
        'Samvara is the stoppage of new karma through discipline.',
    whyItMatters:
        'Without stopping inflow, shedding is slower.',
    practiceTip:
        'Use vows and mindfulness to reduce harmful actions.',
    explanationKey: 'Right conduct seals the leaks.',
    explanationPractice: 'Track one habit that invites negativity.',
    quizPrompt: 'Samvara is:',
    quizCorrect: 'Stoppage of karma inflow',
    quizWrong: 'Collection of more karma',
    nextLessonId: 'U01_L21',
  ),
  _LessonSeed(
    lessonId: 'U01_L21',
    title: 'Nirjara (Shedding Karma)',
    objectives: [
      'Define nirjara',
      'Know it removes existing karma',
      'Connect it with tapas',
    ],
    warmupPrompt: 'Nirjara is:',
    warmupCorrect: 'Shedding karma',
    warmupWrong: 'Binding karma',
    coreIdea: 'Nirjara is the removal of existing karma.',
    whyItMatters: 'It clears the soul over time.',
    practiceTip: 'Practice forgiveness and austerity.',
    explanationKey: 'Shedding happens naturally and through tapas.',
    explanationPractice:
        'Choose voluntary discipline to speed up clarity.',
    quizPrompt: 'Nirjara means:',
    quizCorrect: 'Shedding existing karma',
    quizWrong: 'Hiding karma',
    nextLessonId: 'U01_L22',
  ),
  _LessonSeed(
    lessonId: 'U01_L22',
    title: 'Moksha (Liberation)',
    objectives: [
      'Define moksha',
      'Explain freedom from rebirth',
      'Link daily actions to liberation',
    ],
    warmupPrompt: 'Moksha is:',
    warmupCorrect: 'Liberation',
    warmupWrong: 'Rebirth',
    coreIdea:
        'Moksha is freedom from the cycle of birth and death.',
    whyItMatters:
        'It is the ultimate goal of Jain practice.',
    practiceTip:
        'Align goals with inner freedom, not just external success.',
    explanationKey:
        'Liberation comes when karma is fully shed.',
    explanationPractice:
        'Small steps of detachment point toward moksha.',
    quizPrompt: 'Moksha refers to:',
    quizCorrect: 'Liberation from rebirth',
    quizWrong: 'A holy pilgrimage site',
    nextLessonId: 'U01_L23',
  ),
  _LessonSeed(
    lessonId: 'U01_L23',
    title: 'Gupti (Three Controls)',
    objectives: [
      'Define gupti',
      'Name the three controls',
      'Practice mindful restraint',
    ],
    warmupPrompt: 'Gupti are:',
    warmupCorrect: 'Controls of mind, speech, body',
    warmupWrong: 'Festival days',
    coreIdea: 'Gupti are the three controls that protect conduct.',
    whyItMatters: 'They prevent impulsive harm.',
    practiceTip:
        'Guard one channel for a day: mind, speech, or body.',
    explanationKey:
        'Control is not suppression; it is conscious direction.',
    explanationPractice: 'Slow down before acting.',
    quizPrompt: 'Gupti refers to control of:',
    quizCorrect: 'Mind, speech, and body',
    quizWrong: 'Weather and seasons',
    nextLessonId: 'U01_L24',
  ),
  _LessonSeed(
    lessonId: 'U01_L24',
    title: 'Samiti (Careful Conduct)',
    objectives: [
      'Define samiti',
      'Know it reduces accidental harm',
      'Apply mindfulness in routine',
    ],
    warmupPrompt: 'Samiti means:',
    warmupCorrect: 'Careful conduct',
    warmupWrong: 'Ignoring details',
    coreIdea:
        'Samiti are five careful practices to reduce harm.',
    whyItMatters:
        'Attention prevents accidental violence.',
    practiceTip: 'Walk, speak, and handle objects mindfully.',
    explanationKey:
        'Examples include careful walking and careful speech.',
    explanationPractice:
        'Mindfulness turns routine into compassion.',
    quizPrompt: 'Samiti refers to:',
    quizCorrect: 'Careful conduct to avoid harm',
    quizWrong: 'Fast ritual chanting',
    nextLessonId: 'U01_L25',
  ),
  _LessonSeed(
    lessonId: 'U01_L25',
    title: 'Tapas (Austerity)',
    objectives: [
      'Define tapas',
      'Differentiate external and internal tapas',
      'Use discipline wisely',
    ],
    warmupPrompt: 'Tapas are:',
    warmupCorrect: 'Austerities and discipline',
    warmupWrong: 'Luxury comforts',
    coreIdea:
        'Tapas are disciplines that reduce attachment and ego.',
    whyItMatters: 'They strengthen will and clarity.',
    practiceTip: 'Try a simple fast or reduced indulgence.',
    explanationKey: 'There are external and internal tapas.',
    explanationPractice:
        'Use discipline for insight, not pride.',
    quizPrompt: 'Tapas means:',
    quizCorrect: 'Austerity and disciplined practice',
    quizWrong: 'Entertainment and festivals',
    nextLessonId: 'U01_L26',
  ),
  _LessonSeed(
    lessonId: 'U01_L26',
    title: 'Paryushan (Renewal)',
    objectives: [
      'Identify Paryushan as a Jain festival',
      'Connect it with repentance',
      'Practice forgiveness',
    ],
    warmupPrompt: 'Paryushan is:',
    warmupCorrect: 'A period of reflection and restraint',
    warmupWrong: 'A harvest festival',
    coreIdea:
        'Paryushan is a Jain festival focused on repentance and renewal.',
    whyItMatters: 'It refreshes vows and relationships.',
    practiceTip: 'Do pratikraman and ask forgiveness.',
    explanationKey:
        'Forgiveness is central: "Micchami Dukkadam".',
    explanationPractice: 'Clear old resentments.',
    quizPrompt: 'Paryushan emphasizes:',
    quizCorrect: 'Reflection, fasting, and forgiveness',
    quizWrong: 'Competitive sports',
    nextLessonId: 'U01_L27',
  ),
  _LessonSeed(
    lessonId: 'U01_L27',
    title: 'Samayik (Equanimity)',
    objectives: [
      'Define samayik',
      'Connect it with calm awareness',
      'Practice brief meditation',
    ],
    warmupPrompt: 'Samayik is:',
    warmupCorrect: 'A practice of equanimity',
    warmupWrong: 'A business meeting',
    coreIdea:
        'Samayik is meditative equanimity, staying balanced.',
    whyItMatters:
        'It trains the mind to stay calm amid change.',
    practiceTip:
        'Sit quietly and observe thoughts without reacting.',
    explanationKey:
        'Equanimity reduces new karma binding.',
    explanationPractice:
        'Consistency builds inner stability.',
    quizPrompt: 'Samayik focuses on:',
    quizCorrect: 'Equanimity and inner balance',
    quizWrong: 'Public debates',
    nextLessonId: 'U01_L28',
  ),
  _LessonSeed(
    lessonId: 'U01_L28',
    title: 'Pratikraman (Self-Review)',
    objectives: [
      'Define pratikraman',
      'See how it reduces ego',
      'Make a simple review habit',
    ],
    warmupPrompt: 'Pratikraman is:',
    warmupCorrect: 'Self-review and repentance',
    warmupWrong: 'Celebrating victories',
    coreIdea:
        'Pratikraman is a practice of reflecting and correcting mistakes.',
    whyItMatters:
        'It prevents repetition and softens ego.',
    practiceTip: 'Review the day and resolve to improve.',
    explanationKey:
        'It includes confession, apology, and resolve.',
    explanationPractice:
        'Honest review reduces inner baggage.',
    quizPrompt: 'Pratikraman is best described as:',
    quizCorrect: 'Self-review with repentance',
    quizWrong: 'A travel ceremony',
    nextLessonId: 'U01_L29',
  ),
  _LessonSeed(
    lessonId: 'U01_L29',
    title: 'Jain Cosmology (Loka)',
    objectives: [
      'Identify Jain cosmology as a worldview',
      'Know the universe is eternal',
      'Keep focus on ethics',
    ],
    warmupPrompt: 'Jain cosmology describes:',
    warmupCorrect: 'The structure of the universe',
    warmupWrong: 'Only one planet',
    coreIdea:
        'Jain cosmology describes a universe with distinct realms and no creator god.',
    whyItMatters:
        'It frames spiritual progress in a vast context.',
    practiceTip: 'Focus on ethics rather than speculation.',
    explanationKey:
        'The loka is finite in shape but eternal in existence.',
    explanationPractice:
        'Use cosmology as inspiration for humility.',
    quizPrompt: 'Jain cosmology teaches that the universe is:',
    quizCorrect: 'Eternal and structured in realms',
    quizWrong: 'Created once and then ended',
    nextLessonId: 'U01_L30',
  ),
  _LessonSeed(
    lessonId: 'U01_L30',
    title: 'Pancha Parameshti',
    objectives: [
      'Name the five supreme beings',
      'Know their role in the path',
      'Connect them to the Navkar Mantra',
    ],
    warmupPrompt: 'Pancha Parameshti refers to:',
    warmupCorrect: 'Five supreme beings',
    warmupWrong: 'Five elements',
    coreIdea:
        'The five supreme beings are Arihant, Siddha, Acharya, Upadhyaya, and Sadhu.',
    whyItMatters:
        'They represent stages and roles on the path.',
    practiceTip: 'Offer respect to the qualities they embody.',
    explanationKey:
        'Navkar Mantra honors these five, not any one personality.',
    explanationPractice:
        'Use their qualities as personal ideals.',
    quizPrompt: 'Pancha Parameshti are:',
    quizCorrect: 'Arihant, Siddha, Acharya, Upadhyaya, Sadhu',
    quizWrong: 'Earth, water, fire, air, space',
    nextLessonId: 'U01_MASTER_TEST',
  ),
];

/// Complete Unit 1 content: Foundations of Jainism
/// Contains 30 lessons plus a master test
class Unit1Content {
  static final Unit unit = Unit(
    id: 'UNIT_01',
    title: 'Foundations of Jainism',
    level: 'Beginner',
    lessons: [
      _lesson1,
      _lesson2,
      _lesson3,
      _lesson4,
      _lesson5,
      ..._generatedLessons,
      _masterTest,
    ],
  );

  static final List<Lesson> _generatedLessons = _buildGeneratedLessons();

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
        nextLessonId: 'U01_L06',
      ),
    ),
  );

  static List<Lesson> _buildGeneratedLessons() {
    return _lessonSeeds
        .map(
          (seed) => Lesson(
            lessonId: seed.lessonId,
            title: seed.title,
            learningObjectives: seed.objectives,
            screens: LessonScreens(
              questionIntro: QuestionIntroScreen(
                title: 'Warm-up',
                prompt: seed.warmupPrompt,
                choices: [
                  Choice(
                    choiceId: 'a',
                    label: seed.warmupWrong,
                    isCorrect: false,
                    feedbackCorrect: 'Correct.',
                    feedbackWrong: 'Not quite. ${seed.warmupCorrect}.',
                  ),
                  Choice(
                    choiceId: 'b',
                    label: seed.warmupCorrect,
                    isCorrect: true,
                    feedbackCorrect: 'Correct!',
                    feedbackWrong: 'Incorrect.',
                  ),
                ],
              ),
              shortText: ShortTextScreen(
                cards: [
                  TextCard(
                    title: 'Core idea',
                    body: seed.coreIdea,
                  ),
                  TextCard(
                    title: 'Why it matters',
                    body: seed.whyItMatters,
                  ),
                  TextCard(
                    title: 'Everyday practice',
                    body: seed.practiceTip,
                  ),
                ],
              ),
              youtubeVideo: const YoutubeVideoScreen(
                title: 'Story clip',
                note: 'Short clip to connect the idea to daily life.',
                searchKeywords: const [],
                videoAsset: 'assets/videos/youtubevideo.mp4',
                clipStartSeconds: 0,
                clipEndSeconds: 10,
              ),
              explanation: ExplanationScreen(
                sections: [
                  ExplanationSection(
                    title: 'Key concept',
                    body: seed.explanationKey,
                  ),
                  ExplanationSection(
                    title: 'In practice',
                    body: seed.explanationPractice,
                  ),
                ],
              ),
              quiz: QuizScreen(
                questions: [
                  QuizQuestion(
                    questionId: '${seed.lessonId}_q1',
                    format: QuestionFormat.multipleChoice,
                    prompt: seed.quizPrompt,
                    choices: [
                      Choice(
                        choiceId: 'a',
                        label: seed.quizCorrect,
                        isCorrect: true,
                        feedbackCorrect: 'Correct!',
                        feedbackWrong: '',
                      ),
                      Choice(
                        choiceId: 'b',
                        label: seed.quizWrong,
                        isCorrect: false,
                        feedbackCorrect: '',
                        feedbackWrong: 'Not quite. ${seed.quizCorrect}.',
                      ),
                    ],
                  ),
                ],
              ),
              lessonComplete: LessonCompleteScreen(
                title: 'Lesson complete',
                rewardText: 'Lesson complete',
                nextLessonId: seed.nextLessonId,
              ),
            ),
          ),
        )
        .toList();
  }

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

