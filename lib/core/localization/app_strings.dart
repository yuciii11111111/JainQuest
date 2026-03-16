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
      AppLanguage.english: 'Profile Photo',
      AppLanguage.hindi: 'प्रोफ़ाइल फोटो',
      AppLanguage.gujarati: 'પ્રોફાઇલ ફોટો',
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
    'auto_logging_in': {
      AppLanguage.english: 'Auto logging you in...',
      AppLanguage.hindi: 'आपको अपने-आप लॉग इन किया जा रहा है...',
      AppLanguage.gujarati: 'તમને આપમેળે લૉગ ઇન કરવામાં આવી રહ્યા છે...',
    },
    'restoring_progress': {
      AppLanguage.english: 'Restoring your progress and getting things ready.',
      AppLanguage.hindi:
          'आपकी प्रगति बहाल की जा रही है और सब कुछ तैयार किया जा रहा है।',
      AppLanguage.gujarati:
          'તમારી પ્રગતિ ફરી લાવવામાં આવી રહી છે અને બધું તૈયાર કરવામાં આવી રહ્યું છે.',
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
    'answer_xp': {
      AppLanguage.english: 'Answer XP',
      AppLanguage.hindi: 'उत्तर XP',
      AppLanguage.gujarati: 'જવાબ XP',
    },
    'first_completion_bonus': {
      AppLanguage.english: 'First Completion Bonus',
      AppLanguage.hindi: 'पहली पूर्णता बोनस',
      AppLanguage.gujarati: 'પ્રથમ પૂર્ણતા બોનસ',
    },
    'session_total_xp': {
      AppLanguage.english: 'Session Total',
      AppLanguage.hindi: 'सत्र कुल',
      AppLanguage.gujarati: 'સેશન કુલ',
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
    'your_question': {
      AppLanguage.english: 'Your question',
      AppLanguage.hindi: 'आपका प्रश्न',
      AppLanguage.gujarati: 'તમારો પ્રશ્ન',
    },
    'type_question': {
      AppLanguage.english: 'Type your question…',
      AppLanguage.hindi: 'अपना प्रश्न लिखें…',
      AppLanguage.gujarati: 'તમારો પ્રશ્ન લખો…',
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
    'profile_save_timed_out': {
      AppLanguage.english:
          'Saving is taking too long. Check your connection and try again.',
      AppLanguage.hindi:
          'सेव होने में बहुत समय लग रहा है। अपना कनेक्शन जांचें और फिर प्रयास करें।',
      AppLanguage.gujarati:
          'સેવ થવામાં ઘણો સમય લાગી રહ્યો છે. તમારું કનેક્શન તપાસો અને ફરી પ્રયત્ન કરો.',
    },
    'profile_saved_photo_failed': {
      AppLanguage.english:
          'Profile saved, but the photo upload did not finish. You can try the photo again from Profile.',
      AppLanguage.hindi:
          'प्रोफ़ाइल सेव हो गई, लेकिन फोटो अपलोड पूरा नहीं हुआ। आप प्रोफ़ाइल से फोटो फिर से आज़मा सकते हैं।',
      AppLanguage.gujarati:
          'પ્રોફાઇલ સેવ થઈ ગઈ, પરંતુ ફોટો અપલોડ પૂર્ણ થયું નથી. તમે પ્રોફાઇલમાંથી ફોટો ફરી પ્રયત્ન કરી શકો છો.',
    },
    'photo_picker_permission_denied': {
      AppLanguage.english:
          'Could not access your photos. Check app permissions and try again.',
      AppLanguage.hindi:
          'आपकी फ़ोटो तक पहुंच नहीं मिली। ऐप की अनुमति जांचें और फिर प्रयास करें।',
      AppLanguage.gujarati:
          'તમારા ફોટાઓનો ઍક્સેસ મળ્યો નથી. એપની પરવાનગીઓ તપાસો અને ફરી પ્રયત્ન કરો.',
    },
    'photo_picker_busy': {
      AppLanguage.english:
          'Photo picker is already open. Finish that step and try again.',
      AppLanguage.hindi:
          'फोटो चुनने वाली विंडो पहले से खुली है। उसे पूरा करके फिर प्रयास करें।',
      AppLanguage.gujarati:
          'ફોટો પસંદ કરવાની વિન્ડો પહેલેથી ખુલ્લી છે. તેને પૂર્ણ કરીને ફરી પ્રયત્ન કરો.',
    },
    'photo_picker_invalid_image': {
      AppLanguage.english:
          'That photo could not be read. Try choosing a different image.',
      AppLanguage.hindi: 'इस फोटो को पढ़ा नहीं जा सका। कोई दूसरी तस्वीर चुनें।',
      AppLanguage.gujarati:
          'આ ફોટો વાંચી શકાયો નથી. કૃપા કરીને બીજી તસવીર પસંદ કરો.',
    },
    'photo_picker_unavailable': {
      AppLanguage.english:
          'Could not open the photo picker on this device. Try again.',
      AppLanguage.hindi:
          'इस डिवाइस पर फोटो चुनने वाली विंडो नहीं खुल सकी। फिर प्रयास करें।',
      AppLanguage.gujarati:
          'આ ઉપકરણ પર ફોટો પસંદ કરવાની વિન્ડો ખુલી શકી નથી. ફરી પ્રયત્ન કરો.',
    },
    'photo_picker_failed': {
      AppLanguage.english:
          'Could not choose a photo right now. Please try again.',
      AppLanguage.hindi: 'अभी फोटो नहीं चुनी जा सकी। कृपया फिर प्रयास करें।',
      AppLanguage.gujarati:
          'હમણાં ફોટો પસંદ થઈ શક્યો નથી. કૃપા કરીને ફરી પ્રયત્ન કરો.',
    },
    'min_read': {
      AppLanguage.english: '{count} min read',
      AppLanguage.hindi: '{count} मिनट पढ़ाई',
      AppLanguage.gujarati: '{count} મિનિટ વાંચન',
    },

    // Profile setup
    'tap_to_upload_photo': {
      AppLanguage.english: 'Tap to upload photo',
      AppLanguage.hindi: 'फोटो अपलोड करने के लिए टैप करें',
      AppLanguage.gujarati: 'ફોટો અપલોડ કરવા ટેપ કરો',
    },
    'change_photo': {
      AppLanguage.english: 'Change photo',
      AppLanguage.hindi: 'फोटो बदलें',
      AppLanguage.gujarati: 'ફોટો બદલો',
    },
    'remove_photo': {
      AppLanguage.english: 'Remove photo',
      AppLanguage.hindi: 'फोटो हटाएं',
      AppLanguage.gujarati: 'ફોટો દૂર કરો',
    },

    // Auth flow
    'google_signin_failed': {
      AppLanguage.english: 'Google sign-in failed. Please try again.',
      AppLanguage.hindi: 'Google साइन-इन विफल हुआ। कृपया फिर प्रयास करें।',
      AppLanguage.gujarati:
          'Google સાઇન-ઇન નિષ્ફળ. કૃપા કરીને ફરી પ્રયત્ન કરો.',
    },
    'enter_valid_email': {
      AppLanguage.english: 'Enter a valid email address.',
      AppLanguage.hindi: 'एक वैध ईमेल पता दर्ज करें।',
      AppLanguage.gujarati: 'માન્ય ઈમેલ સરનામું દાખલ કરો.',
    },
    'password_min_chars': {
      AppLanguage.english: 'Use at least 6 characters for the password.',
      AppLanguage.hindi: 'पासवर्ड के लिए कम से कम 6 अक्षर उपयोग करें।',
      AppLanguage.gujarati: 'પાસવર્ડ માટે ઓછામાં ઓછા 6 અક્ષરો વાપરો.',
    },
    'passwords_no_match': {
      AppLanguage.english: 'Passwords do not match.',
      AppLanguage.hindi: 'पासवर्ड मेल नहीं खाते।',
      AppLanguage.gujarati: 'પાસવર્ડ મેળ ખાતા નથી.',
    },
    'show_password': {
      AppLanguage.english: 'Show password',
      AppLanguage.hindi: 'पासवर्ड दिखाएं',
      AppLanguage.gujarati: 'પાસવર્ડ બતાવો',
    },
    'hide_password': {
      AppLanguage.english: 'Hide password',
      AppLanguage.hindi: 'पासवर्ड छिपाएं',
      AppLanguage.gujarati: 'પાસવર્ડ છુપાવો',
    },
    'unable_create_account': {
      AppLanguage.english: 'Unable to create account.',
      AppLanguage.hindi: 'खाता बनाने में असमर्थ।',
      AppLanguage.gujarati: 'એકાઉન્ટ બનાવવામાં અસમર્થ.',
    },
    'unable_login': {
      AppLanguage.english: 'Unable to log in.',
      AppLanguage.hindi: 'लॉग इन करने में असमर्थ।',
      AppLanguage.gujarati: 'લૉગ ઇન કરવામાં અસમર્થ.',
    },
    'auth_failed': {
      AppLanguage.english: 'Authentication failed.',
      AppLanguage.hindi: 'प्रमाणीकरण विफल।',
      AppLanguage.gujarati: 'પ્રમાણીકરણ નિષ્ફળ.',
    },
    'auth_failed_retry': {
      AppLanguage.english: 'Authentication failed. Please try again.',
      AppLanguage.hindi: 'प्रमाणीकरण विफल। कृपया फिर प्रयास करें।',
      AppLanguage.gujarati: 'પ્રમાણીકરણ નિષ્ફળ. કૃપા કરીને ફરી પ્રયત્ન કરો.',
    },
    'sign_up': {
      AppLanguage.english: 'Sign up',
      AppLanguage.hindi: 'साइन अप करें',
      AppLanguage.gujarati: 'સાઇન અપ',
    },
    'already_have_account': {
      AppLanguage.english: 'I already have an account',
      AppLanguage.hindi: 'मेरा पहले से खाता है',
      AppLanguage.gujarati: 'મારું પહેલેથી એકાઉન્ટ છે',
    },
    'create_your_account': {
      AppLanguage.english: 'Create your account',
      AppLanguage.hindi: 'अपना खाता बनाएं',
      AppLanguage.gujarati: 'તમારું એકાઉન્ટ બનાવો',
    },
    'welcome_back_title': {
      AppLanguage.english: 'Welcome back',
      AppLanguage.hindi: 'वापस स्वागत है',
      AppLanguage.gujarati: 'ફરી સ્વાગત છે',
    },
    'continue_with_google': {
      AppLanguage.english: 'Continue with Google',
      AppLanguage.hindi: 'Google से जारी रखें',
      AppLanguage.gujarati: 'Google સાથે ચાલુ રાખો',
    },
    'enter_email_address': {
      AppLanguage.english: 'Enter email address',
      AppLanguage.hindi: 'ईमेल पता दर्ज करें',
      AppLanguage.gujarati: 'ઈમેલ સરનામું દાખલ કરો',
    },
    'enter_your_email': {
      AppLanguage.english: 'Enter your email',
      AppLanguage.hindi: 'अपना ईमेल दर्ज करें',
      AppLanguage.gujarati: 'તમારો ઈમેલ દાખલ કરો',
    },
    'email_address': {
      AppLanguage.english: 'Email address',
      AppLanguage.hindi: 'ईमेल पता',
      AppLanguage.gujarati: 'ઈમેલ સરનામું',
    },
    'confirm_password_title': {
      AppLanguage.english: 'Confirm your password',
      AppLanguage.hindi: 'अपना पासवर्ड पुष्टि करें',
      AppLanguage.gujarati: 'તમારો પાસવર્ડ પુષ્ટિ કરો',
    },
    'set_password': {
      AppLanguage.english: 'Set your password',
      AppLanguage.hindi: 'अपना पासवर्ड सेट करें',
      AppLanguage.gujarati: 'તમારો પાસવર્ડ સેટ કરો',
    },
    'password_hint': {
      AppLanguage.english: 'Password',
      AppLanguage.hindi: 'पासवर्ड',
      AppLanguage.gujarati: 'પાસવર્ડ',
    },
    'confirm_password_hint': {
      AppLanguage.english: 'Confirm password',
      AppLanguage.hindi: 'पासवर्ड पुष्टि करें',
      AppLanguage.gujarati: 'પાસવર્ડ પુષ્ટિ કરો',
    },
    'create_account': {
      AppLanguage.english: 'Create account',
      AppLanguage.hindi: 'खाता बनाएं',
      AppLanguage.gujarati: 'એકાઉન્ટ બનાવો',
    },
    'log_in': {
      AppLanguage.english: 'Log in',
      AppLanguage.hindi: 'लॉग इन',
      AppLanguage.gujarati: 'લૉગ ઇન',
    },
    'welcome': {
      AppLanguage.english: 'Welcome',
      AppLanguage.hindi: 'स्वागत है',
      AppLanguage.gujarati: 'સ્વાગત છે',
    },
    'account_ready': {
      AppLanguage.english: 'Your account is ready.',
      AppLanguage.hindi: 'आपका खाता तैयार है।',
      AppLanguage.gujarati: 'તમારું એકાઉન્ટ તૈયાર છે.',
    },
    'continue_with_app': {
      AppLanguage.english: 'Continue with the app',
      AppLanguage.hindi: 'ऐप के साथ जारी रखें',
      AppLanguage.gujarati: 'ઍપ સાથે ચાલુ રાખો',
    },
    'please_wait': {
      AppLanguage.english: 'Please wait…',
      AppLanguage.hindi: 'कृपया प्रतीक्षा करें…',
      AppLanguage.gujarati: 'કૃપા કરીને રાહ જુઓ…',
    },

    // Home screen
    'home': {
      AppLanguage.english: 'Home',
      AppLanguage.hindi: 'होम',
      AppLanguage.gujarati: 'હોમ',
    },
    'resources': {
      AppLanguage.english: 'Resources',
      AppLanguage.hindi: 'संसाधन',
      AppLanguage.gujarati: 'સંસાધનો',
    },
    'ask': {
      AppLanguage.english: 'Ask',
      AppLanguage.hindi: 'पूछें',
      AppLanguage.gujarati: 'પૂછો',
    },
    'community': {
      AppLanguage.english: 'Community',
      AppLanguage.hindi: 'समुदाय',
      AppLanguage.gujarati: 'સમુદાય',
    },
    'profile': {
      AppLanguage.english: 'Profile',
      AppLanguage.hindi: 'प्रोफ़ाइल',
      AppLanguage.gujarati: 'પ્રોફાઇલ',
    },
    'welcome_back_comma': {
      AppLanguage.english: 'Welcome back,',
      AppLanguage.hindi: 'वापस स्वागत,',
      AppLanguage.gujarati: 'ફરી સ્વાગત,',
    },
    'explorer': {
      AppLanguage.english: 'Explorer',
      AppLanguage.hindi: 'खोजकर्ता',
      AppLanguage.gujarati: 'અન્વેષક',
    },
    'xp': {
      AppLanguage.english: 'XP',
      AppLanguage.hindi: 'XP',
      AppLanguage.gujarati: 'XP',
    },
    'day_streak_label': {
      AppLanguage.english: 'day streak',
      AppLanguage.hindi: 'दिन की स्ट्रीक',
      AppLanguage.gujarati: 'દિવસની સ્ટ્રીક',
    },
    'hearts': {
      AppLanguage.english: 'hearts',
      AppLanguage.hindi: 'दिल',
      AppLanguage.gujarati: 'હાર્ટ્સ',
    },
    'daily_goal': {
      AppLanguage.english: 'Daily Goal',
      AppLanguage.hindi: 'दैनिक लक्ष्य',
      AppLanguage.gujarati: 'દૈનિક લક્ષ્ય',
    },
    'lessons_completed_of': {
      AppLanguage.english: '{count}/3 lessons completed',
      AppLanguage.hindi: '{count}/3 पाठ पूरे',
      AppLanguage.gujarati: '{count}/3 પાઠ પૂર્ણ',
    },
    'current_lesson': {
      AppLanguage.english: 'Current Lesson',
      AppLanguage.hindi: 'वर्तमान पाठ',
      AppLanguage.gujarati: 'વર્તમાન પાઠ',
    },
    'view_progress': {
      AppLanguage.english: 'View Progress',
      AppLanguage.hindi: 'प्रगति देखें',
      AppLanguage.gujarati: 'પ્રગતિ જુઓ',
    },
    'show_guide': {
      AppLanguage.english: 'Show Guide',
      AppLanguage.hindi: 'गाइड दिखाएं',
      AppLanguage.gujarati: 'ગાઇડ બતાવો',
    },
    'switch_to_light_mode': {
      AppLanguage.english: 'Switch to light mode',
      AppLanguage.hindi: 'लाइट मोड पर जाएं',
      AppLanguage.gujarati: 'લાઇટ મોડ પર જાઓ',
    },
    'switch_to_dark_mode': {
      AppLanguage.english: 'Switch to dark mode',
      AppLanguage.hindi: 'डार्क मोड पर जाएं',
      AppLanguage.gujarati: 'ડાર્ક મોડ પર જાઓ',
    },
    'percent_progress': {
      AppLanguage.english: '{value}% progress',
      AppLanguage.hindi: '{value}% प्रगति',
      AppLanguage.gujarati: '{value}% પ્રગતિ',
    },

    // Profile screen
    'learner': {
      AppLanguage.english: 'Learner',
      AppLanguage.hindi: 'शिक्षार्थी',
      AppLanguage.gujarati: 'શીખનાર',
    },
    'points': {
      AppLanguage.english: 'Points',
      AppLanguage.hindi: 'अंक',
      AppLanguage.gujarati: 'પોઇન્ટ્સ',
    },
    'world': {
      AppLanguage.english: 'World',
      AppLanguage.hindi: 'विश्व',
      AppLanguage.gujarati: 'વિશ્વ',
    },
    'local': {
      AppLanguage.english: 'Local',
      AppLanguage.hindi: 'स्थानीय',
      AppLanguage.gujarati: 'સ્થાનિક',
    },
    'sign_out': {
      AppLanguage.english: 'Sign out',
      AppLanguage.hindi: 'साइन आउट',
      AppLanguage.gujarati: 'સાઇન આઉટ',
    },
    'your_badges': {
      AppLanguage.english: 'Your Badges',
      AppLanguage.hindi: 'आपके बैज',
      AppLanguage.gujarati: 'તમારા બેજ',
    },
    'earned_of_total': {
      AppLanguage.english: '{earned} of {total} earned',
      AppLanguage.hindi: '{total} में से {earned} प्राप्त',
      AppLanguage.gujarati: '{total} માંથી {earned} પ્રાપ્ત',
    },
    'locked_badge': {
      AppLanguage.english: 'Locked - Complete challenges to unlock',
      AppLanguage.hindi: 'लॉक - अनलॉक करने के लिए चुनौतियां पूरी करें',
      AppLanguage.gujarati: 'લૉક - અનલૉક કરવા ચેલેન્જ પૂર્ણ કરો',
    },
    'close': {
      AppLanguage.english: 'Close',
      AppLanguage.hindi: 'बंद करें',
      AppLanguage.gujarati: 'બંધ કરો',
    },
    'progress': {
      AppLanguage.english: 'Progress',
      AppLanguage.hindi: 'प्रगति',
      AppLanguage.gujarati: 'પ્રગતિ',
    },
    'keep_going': {
      AppLanguage.english: 'Keep going to reach the next level.',
      AppLanguage.hindi: 'अगले स्तर तक पहुंचने के लिए जारी रखें।',
      AppLanguage.gujarati: 'આગળના સ્તર સુધી પહોંચવા ચાલુ રાખો.',
    },
    'xp_to_next_level': {
      AppLanguage.english: 'XP to next level',
      AppLanguage.hindi: 'अगले स्तर तक XP',
      AppLanguage.gujarati: 'આગળના સ્તર સુધી XP',
    },
    'activity': {
      AppLanguage.english: 'Activity',
      AppLanguage.hindi: 'गतिविधि',
      AppLanguage.gujarati: 'ગતિવિધિ',
    },
    'lessons_completed_stat': {
      AppLanguage.english: 'Lessons completed',
      AppLanguage.hindi: 'पाठ पूरे किए',
      AppLanguage.gujarati: 'પૂર્ણ કરેલા પાઠ',
    },
    'badges_label': {
      AppLanguage.english: 'Badges',
      AppLanguage.hindi: 'बैज',
      AppLanguage.gujarati: 'બેજ',
    },
    'lesson_singular': {
      AppLanguage.english: 'lesson',
      AppLanguage.hindi: 'पाठ',
      AppLanguage.gujarati: 'પાઠ',
    },
    'lessons_plural': {
      AppLanguage.english: 'lessons',
      AppLanguage.hindi: 'पाठ',
      AppLanguage.gujarati: 'પાઠ',
    },

    // Settings screen
    'settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.hindi: 'सेटिंग्स',
      AppLanguage.gujarati: 'સેટિંગ્સ',
    },
    'appearance': {
      AppLanguage.english: 'Appearance',
      AppLanguage.hindi: 'दिखावट',
      AppLanguage.gujarati: 'દેખાવ',
    },
    'dark_mode': {
      AppLanguage.english: 'Dark mode',
      AppLanguage.hindi: 'डार्क मोड',
      AppLanguage.gujarati: 'ડાર્ક મોડ',
    },
    'enabled': {
      AppLanguage.english: 'Enabled',
      AppLanguage.hindi: 'सक्रिय',
      AppLanguage.gujarati: 'ચાલુ',
    },
    'disabled': {
      AppLanguage.english: 'Disabled',
      AppLanguage.hindi: 'निष्क्रिय',
      AppLanguage.gujarati: 'બંધ',
    },
    'notifications': {
      AppLanguage.english: 'Notifications',
      AppLanguage.hindi: 'सूचनाएं',
      AppLanguage.gujarati: 'સૂચનાઓ',
    },
    'enable_notifications': {
      AppLanguage.english: 'Enable Notifications',
      AppLanguage.hindi: 'सूचनाएं सक्रिय करें',
      AppLanguage.gujarati: 'સૂચનાઓ ચાલુ કરો',
    },
    'notification_desc': {
      AppLanguage.english: 'Get reminders to learn and practice',
      AppLanguage.hindi: 'सीखने और अभ्यास के लिए रिमाइंडर पाएं',
      AppLanguage.gujarati: 'શીખવા અને પ્રેક્ટિસ માટે રિમાઇન્ડર મેળવો',
    },
    'notifications_enabled': {
      AppLanguage.english: 'Notifications enabled',
      AppLanguage.hindi: 'सूचनाएं सक्रिय हुईं',
      AppLanguage.gujarati: 'સૂચનાઓ ચાલુ થઈ',
    },
    'permission_denied': {
      AppLanguage.english: 'Permission denied',
      AppLanguage.hindi: 'अनुमति अस्वीकृत',
      AppLanguage.gujarati: 'પરવાનગી નકારવામાં આવી',
    },
    'reminder_time': {
      AppLanguage.english: 'Reminder Time',
      AppLanguage.hindi: 'रिमाइंडर समय',
      AppLanguage.gujarati: 'રિમાઇન્ડર સમય',
    },
    'quiet_hours': {
      AppLanguage.english: 'Quiet Hours',
      AppLanguage.hindi: 'शांत समय',
      AppLanguage.gujarati: 'શાંત સમય',
    },
    'quiet_hours_desc': {
      AppLanguage.english: 'Quiet hours: 10 PM - 7 AM',
      AppLanguage.hindi: 'शांत समय: रात 10 - सुबह 7',
      AppLanguage.gujarati: 'શાંત સમય: રાત 10 - સવાર 7',
    },
    'notification_types': {
      AppLanguage.english: 'Notification Types',
      AppLanguage.hindi: 'सूचना प्रकार',
      AppLanguage.gujarati: 'સૂચના પ્રકાર',
    },
    'learning_reminders': {
      AppLanguage.english: 'Learning Reminders',
      AppLanguage.hindi: 'सीखने के रिमाइंडर',
      AppLanguage.gujarati: 'શીખવાના રિમાઇન્ડર',
    },
    'daily_lesson_reminders': {
      AppLanguage.english: 'Daily lesson reminders',
      AppLanguage.hindi: 'दैनिक पाठ रिमाइंडर',
      AppLanguage.gujarati: 'દૈનિક પાઠ રિમાઇન્ડર',
    },
    'ahimsa_prompts': {
      AppLanguage.english: 'Ahimsa Prompts',
      AppLanguage.hindi: 'अहिंसा प्रॉम्प्ट',
      AppLanguage.gujarati: 'અહિંસા પ્રોમ્પ્ટ',
    },
    'mindful_checkins': {
      AppLanguage.english: 'Mindful practice check-ins',
      AppLanguage.hindi: 'सचेत अभ्यास चेक-इन',
      AppLanguage.gujarati: 'સભાન પ્રેક્ટિસ ચેક-ઇન',
    },
    'reflection_prompts': {
      AppLanguage.english: 'Reflection Prompts',
      AppLanguage.hindi: 'चिंतन प्रॉम्प्ट',
      AppLanguage.gujarati: 'ચિંતન પ્રોમ્પ્ટ',
    },
    'evening_reflection': {
      AppLanguage.english: 'Evening reflection reminders',
      AppLanguage.hindi: 'शाम के चिंतन रिमाइंडर',
      AppLanguage.gujarati: 'સાંજના ચિંતન રિમાઇન્ડર',
    },
    'streak_alerts': {
      AppLanguage.english: 'Streak Alerts',
      AppLanguage.hindi: 'स्ट्रीक अलर्ट',
      AppLanguage.gujarati: 'સ્ટ્રીક અલર્ટ',
    },
    'streak_at_risk': {
      AppLanguage.english: 'Warnings when your streak is at risk',
      AppLanguage.hindi: 'जब आपकी स्ट्रीक खतरे में हो तो चेतावनी',
      AppLanguage.gujarati: 'જ્યારે તમારી સ્ટ્રીક જોખમમાં હોય ત્યારે ચેતવણી',
    },
    'data': {
      AppLanguage.english: 'Data',
      AppLanguage.hindi: 'डेटा',
      AppLanguage.gujarati: 'ડેટા',
    },
    'reset_progress': {
      AppLanguage.english: 'Reset Progress',
      AppLanguage.hindi: 'प्रगति रीसेट करें',
      AppLanguage.gujarati: 'પ્રગતિ રીસેટ કરો',
    },
    'reset_progress_desc': {
      AppLanguage.english: 'Delete all progress and start over',
      AppLanguage.hindi: 'सारी प्रगति हटाएं और शुरू करें',
      AppLanguage.gujarati: 'બધી પ્રગતિ કાઢી નાખો અને ફરી શરૂ કરો',
    },
    'reset_progress_confirm': {
      AppLanguage.english: 'Reset Progress?',
      AppLanguage.hindi: 'प्रगति रीसेट करें?',
      AppLanguage.gujarati: 'પ્રગતિ રીસેટ કરો?',
    },
    'reset_progress_warning': {
      AppLanguage.english:
          'This will delete all your progress, XP, streaks, and badges. This action cannot be undone.',
      AppLanguage.hindi:
          'यह आपकी सारी प्रगति, XP, स्ट्रीक और बैज हटा देगा। यह क्रिया पूर्ववत नहीं की जा सकती।',
      AppLanguage.gujarati:
          'આ તમારી બધી પ્રગતિ, XP, સ્ટ્રીક અને બેજ કાઢી નાખશે. આ ક્રિયા પૂર્વવત કરી શકાતી નથી.',
    },
    'cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.hindi: 'रद्द करें',
      AppLanguage.gujarati: 'રદ કરો',
    },
    'reset': {
      AppLanguage.english: 'Reset',
      AppLanguage.hindi: 'रीसेट',
      AppLanguage.gujarati: 'રીસેટ',
    },
    'progress_reset': {
      AppLanguage.english: 'Progress reset',
      AppLanguage.hindi: 'प्रगति रीसेट हुई',
      AppLanguage.gujarati: 'પ્રગતિ રીસેટ થઈ',
    },
    'about': {
      AppLanguage.english: 'About',
      AppLanguage.hindi: 'के बारे में',
      AppLanguage.gujarati: 'વિશે',
    },
    'version': {
      AppLanguage.english: 'Version',
      AppLanguage.hindi: 'संस्करण',
      AppLanguage.gujarati: 'સંસ્કરણ',
    },
    'built_with': {
      AppLanguage.english: 'Built with',
      AppLanguage.hindi: 'बनाया गया',
      AppLanguage.gujarati: 'બનાવ્યું',
    },
    'app_desc': {
      AppLanguage.english:
          'Gamified Jain learning for teens. Calm, modern, non-preachy.',
      AppLanguage.hindi: 'किशोरों के लिए गेमिफाइड जैन शिक्षा। शांत, आधुनिक।',
      AppLanguage.gujarati: 'કિશોરો માટે ગેમિફાઇડ જૈન શિક્ષણ. શાંત, આધુનિક.',
    },

    // Forum screen
    'community_forum': {
      AppLanguage.english: 'Community Forum',
      AppLanguage.hindi: 'सामुदायिक फोरम',
      AppLanguage.gujarati: 'સમુદાય ફોરમ',
    },
    'no_posts_yet': {
      AppLanguage.english: 'No posts yet. Start the conversation!',
      AppLanguage.hindi: 'अभी कोई पोस्ट नहीं। बातचीत शुरू करें!',
      AppLanguage.gujarati: 'હજુ કોઈ પોસ્ટ નથી. વાતચીત શરૂ કરો!',
    },
    'just_now': {
      AppLanguage.english: 'just now',
      AppLanguage.hindi: 'अभी',
      AppLanguage.gujarati: 'હમણાં',
    },
    'all_category': {
      AppLanguage.english: 'All',
      AppLanguage.hindi: 'सभी',
      AppLanguage.gujarati: 'બધા',
    },
    'add': {
      AppLanguage.english: 'Add',
      AppLanguage.hindi: 'जोड़ें',
      AppLanguage.gujarati: 'ઉમેરો',
    },
    'new_community': {
      AppLanguage.english: 'New community',
      AppLanguage.hindi: 'नया समुदाय',
      AppLanguage.gujarati: 'નવો સમુદાય',
    },
    'reply': {
      AppLanguage.english: 'Reply',
      AppLanguage.hindi: 'उत्तर दें',
      AppLanguage.gujarati: 'જવાબ આપો',
    },
    'reply_required': {
      AppLanguage.english: 'Write a reply before sending.',
      AppLanguage.hindi: 'भेजने से पहले उत्तर लिखें।',
      AppLanguage.gujarati: 'મોકલતાં પહેલાં જવાબ લખો.',
    },
    'write_reply': {
      AppLanguage.english: 'Write your reply…',
      AppLanguage.hindi: 'अपना उत्तर लिखें…',
      AppLanguage.gujarati: 'તમારો જવાબ લખો…',
    },
    'be_respectful': {
      AppLanguage.english: 'Be respectful.',
      AppLanguage.hindi: 'सम्मानजनक रहें।',
      AppLanguage.gujarati: 'આદરપૂર્ણ રહો.',
    },
    'could_not_post_reply': {
      AppLanguage.english: 'Could not post reply.',
      AppLanguage.hindi: 'उत्तर पोस्ट नहीं हो सका।',
      AppLanguage.gujarati: 'જવાબ પોસ્ટ થઈ શક્યો નહીં.',
    },
    'community_name_required': {
      AppLanguage.english: 'Community name is required.',
      AppLanguage.hindi: 'समुदाय का नाम आवश्यक है।',
      AppLanguage.gujarati: 'સમુદાયનું નામ જરૂરી છે.',
    },
    'could_not_create_community': {
      AppLanguage.english: 'Could not create community. Try again.',
      AppLanguage.hindi: 'समुदाय बना नहीं सका। फिर प्रयास करें।',
      AppLanguage.gujarati: 'સમુદાય બનાવી શકાયો નહીં. ફરી પ્રયત્ન કરો.',
    },
    'create_community': {
      AppLanguage.english: 'Create Community',
      AppLanguage.hindi: 'समुदाय बनाएं',
      AppLanguage.gujarati: 'સમુદાય બનાવો',
    },
    'admin_note': {
      AppLanguage.english: 'You will be the admin of this group.',
      AppLanguage.hindi: 'आप इस समूह के एडमिन होंगे।',
      AppLanguage.gujarati: 'તમે આ ગ્રુપના એડમિન હશો.',
    },
    'community_name': {
      AppLanguage.english: 'Community name',
      AppLanguage.hindi: 'समुदाय का नाम',
      AppLanguage.gujarati: 'સમુદાયનું નામ',
    },
    'group_about': {
      AppLanguage.english: 'What is this group about? (optional)',
      AppLanguage.hindi: 'यह समूह किस बारे में है? (वैकल्पिक)',
      AppLanguage.gujarati: 'આ ગ્રુપ શેના વિશે છે? (વૈકલ્પિક)',
    },
    'create': {
      AppLanguage.english: 'Create',
      AppLanguage.hindi: 'बनाएं',
      AppLanguage.gujarati: 'બનાવો',
    },
    'write_before_posting': {
      AppLanguage.english: 'Write something before posting.',
      AppLanguage.hindi: 'पोस्ट करने से पहले कुछ लिखें।',
      AppLanguage.gujarati: 'પોસ્ટ કરતા પહેલા કંઈક લખો.',
    },
    'could_not_create_post': {
      AppLanguage.english: 'Could not create post. Try again.',
      AppLanguage.hindi: 'पोस्ट बना नहीं सका। फिर प्रयास करें।',
      AppLanguage.gujarati: 'પોસ્ટ બનાવી શકાઈ નહીં. ફરી પ્રયત્ન કરો.',
    },
    'create_post': {
      AppLanguage.english: 'Create Post',
      AppLanguage.hindi: 'पोस्ट बनाएं',
      AppLanguage.gujarati: 'પોસ્ટ બનાવો',
    },
    'post_content': {
      AppLanguage.english: 'Post content',
      AppLanguage.hindi: 'पोस्ट सामग्री',
      AppLanguage.gujarati: 'પોસ્ટ સામગ્રી',
    },
    'share_thought': {
      AppLanguage.english:
          'Share a thought, ask a question, or start a challenge…',
      AppLanguage.hindi:
          'एक विचार साझा करें, प्रश्न पूछें, या चुनौती शुरू करें…',
      AppLanguage.gujarati: 'વિચાર શેર કરો, પ્રશ્ન પૂછો, અથવા ચેલેન્જ શરૂ કરો…',
    },
    'tags_label': {
      AppLanguage.english: 'Tags',
      AppLanguage.hindi: 'टैग',
      AppLanguage.gujarati: 'ટૅગ્સ',
    },
    'tags_hint': {
      AppLanguage.english: 'Tags (comma separated)',
      AppLanguage.hindi: 'टैग (अल्पविराम से अलग)',
      AppLanguage.gujarati: 'ટૅગ્સ (અલ્પવિરામથી અલગ)',
    },
    'be_kind': {
      AppLanguage.english: 'Be kind, be curious.',
      AppLanguage.hindi: 'दयालु रहें, जिज्ञासु रहें।',
      AppLanguage.gujarati: 'દયાળુ રહો, જિજ્ઞાસુ રહો.',
    },
    'post': {
      AppLanguage.english: 'Post',
      AppLanguage.hindi: 'पोस्ट करें',
      AppLanguage.gujarati: 'પોસ્ટ કરો',
    },
    'no_community': {
      AppLanguage.english: 'No community is available right now.',
      AppLanguage.hindi: 'अभी कोई समुदाय उपलब्ध नहीं है।',
      AppLanguage.gujarati: 'હાલમાં કોઈ સમુદાય ઉપલબ્ધ નથી.',
    },
    'community_created': {
      AppLanguage.english: 'Community created. You are the admin.',
      AppLanguage.hindi: 'समुदाय बनाया गया। आप एडमिन हैं।',
      AppLanguage.gujarati: 'સમુદાય બનાવ્યો. તમે એડમિન છો.',
    },
    'delete': {
      AppLanguage.english: 'Delete',
      AppLanguage.hindi: 'हटाएं',
      AppLanguage.gujarati: 'કાઢી નાખો',
    },
    'delete_post': {
      AppLanguage.english: 'Delete post',
      AppLanguage.hindi: 'पोस्ट हटाएं',
      AppLanguage.gujarati: 'પોસ્ટ કાઢી નાખો',
    },
    'delete_reply': {
      AppLanguage.english: 'Delete reply',
      AppLanguage.hindi: 'उत्तर हटाएं',
      AppLanguage.gujarati: 'જવાબ કાઢી નાખો',
    },
    'delete_post_confirm_title': {
      AppLanguage.english: 'Delete this post?',
      AppLanguage.hindi: 'क्या यह पोस्ट हटानी है?',
      AppLanguage.gujarati: 'આ પોસ્ટ કાઢી નાખવી છે?',
    },
    'delete_post_confirm_message': {
      AppLanguage.english: 'This action cannot be undone.',
      AppLanguage.hindi: 'यह क्रिया पूर्ववत नहीं की जा सकती।',
      AppLanguage.gujarati: 'આ ક્રિયા પૂર્વવત કરી શકાતી નથી.',
    },
    'delete_reply_confirm_title': {
      AppLanguage.english: 'Delete this reply?',
      AppLanguage.hindi: 'क्या यह उत्तर हटाना है?',
      AppLanguage.gujarati: 'આ જવાબ કાઢી નાખવો છે?',
    },
    'delete_reply_confirm_message': {
      AppLanguage.english: 'This action cannot be undone.',
      AppLanguage.hindi: 'यह क्रिया पूर्ववत नहीं की जा सकती।',
      AppLanguage.gujarati: 'આ ક્રિયા પૂર્વવત કરી શકાતી નથી.',
    },
    'delete_own_post': {
      AppLanguage.english: 'You can only delete your own post.',
      AppLanguage.hindi: 'आप केवल अपनी पोस्ट हटा सकते हैं।',
      AppLanguage.gujarati: 'તમે ફક્ત તમારી પોસ્ટ કાઢી શકો છો.',
    },
    'delete_own_reply': {
      AppLanguage.english: 'You can only delete your own reply.',
      AppLanguage.hindi: 'आप केवल अपना उत्तर हटा सकते हैं।',
      AppLanguage.gujarati: 'તમે ફક્ત તમારો જવાબ કાઢી શકો છો.',
    },
    'reply_to': {
      AppLanguage.english: 'Reply to {name}',
      AppLanguage.hindi: '{name} को उत्तर दें',
      AppLanguage.gujarati: '{name} ને જવાબ આપો',
    },
    'general': {
      AppLanguage.english: 'General',
      AppLanguage.hindi: 'सामान्य',
      AppLanguage.gujarati: 'સામાન્ય',
    },
    'reflections': {
      AppLanguage.english: 'Reflections',
      AppLanguage.hindi: 'चिंतन',
      AppLanguage.gujarati: 'ચિંતન',
    },
    'challenges': {
      AppLanguage.english: 'Challenges',
      AppLanguage.hindi: 'चुनौतियां',
      AppLanguage.gujarati: 'ચેલેન્જ',
    },

    // Lesson runner
    'leave_lesson': {
      AppLanguage.english: 'Leave lesson?',
      AppLanguage.hindi: 'पाठ छोड़ें?',
      AppLanguage.gujarati: 'પાઠ છોડો?',
    },
    'leave_lesson_warning': {
      AppLanguage.english: 'Your progress in this lesson will not be saved.',
      AppLanguage.hindi: 'इस पाठ में आपकी प्रगति सहेजी नहीं जाएगी।',
      AppLanguage.gujarati: 'આ પાઠમાં તમારી પ્રગતિ સાચવવામાં આવશે નહીં.',
    },
    'stay': {
      AppLanguage.english: 'Stay',
      AppLanguage.hindi: 'रहें',
      AppLanguage.gujarati: 'રહો',
    },
    'leave': {
      AppLanguage.english: 'Leave',
      AppLanguage.hindi: 'छोड़ें',
      AppLanguage.gujarati: 'છોડો',
    },
    'no_lesson_loaded': {
      AppLanguage.english: 'No lesson loaded',
      AppLanguage.hindi: 'कोई पाठ लोड नहीं',
      AppLanguage.gujarati: 'કોઈ પાઠ લોડ નથી',
    },

    // Practice screens
    'practice': {
      AppLanguage.english: 'Practice',
      AppLanguage.hindi: 'अभ्यास',
      AppLanguage.gujarati: 'પ્રેક્ટિસ',
    },
    'strengthen_knowledge': {
      AppLanguage.english: 'Strengthen your knowledge and earn rewards',
      AppLanguage.hindi: 'अपना ज्ञान मजबूत करें और पुरस्कार अर्जित करें',
      AppLanguage.gujarati: 'તમારું જ્ઞાન મજબૂત કરો અને ઇનામ મેળવો',
    },
    'complete_lessons_unlock': {
      AppLanguage.english: 'Complete lessons to unlock practice',
      AppLanguage.hindi: 'अभ्यास अनलॉक करने के लिए पाठ पूरे करें',
      AppLanguage.gujarati: 'પ્રેક્ટિસ અનલૉક કરવા પાઠ પૂર્ણ કરો',
    },
    'practice_from_completed': {
      AppLanguage.english:
          'Practice sessions are generated from lessons you\'ve completed.',
      AppLanguage.hindi: 'अभ्यास सत्र आपके पूरे किए पाठों से बनते हैं।',
      AppLanguage.gujarati: 'પ્રેક્ટિસ સેશન તમે પૂર્ણ કરેલા પાઠમાંથી બને છે.',
    },
    'review': {
      AppLanguage.english: 'Review',
      AppLanguage.hindi: 'समीक्षा',
      AppLanguage.gujarati: 'સમીક્ષા',
    },
    'review_desc': {
      AppLanguage.english:
          'Revisit questions from completed lessons using spaced repetition',
      AppLanguage.hindi: 'स्पेस्ड रिपिटिशन से पूरे किए पाठों के प्रश्न दोहराएं',
      AppLanguage.gujarati:
          'સ્પેસ્ડ રિપિટિશનથી પૂર્ણ કરેલા પાઠના પ્રશ્નો ફરી જુઓ',
    },
    'earn_xp': {
      AppLanguage.english: 'Earn XP',
      AppLanguage.hindi: 'XP कमाएं',
      AppLanguage.gujarati: 'XP મેળવો',
    },
    'refill_hearts': {
      AppLanguage.english: 'Refill hearts',
      AppLanguage.hindi: 'दिल फिर भरें',
      AppLanguage.gujarati: 'હાર્ટ્સ ફરી ભરો',
    },
    'target_weak_spots': {
      AppLanguage.english: 'Target Weak Spots',
      AppLanguage.hindi: 'कमज़ोर क्षेत्रों पर ध्यान दें',
      AppLanguage.gujarati: 'નબળા ક્ષેત્રો પર ધ્યાન આપો',
    },
    'weak_spots_desc': {
      AppLanguage.english:
          'Focus on questions you\'ve answered incorrectly before',
      AppLanguage.hindi: 'पहले गलत उत्तर दिए प्रश्नों पर ध्यान दें',
      AppLanguage.gujarati: 'પહેલા ખોટા જવાબ આપેલા પ્રશ્નો પર ધ્યાન આપો',
    },
    'improve_accuracy': {
      AppLanguage.english: 'Improve accuracy',
      AppLanguage.hindi: 'सटीकता बढ़ाएं',
      AppLanguage.gujarati: 'ચોકસાઈ સુધારો',
    },
    'your_progress': {
      AppLanguage.english: 'Your Progress',
      AppLanguage.hindi: 'आपकी प्रगति',
      AppLanguage.gujarati: 'તમારી પ્રગતિ',
    },
    'lessons_completed_label': {
      AppLanguage.english: 'Lessons\nCompleted',
      AppLanguage.hindi: 'पाठ\nपूरे',
      AppLanguage.gujarati: 'પાઠ\nપૂર્ણ',
    },
    'badges_earned': {
      AppLanguage.english: 'Badges\nEarned',
      AppLanguage.hindi: 'बैज\nप्राप्त',
      AppLanguage.gujarati: 'બેજ\nપ્રાપ્ત',
    },
    'tip': {
      AppLanguage.english: 'Tip',
      AppLanguage.hindi: 'सुझाव',
      AppLanguage.gujarati: 'ટિપ',
    },
    'practice_refills_heart': {
      AppLanguage.english: 'Completing a practice session refills one heart!',
      AppLanguage.hindi: 'अभ्यास सत्र पूरा करने से एक दिल फिर भरता है!',
      AppLanguage.gujarati: 'પ્રેક્ટિસ સેશન પૂર્ણ કરવાથી એક હાર્ટ ફરી ભરાય છે!',
    },
    'practice_complete': {
      AppLanguage.english: 'Practice Complete!',
      AppLanguage.hindi: 'अभ्यास पूरा!',
      AppLanguage.gujarati: 'પ્રેક્ટિસ પૂર્ણ!',
    },
    'heart_refilled': {
      AppLanguage.english: '+1 Heart',
      AppLanguage.hindi: '+1 दिल',
      AppLanguage.gujarati: '+1 હાર્ટ',
    },
    'done': {
      AppLanguage.english: 'Done',
      AppLanguage.hindi: 'हो गया',
      AppLanguage.gujarati: 'પૂર્ણ',
    },
    'no_questions': {
      AppLanguage.english: 'No questions available',
      AppLanguage.hindi: 'कोई प्रश्न उपलब्ध नहीं',
      AppLanguage.gujarati: 'કોઈ પ્રશ્ન ઉપલબ્ધ નથી',
    },
    'go_back': {
      AppLanguage.english: 'Go Back',
      AppLanguage.hindi: 'वापस जाएं',
      AppLanguage.gujarati: 'પાછા જાઓ',
    },
    'refresh_chat': {
      AppLanguage.english: 'Refresh chat',
      AppLanguage.hindi: 'चैट रीफ्रेश करें',
      AppLanguage.gujarati: 'ચેટ રિફ્રેશ કરો',
    },
    'send_message': {
      AppLanguage.english: 'Send message',
      AppLanguage.hindi: 'संदेश भेजें',
      AppLanguage.gujarati: 'સંદેશ મોકલો',
    },
    'great_job': {
      AppLanguage.english: 'Great job!',
      AppLanguage.hindi: 'शाबाश!',
      AppLanguage.gujarati: 'શાબાશ!',
    },
    'keep_practicing': {
      AppLanguage.english: 'Keep practicing!',
      AppLanguage.hindi: 'अभ्यास जारी रखें!',
      AppLanguage.gujarati: 'પ્રેક્ટિસ ચાલુ રાખો!',
    },
    'finish': {
      AppLanguage.english: 'Finish',
      AppLanguage.hindi: 'समाप्त',
      AppLanguage.gujarati: 'સમાપ્ત',
    },
    'weak_spots': {
      AppLanguage.english: 'Weak Spots',
      AppLanguage.hindi: 'कमज़ोर क्षेत्र',
      AppLanguage.gujarati: 'નબળા ક્ષેત્ર',
    },

    // Stats screen
    'your_stats': {
      AppLanguage.english: 'Your Stats',
      AppLanguage.hindi: 'आपके आंकड़े',
      AppLanguage.gujarati: 'તમારા આંકડા',
    },
    'total_xp': {
      AppLanguage.english: 'Total XP',
      AppLanguage.hindi: 'कुल XP',
      AppLanguage.gujarati: 'કુલ XP',
    },
    'level': {
      AppLanguage.english: 'Level',
      AppLanguage.hindi: 'स्तर',
      AppLanguage.gujarati: 'સ્તર',
    },
    'streak': {
      AppLanguage.english: 'Streak',
      AppLanguage.hindi: 'स्ट्रीक',
      AppLanguage.gujarati: 'સ્ટ્રીક',
    },
    'lessons_label': {
      AppLanguage.english: 'Lessons',
      AppLanguage.hindi: 'पाठ',
      AppLanguage.gujarati: 'પાઠ',
    },
    'time_spent': {
      AppLanguage.english: 'Time Spent',
      AppLanguage.hindi: 'बिताया समय',
      AppLanguage.gujarati: 'વિતાવેલો સમય',
    },
    'this_week': {
      AppLanguage.english: 'This Week',
      AppLanguage.hindi: 'इस सप्ताह',
      AppLanguage.gujarati: 'આ અઠવાડિયે',
    },
    'weekly_progress': {
      AppLanguage.english: 'Weekly Progress',
      AppLanguage.hindi: 'साप्ताहिक प्रगति',
      AppLanguage.gujarati: 'સાપ્તાહિક પ્રગતિ',
    },
    'xp_over_time': {
      AppLanguage.english: 'XP Over Time',
      AppLanguage.hindi: 'समय के साथ XP',
      AppLanguage.gujarati: 'સમય સાથે XP',
    },
    'mon': {
      AppLanguage.english: 'Mon',
      AppLanguage.hindi: 'सोम',
      AppLanguage.gujarati: 'સોમ',
    },
    'tue': {
      AppLanguage.english: 'Tue',
      AppLanguage.hindi: 'मंगल',
      AppLanguage.gujarati: 'મંગળ',
    },
    'wed': {
      AppLanguage.english: 'Wed',
      AppLanguage.hindi: 'बुध',
      AppLanguage.gujarati: 'બુધ',
    },
    'thu': {
      AppLanguage.english: 'Thu',
      AppLanguage.hindi: 'गुरु',
      AppLanguage.gujarati: 'ગુરુ',
    },
    'fri': {
      AppLanguage.english: 'Fri',
      AppLanguage.hindi: 'शुक्र',
      AppLanguage.gujarati: 'શુક્ર',
    },
    'sat': {
      AppLanguage.english: 'Sat',
      AppLanguage.hindi: 'शनि',
      AppLanguage.gujarati: 'શનિ',
    },
    'sun': {
      AppLanguage.english: 'Sun',
      AppLanguage.hindi: 'रवि',
      AppLanguage.gujarati: 'રવિ',
    },

    // Leaderboard
    'leaderboard': {
      AppLanguage.english: 'Leaderboard',
      AppLanguage.hindi: 'लीडरबोर्ड',
      AppLanguage.gujarati: 'લીડરબોર્ડ',
    },
    'weekly': {
      AppLanguage.english: 'Weekly',
      AppLanguage.hindi: 'साप्ताहिक',
      AppLanguage.gujarati: 'સાપ્તાહિક',
    },
    'all_time': {
      AppLanguage.english: 'All Time',
      AppLanguage.hindi: 'सर्वकालिक',
      AppLanguage.gujarati: 'સર્વકાલીન',
    },
    'rankings': {
      AppLanguage.english: 'Rankings',
      AppLanguage.hindi: 'रैंकिंग',
      AppLanguage.gujarati: 'રેન્કિંગ',
    },
    'your_rank': {
      AppLanguage.english: 'Your Rank',
      AppLanguage.hindi: 'आपकी रैंक',
      AppLanguage.gujarati: 'તમારી રેન્ક',
    },
    'you': {
      AppLanguage.english: 'You',
      AppLanguage.hindi: 'आप',
      AppLanguage.gujarati: 'તમે',
    },

    // Unit path
    'learning_path': {
      AppLanguage.english: 'Learning Path',
      AppLanguage.hindi: 'सीखने का रास्ता',
      AppLanguage.gujarati: 'શીખવાનો રસ્તો',
    },
    'boss_checkpoint': {
      AppLanguage.english: 'Boss Checkpoint',
      AppLanguage.hindi: 'बॉस चेकपॉइंट',
      AppLanguage.gujarati: 'બૉસ ચેકપોઇન્ટ',
    },
    'test_mastery': {
      AppLanguage.english: 'Test your mastery!',
      AppLanguage.hindi: 'अपनी महारत परखें!',
      AppLanguage.gujarati: 'તમારી નિપુણતા ચકાસો!',
    },
    'complete_to_unlock': {
      AppLanguage.english: 'Complete all lessons to unlock',
      AppLanguage.hindi: 'अनलॉक करने के लिए सभी पाठ पूरे करें',
      AppLanguage.gujarati: 'અનલૉક કરવા બધા પાઠ પૂર્ણ કરો',
    },
    'core_principles': {
      AppLanguage.english: 'Learn the core principles and history',
      AppLanguage.hindi: 'मूल सिद्धांत और इतिहास जानें',
      AppLanguage.gujarati: 'મૂળ સિદ્ધાંતો અને ઇતિહાસ જાણો',
    },

    // Resources screen
    'resources_header': {
      AppLanguage.english: 'Resources',
      AppLanguage.hindi: 'संसाधन',
      AppLanguage.gujarati: 'સંસાધનો',
    },
    'resources_desc': {
      AppLanguage.english:
          'Read a knowledgeable book teaching the fundamentals of Jainism in great depth.',
      AppLanguage.hindi:
          'जैन धर्म की बुनियादी बातें गहराई से सिखाने वाली एक ज्ञानवर्धक पुस्तक पढ़ें।',
      AppLanguage.gujarati:
          'જૈન ધર્મના મૂળભૂત સિદ્ધાંતો ઊંડાણથી શીખવતું એક જ્ઞાનવર્ધક પુસ્તક વાંચો.',
    },
    'fundjain_reader': {
      AppLanguage.english: 'FundJain Reader',
      AppLanguage.hindi: 'FundJain रीडर',
      AppLanguage.gujarati: 'FundJain રીડર',
    },
    'reader_desc': {
      AppLanguage.english:
          'Immersive reading with adjustable font, themes, and animated page turns.',
      AppLanguage.hindi:
          'समायोज्य फ़ॉन्ट, थीम और एनिमेटेड पेज टर्न के साथ इमर्सिव रीडिंग।',
      AppLanguage.gujarati:
          'એડજસ્ટેબલ ફોન્ટ, થીમ અને એનિમેટેડ પેજ ટર્ન સાથે ઇમર્સિવ રીડિંગ.',
    },
    'start_reading': {
      AppLanguage.english: 'Start Reading',
      AppLanguage.hindi: 'पढ़ना शुरू करें',
      AppLanguage.gujarati: 'વાંચવાનું શરૂ કરો',
    },
    'quick_guides': {
      AppLanguage.english: 'Quick Guides',
      AppLanguage.hindi: 'त्वरित गाइड',
      AppLanguage.gujarati: 'ક્વિક ગાઇડ',
    },
    'video_library': {
      AppLanguage.english: 'Video Library',
      AppLanguage.hindi: 'वीडियो लाइब्रेरी',
      AppLanguage.gujarati: 'વીડિયો લાઇબ્રેરી',
    },
    'completed': {
      AppLanguage.english: 'Completed',
      AppLanguage.hindi: 'पूरा हुआ',
      AppLanguage.gujarati: 'પૂર્ણ',
    },
    'mark_completed': {
      AppLanguage.english: 'Mark as Completed',
      AppLanguage.hindi: 'पूरा किया चिह्नित करें',
      AppLanguage.gujarati: 'પૂર્ણ તરીકે ચિહ્નિત કરો',
    },
    'open_reader': {
      AppLanguage.english: 'Open Reader',
      AppLanguage.hindi: 'रीडर खोलें',
      AppLanguage.gujarati: 'રીડર ખોલો',
    },
    'daily_reading_reward_hint': {
      AppLanguage.english: 'Read 10 pages in a day to earn 1 heart.',
    },
    'could_not_open': {
      AppLanguage.english: 'Could not open link',
      AppLanguage.hindi: 'लिंक खोल नहीं सका',
      AppLanguage.gujarati: 'લિંક ખોલી શકાઈ નહીં',
    },

    // Guru suggestions
    'guru_q1': {
      AppLanguage.english: 'What is Jainism in one minute?',
      AppLanguage.hindi: 'एक मिनट में जैन धर्म क्या है?',
      AppLanguage.gujarati: 'એક મિનિટમાં જૈન ધર્મ શું છે?',
    },
    'guru_q2': {
      AppLanguage.english: 'Why is Ahimsa important?',
      AppLanguage.hindi: 'अहिंसा क्यों महत्वपूर्ण है?',
      AppLanguage.gujarati: 'અહિંસા શા માટે મહત્વપૂર્ણ છે?',
    },
    'guru_q3': {
      AppLanguage.english: 'How does karma work?',
      AppLanguage.hindi: 'कर्म कैसे काम करता है?',
      AppLanguage.gujarati: 'કર્મ કેવી રીતે કામ કરે છે?',
    },
    'guru_q4': {
      AppLanguage.english: 'What are the 5 vows?',
      AppLanguage.hindi: '5 व्रत कौन से हैं?',
      AppLanguage.gujarati: '5 વ્રત કયા છે?',
    },
    'guru_q5': {
      AppLanguage.english: 'What is Moksha?',
      AppLanguage.hindi: 'मोक्ष क्या है?',
      AppLanguage.gujarati: 'મોક્ષ શું છે?',
    },
    'guru_q6': {
      AppLanguage.english: 'How can I practice non-attachment daily?',
      AppLanguage.hindi: 'मैं रोज़ाना अनासक्ति का अभ्यास कैसे कर सकता हूं?',
      AppLanguage.gujarati: 'હું દૈનિક અનાસક્તિનો અભ્યાસ કેવી રીતે કરી શકું?',
    },

    // Quick guide content
    'guide_ahimsa_title': {
      AppLanguage.english: 'Ahimsa in Daily Life',
      AppLanguage.hindi: 'दैनिक जीवन में अहिंसा',
      AppLanguage.gujarati: 'દૈનિક જીવનમાં અહિંસા',
    },
    'guide_ahimsa_desc': {
      AppLanguage.english:
          'A simple checklist for practicing non-violence in speech, thought, and action.',
      AppLanguage.hindi:
          'वचन, विचार और कर्म में अहिंसा का अभ्यास करने के लिए एक सरल चेकलिस्ट।',
      AppLanguage.gujarati:
          'વાણી, વિચાર અને કર્મમાં અહિંસાનો અભ્યાસ કરવા માટેની સરળ ચેકલિસ્ટ.',
    },
    'guide_ahimsa_body': {
      AppLanguage.english:
          'Pause before you speak. Swap harsh words with kindness. Choose plant-based meals today. Notice tiny lives around you.',
      AppLanguage.hindi:
          'बोलने से पहले रुकें। कठोर शब्दों को दयालुता से बदलें। आज पौधे-आधारित भोजन चुनें। अपने आसपास के छोटे जीवन को देखें।',
      AppLanguage.gujarati:
          'બોલતા પહેલા થોભો. કઠોર શબ્દોને દયાથી બદલો. આજે છોડ આધારિત ભોજન પસંદ કરો. તમારી આસપાસના નાના જીવનને ધ્યાનથી જુઓ.',
    },
    'guide_jiva_title': {
      AppLanguage.english: 'Jiva vs Ajiva',
      AppLanguage.hindi: 'जीव बनाम अजीव',
      AppLanguage.gujarati: 'જીવ vs અજીવ',
    },
    'guide_jiva_desc': {
      AppLanguage.english:
          'A quick way to spot living vs non-living using the senses ladder.',
      AppLanguage.hindi:
          'इंद्रियों की सीढ़ी का उपयोग करके जीवित बनाम निर्जीव को पहचानने का एक त्वरित तरीका।',
      AppLanguage.gujarati:
          'ઇન્દ્રિયોની સીડીનો ઉપયોગ કરીને જીવિત vs નિર્જીવ ઓળખવાની ઝડપી રીત.',
    },
    'guide_jiva_body': {
      AppLanguage.english:
          'Living beings sense, breathe, and move in subtle ways. Ajiva is matter and time - supporting life but not alive.',
      AppLanguage.hindi:
          'जीव सूक्ष्म तरीकों से अनुभव करते हैं, सांस लेते हैं और चलते हैं। अजीव पदार्थ और समय है - जीवन का आधार लेकिन जीवित नहीं।',
      AppLanguage.gujarati:
          'જીવો સૂક્ષ્મ રીતે અનુભવ કરે છે, શ્વાસ લે છે અને ચાલે છે. અજીવ પદાર્થ અને સમય છે - જીવનનો આધાર પણ જીવિત નથી.',
    },
    'guide_karma_title': {
      AppLanguage.english: 'Karma & Emotion',
      AppLanguage.hindi: 'कर्म और भावना',
      AppLanguage.gujarati: 'કર્મ અને ભાવના',
    },
    'guide_karma_desc': {
      AppLanguage.english:
          'How emotions affect karmic binding and how to slow the chain.',
      AppLanguage.hindi:
          'भावनाएं कर्मबंधन को कैसे प्रभावित करती हैं और श्रृंखला को कैसे धीमा करें।',
      AppLanguage.gujarati:
          'ભાવનાઓ કર્મબંધનને કેવી રીતે અસર કરે છે અને શ્રૃંખલા કેવી રીતે ધીમી કરવી.',
    },
    'guide_karma_body': {
      AppLanguage.english:
          'Strong emotions bind karma quickly. Slow down with breath, gratitude, and gentle speech.',
      AppLanguage.hindi:
          'तीव्र भावनाएं तेज़ी से कर्म बांधती हैं। सांस, कृतज्ञता और मधुर वाणी से धीमे हों।',
      AppLanguage.gujarati:
          'તીવ્ર ભાવનાઓ ઝડપથી કર્મ બાંધે છે. શ્વાસ, કૃતજ્ઞતા અને મધુર વાણીથી ધીમા થાઓ.',
    },

    // YouTube video screen
    'video_not_supported': {
      AppLanguage.english: 'Video playback is not supported on this device.',
      AppLanguage.hindi: 'इस डिवाइस पर वीडियो प्लेबैक समर्थित नहीं है।',
      AppLanguage.gujarati: 'આ ઉપકરણ પર વીડિયો પ્લેબેક સમર્થિત નથી.',
    },
    'video_unavailable': {
      AppLanguage.english: 'Video snippet is unavailable.',
      AppLanguage.hindi: 'वीडियो स्निपेट उपलब्ध नहीं है।',
      AppLanguage.gujarati: 'વીડિયો સ્નિપેટ ઉપલબ્ધ નથી.',
    },
    'open_externally': {
      AppLanguage.english: 'Open video externally',
      AppLanguage.hindi: 'वीडियो बाहरी रूप से खोलें',
      AppLanguage.gujarati: 'વીડિયો બાહ્ય રીતે ખોલો',
    },
    'video_clip': {
      AppLanguage.english: 'Short video clip for this lesson.',
      AppLanguage.hindi: 'इस पाठ के लिए छोटी वीडियो क्लिप।',
      AppLanguage.gujarati: 'આ પાઠ માટે ટૂંકી વીડિયો ક્લિપ.',
    },

    // Profile setup
    'begin_spiritual_journey': {
      AppLanguage.english: 'Begin your spiritual journey',
      AppLanguage.hindi: 'अपनी आध्यात्मिक यात्रा शुरू करें',
      AppLanguage.gujarati: 'તમારી આધ્યાત્મિક યાત્રા શરૂ કરો',
    },

    // Level display
    'level_title': {
      AppLanguage.english: 'Level {level} - {title}',
      AppLanguage.hindi: 'स्तर {level} - {title}',
      AppLanguage.gujarati: 'સ્તર {level} - {title}',
    },
    'level_abbreviated': {
      AppLanguage.english: 'Lvl {level}',
      AppLanguage.hindi: 'स्तर {level}',
      AppLanguage.gujarati: 'સ્તર {level}',
    },
    'level_num': {
      AppLanguage.english: 'Level {level}',
      AppLanguage.hindi: 'स्तर {level}',
      AppLanguage.gujarati: 'સ્તર {level}',
    },

    // Leaderboard
    'xp_level_stats': {
      AppLanguage.english: '{xp} XP · Level {level}',
      AppLanguage.hindi: '{xp} XP · स्तर {level}',
      AppLanguage.gujarati: '{xp} XP · સ્તર {level}',
    },

    // Weekday abbreviations (3-letter) for stats chart
    'day_mon': {
      AppLanguage.english: 'Mon',
      AppLanguage.hindi: 'सोम',
      AppLanguage.gujarati: 'સોમ',
    },
    'day_tue': {
      AppLanguage.english: 'Tue',
      AppLanguage.hindi: 'मंगल',
      AppLanguage.gujarati: 'મંગળ',
    },
    'day_wed': {
      AppLanguage.english: 'Wed',
      AppLanguage.hindi: 'बुध',
      AppLanguage.gujarati: 'બુધ',
    },
    'day_thu': {
      AppLanguage.english: 'Thu',
      AppLanguage.hindi: 'गुरु',
      AppLanguage.gujarati: 'ગુરુ',
    },
    'day_fri': {
      AppLanguage.english: 'Fri',
      AppLanguage.hindi: 'शुक्र',
      AppLanguage.gujarati: 'શુક્ર',
    },
    'day_sat': {
      AppLanguage.english: 'Sat',
      AppLanguage.hindi: 'शनि',
      AppLanguage.gujarati: 'શનિ',
    },
    'day_sun': {
      AppLanguage.english: 'Sun',
      AppLanguage.hindi: 'रवि',
      AppLanguage.gujarati: 'રવિ',
    },

    // Weekday single-letter initials for compact charts
    'day_initial_mon': {
      AppLanguage.english: 'M',
      AppLanguage.hindi: 'सो',
      AppLanguage.gujarati: 'સો',
    },
    'day_initial_tue': {
      AppLanguage.english: 'T',
      AppLanguage.hindi: 'मं',
      AppLanguage.gujarati: 'મં',
    },
    'day_initial_wed': {
      AppLanguage.english: 'W',
      AppLanguage.hindi: 'बु',
      AppLanguage.gujarati: 'બુ',
    },
    'day_initial_thu': {
      AppLanguage.english: 'T',
      AppLanguage.hindi: 'गु',
      AppLanguage.gujarati: 'ગુ',
    },
    'day_initial_fri': {
      AppLanguage.english: 'F',
      AppLanguage.hindi: 'शु',
      AppLanguage.gujarati: 'શુ',
    },
    'day_initial_sat': {
      AppLanguage.english: 'S',
      AppLanguage.hindi: 'श',
      AppLanguage.gujarati: 'શ',
    },
    'day_initial_sun': {
      AppLanguage.english: 'S',
      AppLanguage.hindi: 'र',
      AppLanguage.gujarati: 'ર',
    },

    // Reading screen
    'page_label': {
      AppLanguage.english: 'Page {num}',
      AppLanguage.hindi: 'पृष्ठ {num}',
      AppLanguage.gujarati: 'પૃષ્ઠ {num}',
    },
    'font_label': {
      AppLanguage.english: 'Font {size}',
      AppLanguage.hindi: 'फ़ॉन्ट {size}',
      AppLanguage.gujarati: 'ફોન્ટ {size}',
    },
    'chapter_progress': {
      AppLanguage.english: 'Chapter page {current} of {total}',
    },
    'page_abbreviated': {
      AppLanguage.english: 'Pg {num}',
      AppLanguage.hindi: 'पृ {num}',
      AppLanguage.gujarati: 'પૃ {num}',
    },
    'quiz_checkpoint': {
      AppLanguage.english: 'Quiz checkpoint',
    },
    'start_quiz': {
      AppLanguage.english: 'Start Quiz',
    },
    'retake_quiz': {
      AppLanguage.english: 'Retake Quiz',
    },
    'complete_this_quiz': {
      AppLanguage.english:
          'Complete this quiz before moving to the next section.',
    },
    'quiz_no_heart_cost': {
      AppLanguage.english:
          'These reading quizzes are review-only and do not cost hearts.',
    },
    'quiz_completed_snackbar': {
      AppLanguage.english: 'Quiz completed.',
    },
    'daily_reading_progress': {
      AppLanguage.english: 'Today: {count}/{target} pages for +1 heart.',
    },
    'daily_reading_earned': {
      AppLanguage.english: 'Today\'s 10-page heart is already earned.',
    },

    'previous': {
      AppLanguage.english: 'Previous',
      AppLanguage.hindi: 'पिछला',
      AppLanguage.gujarati: 'પાછળ',
    },
    'remove_bookmark': {
      AppLanguage.english: 'Remove bookmark',
      AppLanguage.hindi: 'बुकमार्क हटाएं',
      AppLanguage.gujarati: 'બુકમાર્ક દૂર કરો',
    },
    'bookmark_page': {
      AppLanguage.english: 'Bookmark page',
      AppLanguage.hindi: 'पेज बुकमार्क करें',
      AppLanguage.gujarati: 'પેજ બુકમાર્ક કરો',
    },
    'out_of_hearts_title': {
      AppLanguage.english: 'Out of hearts',
    },
    'out_of_hearts_message': {
      AppLanguage.english:
          'Lessons are locked until a heart comes back. Your next heart arrives in {time}. Read {pages} new pages to earn one sooner.',
    },
    'read_pages_for_heart': {
      AppLanguage.english: 'Read {count} more new pages to earn a heart.',
    },
    'reading_heart_earned': {
      AppLanguage.english: 'Reading restored {count} hearts.',
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
