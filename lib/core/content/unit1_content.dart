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
    title: 'Essence of Jainism (AAA Core)',
    objectives: [
      'Explain Ahimsa, Anekantvad, and Aparigraha as one integrated framework',
      'Connect the Jain mission of "Live and Let Live" to modern decisions',
      'Apply AAA to thought, speech, action, and consumption',
    ],
    warmupPrompt: 'The strongest summary of Jain Way of Life is:',
    warmupCorrect:
        'Compassionate non-violence, open-mindedness, and contentment in daily choices',
    warmupWrong: 'Rituals alone, without lifestyle change',
    coreIdea:
        'Jainism can be lived as a practical operating system for modern life, centered on Triple A: Ahimsa (non-violence), Anekantvad (many-sided understanding), and Aparigraha (non-possessiveness). These are not abstract ideals; they are daily disciplines for reducing harm, ego, and excess while building clarity and inner stability.',
    whyItMatters:
        'When the AAA framework is practiced consistently, it improves relationships, lowers inner conflict, and creates a values-based way to navigate technology, social pressure, politics, and consumer culture. It turns spirituality into a repeatable life method.',
    practiceTip:
        'Before major choices, run a three-point check: Does this reduce harm? Does this respect other viewpoints? Does this reduce unnecessary attachment?',
    explanationKey:
        'These timeless principles remain valid, but their application must evolve for the modern world. AAA becomes the bridge between ancient wisdom and contemporary life complexity.',
    explanationPractice:
        'Use AAA as a daily reflection template in the morning and evening to convert values from belief into measurable behavior.',
    quizPrompt: 'The Jain AAA framework refers to:',
    quizCorrect: 'Ahimsa, Anekantvad, and Aparigraha',
    quizWrong: 'Asceticism, argument, and authority',
    nextLessonId: 'U01_L07',
  ),
  _LessonSeed(
    lessonId: 'U01_L07',
    title: 'What Is Jainism? A Practical Summary',
    objectives: [
      'Describe Jainism as both religion and way of life',
      'Explain "Live and Let Live" in practical terms',
      'Relate right conduct to spiritual and social wellbeing',
    ],
    warmupPrompt: '"Live and Let Live" most directly means:',
    warmupCorrect:
        'Live mindfully while allowing others dignity, safety, and freedom',
    warmupWrong: 'Stay passive and avoid all responsibility',
    coreIdea:
        'Jainism is presented as a living discipline where personal awakening and social ethics are inseparable. The mission is coexistence: to live consciously, reduce avoidable harm, and support the wellbeing of all life forms, not just human convenience.',
    whyItMatters:
        'This framing helps students understand Jainism beyond identity labels. It provides a clear moral direction for family life, school, work, and civic participation.',
    practiceTip:
        'Translate "Live and Let Live" into one concrete behavior each day, such as patient listening, mindful food choices, or non-reactive speech.',
    explanationKey:
        'Jain principles work as actionable guidance for contemporary dilemmas, not only as religious instruction for temple settings.',
    explanationPractice:
        'When conflict appears, ask: "How can I protect truth, compassion, and dignity at the same time?"',
    quizPrompt: 'Jainism in this course is best described as:',
    quizCorrect:
        'A way of life rooted in compassion, open-mindedness, and disciplined conduct',
    quizWrong: 'Only a system of ceremonies',
    nextLessonId: 'U01_L08',
  ),
  _LessonSeed(
    lessonId: 'U01_L08',
    title: 'The Jain Spectrum and Identity in Today\'s World',
    objectives: [
      'Recognize traditional, modern, AAA-focused, and newcomer pathways',
      'Respect diversity in belief while preserving core values',
      'Build inclusive Jain identity without dilution of ethics',
    ],
    warmupPrompt: 'The Jain spectrum teaches that:',
    warmupCorrect:
        'People can engage Jainism in different ways while staying grounded in core values',
    warmupWrong: 'Only one cultural style is authentic',
    coreIdea:
        'Jain identity can span a broad spectrum: deeply traditional practitioners, modern seekers, value-centered AAA practitioners, and newcomers. The unifying core is ethical alignment, especially Ahimsa, Anekantvad, and Aparigraha.',
    whyItMatters:
        'A spectrum model reduces judgment and encourages participation across generations, geographies, and backgrounds. It helps communities stay both principled and welcoming.',
    practiceTip:
        'In group settings, focus first on shared Jain values before debating differences in ritual detail.',
    explanationKey:
        'Identity is strongest when rooted in principles, not merely in labels or external conformity.',
    explanationPractice:
        'Practice intellectual humility: hold your tradition with devotion while engaging other Jain expressions with curiosity and respect.',
    quizPrompt: 'A balanced Jain identity is built on:',
    quizCorrect:
        'Shared ethical principles with respectful diversity in expression',
    quizWrong: 'Uniform behavior enforced without dialogue',
    nextLessonId: 'U01_L09',
  ),
  _LessonSeed(
    lessonId: 'U01_L09',
    title: 'Non-Violence (Ahimsa): Thought, Speech, Action',
    objectives: [
      'Define Ahimsa across inner and outer behavior',
      'Explain the cycle of violence vs circle of non-violence',
      'Apply forgiveness and restraint in daily conflict',
    ],
    warmupPrompt: 'Ahimsa is complete only when it includes:',
    warmupCorrect: 'Thoughts, words, actions, and lifestyle impact',
    warmupWrong: 'Only avoiding physical aggression',
    coreIdea:
        'Ahimsa is presented as the central force of Jain living. It expands non-violence from direct physical harm to emotional harm, verbal harm, systemic harm, and ecological harm, while highlighting forgiveness and compassion as active strengths.',
    whyItMatters:
        'Without this expanded definition, people may avoid obvious violence but still cause damage through speech, consumption, and indifference. Full Ahimsa builds trustworthy character and social healing.',
    practiceTip:
        'Pause before response: verify facts, soften tone, and choose language that protects truth without humiliating anyone.',
    explanationKey:
        'Ahimsa grows through practical ladders and circles of practice, starting with self-regulation and extending to family, society, animals, and environment.',
    explanationPractice:
        'End each day by reviewing one moment where anger could have become violence and redesign how you will respond next time.',
    quizPrompt: 'The most complete definition of Ahimsa is:',
    quizCorrect:
        'Reducing harm in thought, speech, action, and systems of living',
    quizWrong: 'Avoiding fights while ignoring speech and consumption',
    nextLessonId: 'U01_L10',
  ),
  _LessonSeed(
    lessonId: 'U01_L10',
    title: 'Non-Absolutism (Anekantvad) in a Polarized Age',
    objectives: [
      'Define Anekantvad as disciplined many-sided thinking',
      'Apply perspective-taking without moral confusion',
      'Use respectful disagreement in family and public life',
    ],
    warmupPrompt: 'Anekantvad teaches that:',
    warmupCorrect: 'No single viewpoint captures all aspects of truth',
    warmupWrong: 'Truth does not exist',
    coreIdea:
        'Anekantvad is a method for reducing dogmatism and improving dialogue. It does not deny truth; it trains us to recognize partial truths, context limits, and the need for humility when making claims.',
    whyItMatters:
        'In an era of social media conflict and ideological certainty, this practice prevents intellectual violence and supports wiser decisions in family, civic, and professional settings.',
    practiceTip:
        'When disagreement arises, first articulate the strongest version of the other person\'s view before presenting your own.',
    explanationKey:
        'Open-mindedness supports emotional maturity and social cohesion, especially in intergenerational and interfaith conversations.',
    explanationPractice:
        'Use phrases like "from one perspective" and "in this context" to keep claims precise, respectful, and testable.',
    quizPrompt: 'Anekantvad helps us:',
    quizCorrect: 'Seek fuller truth through humility and multiple perspectives',
    quizWrong: 'Defend one position regardless of evidence',
    nextLessonId: 'U01_L11',
  ),
  _LessonSeed(
    lessonId: 'U01_L11',
    title: 'Non-Possessiveness (Aparigraha) and Contentment',
    objectives: [
      'Differentiate need, comfort, and excess',
      'Connect attachment with stress, fear, and ego',
      'Design a simplicity practice for modern life',
    ],
    warmupPrompt: 'Aparigraha is best practiced by:',
    warmupCorrect: 'Reducing clinging while using resources responsibly',
    warmupWrong: 'Rejecting all ownership without context',
    coreIdea:
        'Aparigraha is freedom from compulsive accumulation, status anxiety, and identity built on possessions. It encourages conscious boundaries around buying, storing, showcasing, and consuming.',
    whyItMatters:
        'Attachment increases fear of loss, comparison, and chronic dissatisfaction. Non-possessiveness restores gratitude, generosity, and emotional balance.',
    practiceTip:
        'Create three categories for belongings: essential, useful, and excess; reduce one excess category each month.',
    explanationKey:
        'Minimalism and contentment support both spiritual calm and practical wellbeing in family finance and environmental impact.',
    explanationPractice:
        'Before purchasing, ask: "Will this serve my values long-term, or only my impulse right now?"',
    quizPrompt: 'Aparigraha primarily develops:',
    quizCorrect: 'Contentment, simplicity, and freedom from clinging',
    quizWrong: 'Pride in extreme deprivation',
    nextLessonId: 'U01_L12',
  ),
  _LessonSeed(
    lessonId: 'U01_L12',
    title: 'Unity and Diversity Among Jains',
    objectives: [
      'Recognize shared values across traditions',
      'Avoid sectarian ego while preserving authenticity',
      'Build cooperation in community life',
    ],
    warmupPrompt: 'Unity in Jainism is strongest when based on:',
    warmupCorrect: 'Shared ethics and mutual respect across traditions',
    warmupWrong: 'Ignoring all differences and context',
    coreIdea:
        'Diversity in ritual, language, and community practice can coexist with deep unity in Jain principles. The goal is not forced sameness but value-based solidarity.',
    whyItMatters:
        'Communities become resilient when they reduce internal fragmentation and focus on collective transmission of values to younger generations.',
    practiceTip:
        'In community discussions, separate principle-level agreement from method-level differences.',
    explanationKey:
        'Anekantvad is presented as the internal glue that allows diversity without hostility.',
    explanationPractice:
        'Use collaborative planning for events that include multiple Jain traditions while retaining each group\'s dignity.',
    quizPrompt: 'Healthy Jain unity looks like:',
    quizCorrect: 'Principled cooperation with respectful diversity',
    quizWrong: 'Uniformity achieved through criticism',
    nextLessonId: 'U01_L13',
  ),
  _LessonSeed(
    lessonId: 'U01_L13',
    title: 'Why Live Jain Values? 24 Practical Reasons',
    objectives: [
      'Summarize evidence-based benefits of Jain practices',
      'Connect ethics with happiness, leadership, and mental wellbeing',
      'Develop confidence in sharing Jain values publicly',
    ],
    warmupPrompt: 'The "24 reasons" lesson mainly argues that Jain living is:',
    warmupCorrect:
        'Spiritually deep and practically validated by modern outcomes',
    warmupWrong: 'Useful only in ancient social settings',
    coreIdea:
        'This lesson compiles practical, scientific, and social reasons to live and share Jain values, including emotional regulation, healthier habits, stronger leadership, environmental responsibility, and compassionate social behavior.',
    whyItMatters:
        'Students and families often ask whether ancient principles remain relevant today. This lesson answers with applied evidence and lived examples.',
    practiceTip:
        'Choose three reasons most meaningful to your life and convert each into a weekly habit goal.',
    explanationKey:
        'Jain values function as powerful life tools for children, professionals, families, and communities.',
    explanationPractice:
        'When explaining Jainism to others, combine value language with practical outcomes rather than abstract doctrine alone.',
    quizPrompt: 'The 24 reasons lesson positions Jain practice as:',
    quizCorrect:
        'A life system that supports wellbeing, ethics, and social harmony',
    quizWrong: 'A private belief with no practical impact',
    nextLessonId: 'U01_L14',
  ),
  _LessonSeed(
    lessonId: 'U01_L14',
    title: 'Vegetarian and Vegan Way of Life',
    objectives: [
      'Explain compassionate eating through Ahimsa',
      'Distinguish unmindful vegetarianism from value-based practice',
      'Create a realistic path toward balanced vegan choices',
    ],
    warmupPrompt: 'A Jain-aligned food path emphasizes:',
    warmupCorrect: 'Compassionate, mindful, and informed plant-based decisions',
    warmupWrong: 'Food rules without ethical understanding',
    coreIdea:
        'A Jain food ethic treats diet as daily ethics: what we eat directly expresses non-violence, restraint, and responsibility. It also encourages practical transitions, ingredient awareness, and gratitude toward all contributors in the food chain.',
    whyItMatters:
        'Food is the most frequent moral decision we make. Aligning diet with values reduces hidden harm and strengthens integrity between belief and behavior.',
    practiceTip:
        'Audit one week of meals, label each as compassionate or compromise-based, then plan one clear improvement for the next week.',
    explanationKey:
        'This self-evaluation model supports gradual, honest progress rather than guilt-based perfectionism.',
    explanationPractice:
        'Learn food labels carefully, ask respectful questions while eating out, and share your rationale through compassion rather than judgment.',
    quizPrompt: 'This lesson\'s food ethic centers on:',
    quizCorrect: 'Compassionate, mindful, and progressively plant-based living',
    quizWrong: 'Identity signaling through food labels only',
    nextLessonId: 'U01_L15',
  ),
  _LessonSeed(
    lessonId: 'U01_L15',
    title: 'A Typical Day: AM-PM JWOL Practice',
    objectives: [
      'Build a short daily spiritual routine',
      'Integrate prayer, meditation, and self-study in limited time',
      'Use morning intention and evening review for consistency',
    ],
    warmupPrompt: 'A realistic daily JWOL routine should be:',
    warmupCorrect: 'Short, consistent, and value-focused',
    warmupWrong: 'Long but irregular and unsustainable',
    coreIdea:
        'A practical morning-evening structure can be done in minutes: mindful prayer, brief meditation, value recall, and self-review. The emphasis is consistency over intensity.',
    whyItMatters:
        'Without daily rhythm, values remain inspirational but unstable. Small routines create compounding inner discipline and emotional steadiness.',
    practiceTip:
        'Start with a 5-7 minute AM-PM routine and protect it like a non-negotiable appointment with your highest self.',
    explanationKey:
        'Daily structure is presented as the bridge between aspiration and transformation.',
    explanationPractice:
        'Use the morning to set intention and the evening to assess where you aligned or drifted from Ahimsa, Anekantvad, and Aparigraha.',
    quizPrompt: 'The key to daily Jain practice is:',
    quizCorrect: 'Regularity with sincere attention, even in short sessions',
    quizWrong: 'Occasional intense effort only',
    nextLessonId: 'U01_L16',
  ),
  _LessonSeed(
    lessonId: 'U01_L16',
    title: 'Measuring Progress in Jain Way of Life',
    objectives: [
      'Use self-evaluation honestly without self-condemnation',
      'Track progress across food, behavior, and mindset',
      'Set milestone-based growth targets',
    ],
    warmupPrompt: 'A good spiritual progress system should:',
    warmupCorrect: 'Increase awareness and guide steady improvement',
    warmupWrong: 'Create guilt and comparison',
    coreIdea:
        'The progress framework encourages staged growth from unawareness to mindful and enriched practice. It emphasizes truthful self-assessment, gratitude, and visible next steps.',
    whyItMatters:
        'What is not measured is rarely improved. Reflection with compassion creates momentum and prevents denial or performative spirituality.',
    practiceTip:
        'Pick one category each week, rate your current level honestly, and define one behavior that moves you one level higher.',
    explanationKey:
        'Progress is framed as directional, not perfection-based, and rooted in repeatable habits.',
    explanationPractice:
        'Review monthly with accountability: what improved, what slipped, and what support systems you need to continue advancing.',
    quizPrompt: 'The purpose of JWOL self-evaluation is to:',
    quizCorrect: 'Build awareness and guide practical growth',
    quizWrong: 'Judge others and claim superiority',
    nextLessonId: 'U01_L17',
  ),
  _LessonSeed(
    lessonId: 'U01_L17',
    title: 'My Mind and My Body',
    objectives: [
      'Connect emotional hygiene to spiritual discipline',
      'Understand stress, habits, and self-regulation',
      'Apply mind-body practices for balanced living',
    ],
    warmupPrompt: 'Mind-body Jain practice is about:',
    warmupCorrect: 'Caring for mental and physical wellbeing as part of dharma',
    warmupWrong: 'Ignoring health in the name of spirituality',
    coreIdea:
        'Jain discipline includes mental and physical wellbeing, showing that ethical living requires a stable mind and healthy body. Habits, rest, movement, and mindful attention all support better choices.',
    whyItMatters:
        'A distressed mind increases reactivity, anger, and attachment. Mental and bodily care strengthens capacity for Ahimsa and equanimity.',
    practiceTip:
        'Anchor one daily reset: breath awareness, short walk, mindful eating, or digital pause before sleep.',
    explanationKey:
        'Wellbeing practices are spiritual infrastructure, not optional lifestyle extras.',
    explanationPractice:
        'Notice triggers that weaken your restraint and redesign your routine to protect calm and clarity.',
    quizPrompt: 'Caring for mind and body in Jain practice is:',
    quizCorrect: 'A core support for ethical and spiritual consistency',
    quizWrong: 'Unrelated to spiritual progress',
    nextLessonId: 'U01_L18',
  ),
  _LessonSeed(
    lessonId: 'U01_L18',
    title: 'My Things: Ownership, Simplicity, Responsibility',
    objectives: [
      'Audit possession habits through Aparigraha',
      'Reduce clutter and symbolic consumption',
      'Adopt responsible buying and sharing practices',
    ],
    warmupPrompt: 'A Jain approach to possessions asks:',
    warmupCorrect:
        'Do these things serve life, or do they control my attention?',
    warmupWrong: 'How can I display more status quickly?',
    coreIdea:
        'This lesson reframes possessions as tools, not identity markers. It encourages thoughtful acquisition, maintenance, sharing, and release so material life supports, rather than dominates, inner life.',
    whyItMatters:
        'Unchecked possession patterns drain time, money, and attention while increasing ego comparison and anxiety.',
    practiceTip:
        'For every new non-essential purchase, release or donate one similar item you already own.',
    explanationKey:
        'Practical non-possessiveness includes mindful purchasing, longer product use, and reduced waste.',
    explanationPractice:
        'Track impulse buying cues and replace one with a value-based pause routine before checkout.',
    quizPrompt: 'Responsible ownership in JWOL means:',
    quizCorrect:
        'Using possessions with restraint, purpose, and accountability',
    quizWrong: 'Collecting more to feel secure',
    nextLessonId: 'U01_L19',
  ),
  _LessonSeed(
    lessonId: 'U01_L19',
    title: 'My Consumptions: Food, Media, and Mind Inputs',
    objectives: [
      'Expand consumption ethics beyond food',
      'Evaluate media, products, and habits through Ahimsa',
      'Build mindful boundaries for digital and material intake',
    ],
    warmupPrompt: 'In JWOL, consumption includes:',
    warmupCorrect: 'What we eat, watch, buy, repeat, and mentally absorb',
    warmupWrong: 'Only the food we consume',
    coreIdea:
        'Self-evaluation shows that consumption is multidimensional: diet, digital media, entertainment, purchasing, and emotional content. Each input shapes consciousness and conduct.',
    whyItMatters:
        'Unfiltered consumption drives agitation, imitation, and attachment. Mindful curation protects focus and character.',
    practiceTip:
        'Run a weekly input audit: identify one nourishing input to increase and one harmful input to reduce.',
    explanationKey:
        'Awareness-based consumption supports both spiritual clarity and practical mental health.',
    explanationPractice:
        'Before consuming content, ask whether it increases compassion, wisdom, and calm or fuels craving and reactivity.',
    quizPrompt: 'Mindful consumption in JWOL is:',
    quizCorrect:
        'A full-spectrum practice covering food, media, products, and mental habits',
    quizWrong: 'Only a dietary checklist',
    nextLessonId: 'U01_L20',
  ),
  _LessonSeed(
    lessonId: 'U01_L20',
    title: 'My Life and My World: Ecology and Responsibility',
    objectives: [
      'Connect Jain ethics with environmental stewardship',
      'Understand interdependence of personal and planetary choices',
      'Practice compassion toward animals and ecosystems',
    ],
    warmupPrompt: 'JWOL environmental responsibility begins with:',
    warmupCorrect:
        'Daily personal choices in food, transport, waste, and consumption',
    warmupWrong: 'Waiting for institutions alone to act',
    coreIdea:
        'Ahimsa extends to planetary scale, showing that climate, pollution, waste, and animal exploitation are ethical as well as ecological concerns. Personal habits are treated as moral votes.',
    whyItMatters:
        'Jain non-violence loses force if limited to interpersonal behavior while ignoring environmental harm that affects countless life forms.',
    practiceTip:
        'Choose one high-impact practice this month: reduce food waste, lower disposable use, or shift to lower-harm transport habits.',
    explanationKey:
        'Environmental responsibility is a direct extension of Jain compassion and restraint.',
    explanationPractice:
        'Evaluate recurring routines by footprint: what can be reduced, repaired, reused, or replaced with lower-harm alternatives?',
    quizPrompt: 'A Jain ecological ethic is:',
    quizCorrect:
        'Ahimsa applied to all life systems, not only human interactions',
    quizWrong: 'Separate from spiritual practice',
    nextLessonId: 'U01_L21',
  ),
  _LessonSeed(
    lessonId: 'U01_L21',
    title: 'Spiritual Progress: Inner Growth and Gunsthan Mindset',
    objectives: [
      'Understand spiritual growth as staged and disciplined',
      'Connect self-awareness with reduction of passions',
      'Use gradual progression without discouragement',
    ],
    warmupPrompt: 'Spiritual growth in Jainism is presented as:',
    warmupCorrect: 'A progressive path of purification and awareness',
    warmupWrong: 'A sudden event with no preparation',
    coreIdea:
        'Spiritual progress is a gradual refinement of belief, knowledge, and conduct. Movement happens by reducing anger, ego, deceit, and greed while strengthening discipline and equanimity.',
    whyItMatters:
        'A staged model prevents frustration and helps practitioners remain committed during setbacks.',
    practiceTip:
        'Track one passion pattern weekly (anger, pride, deceit, greed) and document specific reduction strategies.',
    explanationKey:
        'The path framework converts spirituality from vague aspiration into structured personal development.',
    explanationPractice:
        'Celebrate small victories in restraint and clarity; consistency across months matters more than dramatic episodes.',
    quizPrompt: 'A realistic Jain view of spiritual progress is:',
    quizCorrect: 'Gradual purification through disciplined practice',
    quizWrong: 'Instant perfection without inner work',
    nextLessonId: 'U01_L22',
  ),
  _LessonSeed(
    lessonId: 'U01_L22',
    title: 'Many Dimensions of Violence (Himsa)',
    objectives: [
      'Identify physical, verbal, emotional, structural, and ecological violence',
      'Recognize subtle violence in intent and indifference',
      'Design prevention strategies in daily life',
    ],
    warmupPrompt: 'A deep study of Himsa teaches that violence can be:',
    warmupCorrect: 'Direct, indirect, subtle, systemic, and normalized',
    warmupWrong: 'Only physical injury',
    coreIdea:
        'This lesson broadens awareness by showing how harm appears in lifestyle, language, commerce, and social systems. It invites practitioners to detect violence not just in obvious acts but in normalized patterns that degrade life.',
    whyItMatters:
        'Without this lens, people unknowingly cooperate with harmful systems while believing they are non-violent.',
    practiceTip:
        'Map one daily routine and identify hidden harm points; redesign one step to reduce impact.',
    explanationKey:
        'Non-violence requires active discernment, not passive self-image.',
    explanationPractice:
        'Evaluate choices by effect on vulnerable beings, future generations, and ecosystems, not only immediate convenience.',
    quizPrompt: 'Understanding Himsa deeply helps us:',
    quizCorrect: 'Detect and reduce both visible and subtle forms of harm',
    quizWrong: 'Limit ethics to obvious physical aggression',
    nextLessonId: 'U01_L23',
  ),
  _LessonSeed(
    lessonId: 'U01_L23',
    title: 'Food Dharma: Health, Purchasing, and Eating Out',
    objectives: [
      'Apply compassion and health principles to food planning',
      'Make responsible purchasing decisions',
      'Navigate restaurants and social eating with values intact',
    ],
    warmupPrompt: 'Responsible Jain food practice includes:',
    warmupCorrect:
        'Nutrition, compassion, ingredient awareness, and ethical purchasing',
    warmupWrong: 'Taste preference without ethical review',
    coreIdea:
        'This lesson combines non-violence with practical nutrition and purchasing discipline. It covers balanced plant-based choices, ingredient transparency, restaurant strategy, and gratitude-driven food culture.',
    whyItMatters:
        'Food behavior influences health, emotion, environment, and moral consistency every single day.',
    practiceTip:
        'Prepare a values-first food plan before social events so convenience does not override conviction.',
    explanationKey:
        'A Jain food ethic encourages informed and compassionate decision-making rather than rigid identity posturing.',
    explanationPractice:
        'Ask where food comes from, how it is produced, and who is affected across the full supply chain.',
    quizPrompt: 'Food dharma in this lesson means:',
    quizCorrect:
        'Compassionate, informed, and health-conscious eating and purchasing',
    quizWrong: 'Unquestioned routine eating',
    nextLessonId: 'U01_L24',
  ),
  _LessonSeed(
    lessonId: 'U01_L24',
    title: 'Family Life: Parenting, Marriage, and Home Values',
    objectives: [
      'Build a Jain value framework for family decisions',
      'Apply compassionate boundaries in marriage expectations',
      'Raise children with ethics, discipline, and openness',
    ],
    warmupPrompt: 'A Jain family framework is strongest when:',
    warmupCorrect:
        'Core values are discussed early, clearly, and practiced consistently',
    warmupWrong: 'Assumptions replace communication',
    coreIdea:
        'This lesson provides concrete guidance for raising children, setting marriage expectations, and building a values-aligned home culture. Diet, communication, conflict style, and spiritual routines are treated as foundational agreements.',
    whyItMatters:
        'Many future conflicts in relationships come from unspoken expectations. Value clarity protects trust and long-term harmony.',
    practiceTip:
        'Create a written family value charter covering food, speech norms, celebrations, giving, and digital boundaries.',
    explanationKey:
        'Family is the primary training ground where Jain values are transmitted by behavior, not lectures.',
    explanationPractice:
        'Use regular family check-ins to review alignment and gently correct drift without blame.',
    quizPrompt: 'In this lesson, strong Jain family culture is built through:',
    quizCorrect:
        'Early value alignment, clear commitments, and regular practice',
    quizWrong: 'Reactive decisions without shared principles',
    nextLessonId: 'U01_L25',
  ),
  _LessonSeed(
    lessonId: 'U01_L25',
    title: 'Self-Reflection, Meditation, and Mental Health',
    objectives: [
      'Use meditation and reflection to regulate emotions',
      'Understand neuroplasticity and habit rewiring',
      'Approach mental health with compassion and responsibility',
    ],
    warmupPrompt: 'Mental wellbeing in JWOL is supported by:',
    warmupCorrect:
        'Reflection, healthy routines, support systems, and mindful practices',
    warmupWrong: 'Suppressing emotions and avoiding help',
    coreIdea:
        'Jain reflection practices connect with modern insights on mental fitness and neuroplasticity. Repeated habits, thought patterns, and intentional routines can reshape emotional resilience and behavioral outcomes.',
    whyItMatters:
        'Untreated stress and comparison loops can erode ethics, relationships, and self-control. Mental wellbeing is not separate from spiritual progress.',
    practiceTip:
        'Build a daily 3-step reset: breath practice, journaling one reflection, and one act of gratitude or forgiveness.',
    explanationKey:
        'A healthy Jain approach destigmatizes mental health care and combines spiritual discipline with professional support when needed.',
    explanationPractice:
        'Treat emotional distress with honesty and compassion; seeking help is responsibility, not weakness.',
    quizPrompt: 'A Jain-aligned mental health approach includes:',
    quizCorrect: 'Mindful habits, compassion, and timely support',
    quizWrong: 'Ignoring symptoms in silence',
    nextLessonId: 'U01_L26',
  ),
  _LessonSeed(
    lessonId: 'U01_L26',
    title: 'Guidance for Youth and Responsible Living',
    objectives: [
      'Apply Jain values in school and social pressure contexts',
      'Practice mindful purchasing and donation ethics',
      'Align ambitions with integrity and compassion',
    ],
    warmupPrompt: 'Jain guidance for students emphasizes:',
    warmupCorrect:
        'Character, discipline, and ethical decision-making in real-world situations',
    warmupWrong: 'Academic success at any moral cost',
    coreIdea:
        'The guidance section gives practical frameworks for high school and young adults: peer pressure, identity, lifestyle choices, money habits, and purposeful giving. It emphasizes clarity before crisis.',
    whyItMatters:
        'Early adult decisions compound quickly. Values-based choices at this stage strongly influence future character and wellbeing.',
    practiceTip:
        'Before major decisions, list consequences for self, family, other beings, and long-term integrity.',
    explanationKey:
        'Responsible purchasing and thoughtful donation are presented as direct expressions of Aparigraha and Ahimsa.',
    explanationPractice:
        'Budget for giving and simplicity so generosity is planned behavior, not occasional emotion.',
    quizPrompt: 'Youth guidance in this lesson focuses on:',
    quizCorrect:
        'Ethical clarity, disciplined choices, and responsible consumption',
    quizWrong: 'Short-term approval and comparison',
    nextLessonId: 'U01_L27',
  ),
  _LessonSeed(
    lessonId: 'U01_L27',
    title: 'Workplace Excellence and Ethical Investing',
    objectives: [
      'Apply Jain core values in professional environments',
      'Practice non-violent communication and principled leadership',
      'Evaluate investments through ethical impact',
    ],
    warmupPrompt: 'A Jain approach to career success is:',
    warmupCorrect:
        'High performance aligned with compassion, integrity, and restraint',
    warmupWrong: 'Results regardless of harm',
    coreIdea:
        'Jain values support leadership quality, trust, collaboration, and long-term credibility in the workplace. Ethical investing extends this logic by aligning capital with non-harm and social responsibility.',
    whyItMatters:
        'Professional influence and financial choices shape many lives. Values must travel with us into boardrooms, markets, and decision systems.',
    practiceTip:
        'Use an ethics screen for career and investment decisions: harm profile, transparency, fairness, and sustainability.',
    explanationKey:
        'Jain ethics can become competitive strengths in complex professional environments, not obstacles to achievement.',
    explanationPractice:
        'Lead with clarity and empathy: protect people while solving problems decisively.',
    quizPrompt: 'Ethical Jain professionalism combines:',
    quizCorrect: 'Competence, compassion, and accountability',
    quizWrong: 'Achievement detached from values',
    nextLessonId: 'U01_L28',
  ),
  _LessonSeed(
    lessonId: 'U01_L28',
    title: 'Forgiveness: Releasing Harm and Rebuilding Trust',
    objectives: [
      'Understand forgiveness as strength, not weakness',
      'Differentiate accountability from revenge',
      'Practice apology, release, and relational repair',
    ],
    warmupPrompt: 'Jain forgiveness primarily helps us:',
    warmupCorrect: 'End cycles of resentment and restore inner freedom',
    warmupWrong: 'Ignore wrongdoing without discernment',
    coreIdea:
        'Forgiveness is emotional non-violence that protects both inner health and social harmony. It includes asking forgiveness, granting forgiveness, and making behavioral correction.',
    whyItMatters:
        'Resentment drains attention, hardens ego, and perpetuates conflict across families and communities. Forgiveness interrupts the violence cycle.',
    practiceTip:
        'Use a structured method: acknowledge harm, express remorse, make amends, and commit to changed behavior.',
    explanationKey:
        'Forgiveness in Jain thought coexists with truth and responsibility; it is not denial.',
    explanationPractice:
        'Practice periodic reconciliation rituals to clear old emotional debt before it becomes identity.',
    quizPrompt: 'In this lesson, forgiveness is:',
    quizCorrect:
        'A disciplined practice that releases resentment while honoring truth',
    quizWrong: 'Passive acceptance of repeated harm',
    nextLessonId: 'U01_L29',
  ),
  _LessonSeed(
    lessonId: 'U01_L29',
    title: 'Life Events, Festivals, and the Art of Dying',
    objectives: [
      'Align celebrations with Jain values',
      'Understand major festivals as ethical renewal',
      'Approach mortality with awareness and dignity',
    ],
    warmupPrompt: 'Jain festivals are most meaningful when they:',
    warmupCorrect:
        'Renew vows, humility, and compassion, not only social excitement',
    warmupWrong: 'Focus only on display and consumption',
    coreIdea:
        'Life events and festivals can connect rituals and major transitions to inner transformation. They also include death awareness as preparation for peaceful detachment and value-centered living.',
    whyItMatters:
        'When festivals lose ethical focus, they become performative. When linked to reflection and vows, they become engines of renewal.',
    practiceTip:
        'For each celebration, define one inner commitment, one family value action, and one compassion-based service act.',
    explanationKey:
        'The art of dying is framed as the culmination of a life trained in awareness, restraint, gratitude, and non-attachment.',
    explanationPractice:
        'Discuss life values and end-of-life intentions openly in families to reduce fear and increase meaningful living now.',
    quizPrompt: 'A Jain celebration is complete when it includes:',
    quizCorrect: 'Ritual, reflection, and renewed ethical commitment',
    quizWrong: 'Ritual without transformation',
    nextLessonId: 'U01_L30',
  ),
  _LessonSeed(
    lessonId: 'U01_L30',
    title: 'Equanimity, Pratikraman, and Lifelong Renewal',
    objectives: [
      'Practice equanimity under changing life conditions',
      'Use Pratikraman as systematic self-correction',
      'Create a long-term renewal plan for Jain living',
    ],
    warmupPrompt: 'Pratikraman is best understood as:',
    warmupCorrect:
        'Regular self-review, repentance, correction, and recommitment',
    warmupWrong: 'A one-time ritual event',
    coreIdea:
        'Jain life is a cycle of awareness, lapse detection, repair, and recommitment. Equanimity (Samayik spirit) and Pratikraman keep the practitioner honest, humble, and steadily improving.',
    whyItMatters:
        'Without reflection and correction, values decay into identity language. Renewal practices maintain spiritual credibility over decades.',
    practiceTip:
        'Schedule weekly self-audit across speech, consumption, relationships, and intentions; identify one correction and one gratitude each cycle.',
    explanationKey:
        'Lifelong practice depends on rhythm: reflection, forgiveness, discipline, and continuous learning from scriptures and lived experience.',
    explanationPractice:
        'Close each cycle with a clear next commitment so repentance becomes transformation, not repetition.',
    quizPrompt: 'The purpose of regular Pratikraman is to:',
    quizCorrect:
        'Continuously purify conduct through honest review and correction',
    quizWrong: 'Complete spirituality through ritual attendance alone',
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
      _lesson5,
      ..._generatedLessons,
      _masterTest,
    ],
  );

  static final List<Lesson> _generatedLessons = _buildGeneratedLessons();

  // =========================================================================
  // Lesson 1.1: What is Jainism?
  // =========================================================================

  // ignore: unused_field
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
            feedbackWrong:
                'Not this. The focus is self-control and reducing harm.',
          ),
          Choice(
            choiceId: 'b',
            label: 'Non-violence and self-mastery',
            isCorrect: true,
            feedbackCorrect:
                'Correct. Jainism emphasizes non-violence and inner discipline.',
            feedbackWrong: 'Incorrect.',
          ),
          Choice(
            choiceId: 'c',
            label: 'Winning arguments',
            isCorrect: false,
            feedbackCorrect: 'Correct.',
            feedbackWrong:
                'Not this. Jainism is more about choices and character than debate.',
          ),
        ],
      ),
      shortText: ShortTextScreen(
        cards: [
          TextCard(
            title: 'What is Jainism?',
            body:
                'Jainism is a way of living that trains you to reduce harm, strengthen self-control, and become calmer and clearer in daily life.',
          ),
          TextCard(
            title: 'Who are Jinas?',
            body:
                'A Jina is someone who has conquered inner enemies like anger, ego, greed, and jealousy. The real victory is inside.',
          ),
          TextCard(
            title: 'Key terms',
            body:
                'Jina: victor over inner enemies. Jinendra: respectful title linked to Jina. Tirthankara: a teacher who re-shows the path to liberation.',
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
            body:
                'The purpose is to reduce harm and attachment so the soul becomes clearer, like cleaning a foggy mirror.',
          ),
          ExplanationSection(
            title: 'Ahimsa in real life',
            body:
                'Ahimsa is not only physical non-violence. It includes how we speak, how we react, and how we treat living beings and nature.',
            scientificConnection:
                'Pausing before reacting helps the brain\'s self-control systems engage, reducing impulsive behavior.',
            realLifeAnalogy:
                'A pause button before replying to an angry message.',
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
                feedbackCorrect:
                    'That\'s right! A Jina conquers anger, ego, greed, and jealousy.',
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

  // ignore: unused_field
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
            body:
                'Jiva is living (has awareness). Ajiva is non-living (no awareness).',
          ),
          TextCard(
            title: 'Consciousness',
            body:
                'Consciousness means experiencing and responding in some form.',
          ),
          TextCard(
            title: '1-5 senses',
            body:
                'Living beings are grouped by senses, from 1-sense to 5-sense beings.',
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
            body:
                'Humans, animals, insects, and plants are living because they have awareness.',
          ),
          ExplanationSection(
            title: 'Non-living (Ajiva)',
            body:
                'Objects lack awareness. Jain philosophy also discusses time and space as non-living categories.',
          ),
          ExplanationSection(
            title: 'Senses ladder',
            body: '1-sense: touch. 2: taste. 3: smell. 4: sight. 5: hearing.',
            scientificConnection:
                'In biology, living things respond to stimuli; non-living objects do not respond on their own.',
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
                feedbackCorrect:
                    'Right! Jiva means living or having consciousness.',
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

  // ignore: unused_field
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
            body:
                'This means the soul has limitless potential for clarity, peace, and understanding when obstacles are removed.',
          ),
          TextCard(
            title: 'Why it feels limited',
            body:
                'Karma covers the soul like dust on a mirror or blur on a lens.',
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
            body:
                'The body changes like a costume; the soul is the experiencer.',
          ),
          ExplanationSection(
            title: 'Why binding happens',
            body:
                'Karma binds more when actions are mixed with intense anger, ego, greed, or attachment.',
            scientificConnection:
                'Strong emotions can hijack decision-making; calm improves self-control.',
            realLifeAnalogy:
                'Clean lens vs dirty lens: same world, different clarity.',
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
                feedbackCorrect:
                    'Right! The soul is eternal in Jain philosophy.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Temporary',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'The soul is eternal, only the body is temporary.',
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

  // ignore: unused_field
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
            body:
                'Actions plus intense emotion create stronger binding, like glue.',
          ),
          TextCard(
            title: 'States',
            body:
                'Calm awareness supports a cleaner state; anger and attachment support a stickier state.',
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
            body:
                'The same action can bind differently depending on the emotion behind it.',
            scientificConnection:
                'Stress increases impulsive reactions; calm reduces harmful choices.',
            realLifeAnalogy: 'Dust sticks more to wet hands than dry hands.',
          ),
          ExplanationSection(
            title: 'Pure vs impure states',
            body:
                'Pure state: more awareness and less attachment. Impure state: more anger, ego, and craving.',
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
                feedbackWrong:
                    'Karma is not random. It follows cause and effect.',
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
            feedbackWrong:
                'Not quite. Tirthankaras are teachers, not conquerors.',
          ),
          Choice(
            choiceId: 'b',
            label: 'A path-maker who teaches liberation',
            isCorrect: true,
            feedbackCorrect:
                'Correct. A Tirthankara re-shows the path to liberation.',
            feedbackWrong: 'Incorrect.',
          ),
        ],
      ),
      shortText: ShortTextScreen(
        cards: [
          TextCard(
            title: 'Who are they?',
            body:
                'Tirthankaras are teachers who re-open the path to liberation in each time cycle.',
          ),
          TextCard(
            title: 'Why the name?',
            body:
                'Tirtha means a crossing. They help souls cross from suffering to freedom.',
          ),
          TextCard(
            title: 'Key examples',
            body:
                'Rishabhanatha (first), Parshvanatha, and Mahavira (24th) are well-known.',
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
            body:
                'They rediscover and teach the Jain path when it is forgotten.',
          ),
          ExplanationSection(
            title: 'Why 24?',
            body:
                'In this time cycle, 24 Tirthankaras are described, each renewing the teachings.',
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
                searchKeywords: [],
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
            body:
                'This quiz reviews core ideas from the full Jain Way of Life curriculum in Unit 1.',
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
            body:
                'Answer slowly and carefully. This is a summary of your progress.',
          ),
        ],
      ),
      quiz: QuizScreen(
        questions: [
          QuizQuestion(
            questionId: 'U01_MT_q1',
            format: QuestionFormat.multipleChoice,
            prompt: 'The Jain AAA framework stands for:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Ahimsa, Anekantvad, and Aparigraha',
                isCorrect: true,
                feedbackCorrect:
                    'Correct! These three values anchor the Jain Way of Life.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Authority, austerity, and argument',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Not quite. The core is Ahimsa, Anekantvad, and Aparigraha.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'U01_MT_q2',
            format: QuestionFormat.multipleChoice,
            prompt: 'A complete practice of Ahimsa includes:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Thought, speech, action, and lifestyle impact',
                isCorrect: true,
                feedbackCorrect:
                    'Right! Ahimsa must be practiced at all these levels.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Only avoiding physical fights',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Too narrow. Ahimsa is broader than physical restraint.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'U01_MT_q3',
            format: QuestionFormat.multipleChoice,
            prompt: 'Anekantvad encourages us to:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Recognize partial perspectives and seek fuller truth',
                isCorrect: true,
                feedbackCorrect:
                    'Correct! Anekantvad builds humility and many-sided understanding.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Reject all viewpoints except our own',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong: 'That approach increases dogmatism, not wisdom.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'U01_MT_q4',
            format: QuestionFormat.multipleChoice,
            prompt: 'Aparigraha primarily develops:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Contentment and freedom from compulsive attachment',
                isCorrect: true,
                feedbackCorrect:
                    'Correct! Aparigraha reduces clinging and comparison.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Status through accumulation',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Not this. Aparigraha asks for restraint and simplicity.',
              ),
            ],
          ),
          QuizQuestion(
            questionId: 'U01_MT_q5',
            format: QuestionFormat.multipleChoice,
            prompt: 'The purpose of Pratikraman is to:',
            choices: [
              Choice(
                choiceId: 'a',
                label: 'Review, repent, correct, and recommit',
                isCorrect: true,
                feedbackCorrect:
                    'Correct! Pratikraman turns reflection into correction.',
                feedbackWrong: '',
              ),
              Choice(
                choiceId: 'b',
                label: 'Finish spiritual growth in one ritual',
                isCorrect: false,
                feedbackCorrect: '',
                feedbackWrong:
                    'Not quite. It is a continuous renewal practice, not a one-time completion.',
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
