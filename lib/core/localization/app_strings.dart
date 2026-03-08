import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_language.dart';
import 'language_provider.dart';

class AppStrings {
  static const Map<String, Map<AppLanguage, String>> _strings = {
    'preferred_language': {
      AppLanguage.english: 'Preferred language',
      AppLanguage.hindi: 'पसंदीदा भाषा',
      AppLanguage.gujarati: 'પસંદગીની ભાષા',
    },
    'set_up_profile': {
      AppLanguage.english: 'Set Up Your Profile',
      AppLanguage.hindi: 'अपनी प्रोफ़ाइल सेट करें',
      AppLanguage.gujarati: 'તમારી પ્રોફાઇલ સેટ કરો',
    },
    'update_profile': {
      AppLanguage.english: 'Update Profile',
      AppLanguage.hindi: 'प्रोफ़ाइल अपडेट करें',
      AppLanguage.gujarati: 'પ્રોફાઇલ અપડેટ કરો',
    },
    'personalize_learning': {
      AppLanguage.english: 'Let\'s personalize your learning journey',
      AppLanguage.hindi: 'आइए आपकी सीखने की यात्रा को व्यक्तिगत बनाते हैं',
      AppLanguage.gujarati: 'ચાલો તમારી શીખવાની યાત્રાને વ્યક્તિગત બનાવીએ',
    },
    'choose_avatar': {
      AppLanguage.english: 'Choose your avatar',
      AppLanguage.hindi: 'अपना अवतार चुनें',
      AppLanguage.gujarati: 'તમારો અવતાર પસંદ કરો',
    },
    'what_call_you': {
      AppLanguage.english: 'What should we call you?',
      AppLanguage.hindi: 'हम आपको क्या कहकर बुलाएँ?',
      AppLanguage.gujarati: 'અમારે તમને શું કહીને બોલાવવું?',
    },
    'enter_name': {
      AppLanguage.english: 'Enter your name',
      AppLanguage.hindi: 'अपना नाम दर्ज करें',
      AppLanguage.gujarati: 'તમારું નામ દાખલ કરો',
    },
    'how_old': {
      AppLanguage.english: 'How old are you?',
      AppLanguage.hindi: 'आपकी उम्र क्या है?',
      AppLanguage.gujarati: 'તમારી ઉંમર કેટલી છે?',
    },
    'enter_age': {
      AppLanguage.english: 'Enter your age',
      AppLanguage.hindi: 'अपनी उम्र दर्ज करें',
      AppLanguage.gujarati: 'તમારી ઉંમર દાખલ કરો',
    },
    'get_started': {
      AppLanguage.english: 'Get Started',
      AppLanguage.hindi: 'शुरू करें',
      AppLanguage.gujarati: 'શરૂ કરો',
    },
    'save': {
      AppLanguage.english: 'Save',
      AppLanguage.hindi: 'सेव करें',
      AppLanguage.gujarati: 'સેવ કરો',
    },
    'back': {
      AppLanguage.english: 'Back',
      AppLanguage.hindi: 'वापस',
      AppLanguage.gujarati: 'પાછા',
    },
    'check': {
      AppLanguage.english: 'Check',
      AppLanguage.hindi: 'जांचें',
      AppLanguage.gujarati: 'ચકાસો',
    },
    'next': {
      AppLanguage.english: 'Next',
      AppLanguage.hindi: 'अगला',
      AppLanguage.gujarati: 'આગળ',
    },
    'continue': {
      AppLanguage.english: 'Continue',
      AppLanguage.hindi: 'जारी रखें',
      AppLanguage.gujarati: 'ચાલુ રાખો',
    },
    'continue_to_quiz': {
      AppLanguage.english: 'Continue to Quiz',
      AppLanguage.hindi: 'क्विज़ पर जाएँ',
      AppLanguage.gujarati: 'ક્વિઝ તરફ આગળ વધો',
    },
    'deep_dive': {
      AppLanguage.english: 'Deep Dive',
      AppLanguage.hindi: 'गहराई से समझें',
      AppLanguage.gujarati: 'ઊંડાણથી સમજીએ',
    },
    'explore_concepts': {
      AppLanguage.english: 'Explore the concepts in detail',
      AppLanguage.hindi: 'विषयों को विस्तार से समझें',
      AppLanguage.gujarati: 'વિષયો ને વિગતે સમજો',
    },
    'science_connection': {
      AppLanguage.english: 'Science Connection',
      AppLanguage.hindi: 'विज्ञान से संबंध',
      AppLanguage.gujarati: 'વિજ્ઞાન સંબંધ',
    },
    'real_life_analogy': {
      AppLanguage.english: 'Real-Life Analogy',
      AppLanguage.hindi: 'जीवन से उदाहरण',
      AppLanguage.gujarati: 'જીવનમાંથી ઉદાહરણ',
    },
    'question_of': {
      AppLanguage.english: 'Question {current} of {total}',
      AppLanguage.hindi: 'प्रश्न {current} / {total}',
      AppLanguage.gujarati: 'પ્રશ્ન {current} માંથી {total}',
    },
    'check_answer': {
      AppLanguage.english: 'Check Answer',
      AppLanguage.hindi: 'उत्तर जांचें',
      AppLanguage.gujarati: 'જવાબ ચકાસો',
    },
    'complete_quiz': {
      AppLanguage.english: 'Complete Quiz',
      AppLanguage.hindi: 'क्विज़ पूरी करें',
      AppLanguage.gujarati: 'ક્વિઝ પૂર્ણ કરો',
    },
    'next_question': {
      AppLanguage.english: 'Next Question',
      AppLanguage.hindi: 'अगला प्रश्न',
      AppLanguage.gujarati: 'આગળનો પ્રશ્ન',
    },
    'true_label': {
      AppLanguage.english: 'True',
      AppLanguage.hindi: 'सही',
      AppLanguage.gujarati: 'સાચું',
    },
    'false_label': {
      AppLanguage.english: 'False',
      AppLanguage.hindi: 'गलत',
      AppLanguage.gujarati: 'ખોટું',
    },
    'thats_right': {
      AppLanguage.english: 'That\'s right!',
      AppLanguage.hindi: 'बिलकुल सही!',
      AppLanguage.gujarati: 'બિલકુલ સાચું!',
    },
    'correct_answer_is': {
      AppLanguage.english: 'The correct answer is {answer}.',
      AppLanguage.hindi: 'सही उत्तर है: {answer}.',
      AppLanguage.gujarati: 'સાચો જવાબ છે: {answer}.',
    },
    'correct': {
      AppLanguage.english: 'Correct',
      AppLanguage.hindi: 'सही',
      AppLanguage.gujarati: 'સાચું',
    },
    'not_quite': {
      AppLanguage.english: 'Not quite',
      AppLanguage.hindi: 'अभी नहीं',
      AppLanguage.gujarati: 'હજુ નથી',
    },
    'badge_earned': {
      AppLanguage.english: 'Badge Earned!',
      AppLanguage.hindi: 'बैज मिला!',
      AppLanguage.gujarati: 'બેજ મળ્યો!',
    },
    'perfect_score_bonus': {
      AppLanguage.english: 'Perfect Score Bonus!',
      AppLanguage.hindi: 'परफेक्ट स्कोर बोनस!',
      AppLanguage.gujarati: 'પરફેક્ટ સ્કોર બોનસ!',
    },
    'day_streak': {
      AppLanguage.english: '{count} Day Streak!',
      AppLanguage.hindi: '{count} दिन की निरंतरता!',
      AppLanguage.gujarati: '{count} દિવસની સ્ટ્રીક!',
    },
    'share_achievement': {
      AppLanguage.english: 'Share Achievement',
      AppLanguage.hindi: 'उपलब्धि साझा करें',
      AppLanguage.gujarati: 'ઉપલબ્ધિ શેર કરો',
    },
    'share_msg': {
      AppLanguage.english: 'I just earned {xp} XP in JainQuest!',
      AppLanguage.hindi: 'मैंने अभी JainQuest में {xp} XP कमाया!',
      AppLanguage.gujarati: 'હું હમણાં JainQuest માં {xp} XP મેળવ્યા!',
    },
    'guided_finish_first': {
      AppLanguage.english: 'Finish the first lesson, then continue.',
      AppLanguage.hindi: 'पहला पाठ पूरा करें, फिर आगे बढ़ें।',
      AppLanguage.gujarati: 'પહેલો પાઠ પૂરો કરો, પછી આગળ વધો.',
    },
    'guided_start_message': {
      AppLanguage.english: 'Start with this first lesson.',
      AppLanguage.hindi: 'इस पहले पाठ से शुरुआत करें।',
      AppLanguage.gujarati: 'આ પહેલા પાઠથી શરૂઆત કરો.',
    },
    'guided_finish_title': {
      AppLanguage.english: 'Finish The First Lesson',
      AppLanguage.hindi: 'पहला पाठ पूरा करें',
      AppLanguage.gujarati: 'પહેલો પાઠ પૂર્ણ કરો',
    },
    'guided_finish_message': {
      AppLanguage.english:
          'Complete all lesson screens and quiz. When this Continue button appears, move on.',
      AppLanguage.hindi:
          'पाठ की सभी स्क्रीन और क्विज़ पूरी करें। जब यह Continue बटन दिखे, आगे बढ़ें।',
      AppLanguage.gujarati:
          'પાઠની બધી સ્ક્રીન અને ક્વિઝ પૂર્ણ કરો. આ Continue બટન દેખાય ત્યારે આગળ વધો.',
    },
    'guided_reading_title': {
      AppLanguage.english: 'Reading',
      AppLanguage.hindi: 'पठन',
      AppLanguage.gujarati: 'વાંચન',
    },
    'guided_reading_message': {
      AppLanguage.english: 'Resources is your reading hub.',
      AppLanguage.hindi: 'Resources आपका पढ़ने का केंद्र है।',
      AppLanguage.gujarati: 'Resources તમારું વાંચન કેન્દ્ર છે.',
    },
    'guided_ask_guru_message': {
      AppLanguage.english: 'Use Ask Guru whenever you need help.',
      AppLanguage.hindi: 'जब भी मदद चाहिए, Ask Guru का उपयोग करें।',
      AppLanguage.gujarati: 'જ્યારે મદદ જોઈએ ત્યારે Ask Guru નો ઉપયોગ કરો.',
    },
    'guided_community_title': {
      AppLanguage.english: 'Community',
      AppLanguage.hindi: 'समुदाय',
      AppLanguage.gujarati: 'સમુદાય',
    },
    'guided_community_message': {
      AppLanguage.english: 'Join conversations with other learners here.',
      AppLanguage.hindi: 'यहाँ अन्य शिक्षार्थियों के साथ बातचीत करें।',
      AppLanguage.gujarati: 'અહીં અન્ય શીખનારાઓ સાથે ચર્ચામાં જોડાઓ.',
    },
    'guided_profile_title': {
      AppLanguage.english: 'Profile',
      AppLanguage.hindi: 'प्रोफ़ाइल',
      AppLanguage.gujarati: 'પ્રોફાઇલ',
    },
    'guided_profile_message': {
      AppLanguage.english: 'Track your progress, badges, and settings.',
      AppLanguage.hindi: 'अपनी प्रगति, बैज और सेटिंग्स देखें।',
      AppLanguage.gujarati: 'તમારી પ્રગતિ, બેજ અને સેટિંગ્સ જુઓ.',
    },
    'skip': {
      AppLanguage.english: 'Skip',
      AppLanguage.hindi: 'छोड़ें',
      AppLanguage.gujarati: 'સ્કિપ',
    },
    'ask_guru': {
      AppLanguage.english: 'Ask Guru',
      AppLanguage.hindi: 'गुरु से पूछें',
      AppLanguage.gujarati: 'ગુરુને પૂછો',
    },
    'type_question': {
      AppLanguage.english: 'Type your question...',
      AppLanguage.hindi: 'अपना प्रश्न लिखें...',
      AppLanguage.gujarati: 'તમારો પ્રશ્ન લખો...',
    },
    'please_enter_name': {
      AppLanguage.english: 'Please enter your name',
      AppLanguage.hindi: 'कृपया अपना नाम दर्ज करें',
      AppLanguage.gujarati: 'કૃપા કરીને તમારું નામ દાખલ કરો',
    },
    'please_enter_valid_age': {
      AppLanguage.english: 'Please enter a valid age',
      AppLanguage.hindi: 'कृपया सही उम्र दर्ज करें',
      AppLanguage.gujarati: 'કૃપા કરીને માન્ય ઉંમર દાખલ કરો',
    },
    'profile_setup_complete': {
      AppLanguage.english: 'Profile setup complete, {name}!',
      AppLanguage.hindi: 'प्रोफ़ाइल सेटअप पूरा हुआ, {name}!',
      AppLanguage.gujarati: 'પ્રોફાઇલ સેટઅપ પૂર્ણ થયું, {name}!',
    },
    'failed_to_save_profile': {
      AppLanguage.english: 'Failed to save profile. Please try again.',
      AppLanguage.hindi: 'प्रोफ़ाइल सेव नहीं हुई। कृपया फिर प्रयास करें।',
      AppLanguage.gujarati: 'પ્રોફાઇલ સેવ થઈ નહીં. કૃપા કરીને ફરી પ્રયત્ન કરો.',
    },
    'min_read': {
      AppLanguage.english: '{count} min read',
      AppLanguage.hindi: '{count} मिनट पढ़ाई',
      AppLanguage.gujarati: '{count} મિનિટ વાંચન',
    },
  };

  static String resolve(
    String key,
    AppLanguage language, {
    Map<String, String> args = const {},
  }) {
    final translated =
        _strings[key]?[language] ?? _strings[key]?[AppLanguage.english] ?? key;
    return _applyArgs(translated, args);
  }

  static String _applyArgs(String text, Map<String, String> args) {
    var out = text;
    args.forEach((placeholder, value) {
      out = out.replaceAll('{$placeholder}', value);
    });
    return out;
  }
}

extension AppStringContext on BuildContext {
  AppLanguage get appLanguage {
    final container = ProviderScope.containerOf(this, listen: false);
    return container.read(appLanguageProvider);
  }

  String t(String key, {Map<String, String> args = const {}}) {
    return AppStrings.resolve(key, appLanguage, args: args);
  }
}
