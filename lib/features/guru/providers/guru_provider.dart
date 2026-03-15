import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/localization/language_provider.dart';

class GuruMessage {
  final String text;
  final bool isUser;
  final bool isError;

  const GuruMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
}

class GuruState {
  final List<GuruMessage> messages;
  final bool isSending;
  final bool isReady;
  final String? error;

  const GuruState({
    this.messages = const [],
    this.isSending = false,
    this.isReady = false,
    this.error,
  });

  GuruState copyWith({
    List<GuruMessage>? messages,
    bool? isSending,
    bool? isReady,
    String? error,
    bool clearError = false,
  }) {
    return GuruState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isReady: isReady ?? this.isReady,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class GuruController extends StateNotifier<GuruState> {
  static const _configCollection = 'app_config';
  static const _configDoc = 'ai';
  static const _apiKeyField = 'geminiApiKey';

  final FirebaseFirestore _firestore;
  final Ref _ref;
  GenerativeModel? _model;
  ChatSession? _chat;
  Future<void>? _initFuture;

  GuruController(this._firestore, this._ref) : super(const GuruState()) {
    _initFuture = _bootstrap();
  }

  String get _languageCode => _ref.read(appLanguageProvider).code;

  String get _languageName {
    switch (_languageCode) {
      case 'hi':
        return 'Hindi';
      case 'gu':
        return 'Gujarati';
      default:
        return 'English';
    }
  }

  String _localized({
    required String english,
    required String hindi,
    required String gujarati,
  }) {
    switch (_languageCode) {
      case 'hi':
        return hindi;
      case 'gu':
        return gujarati;
      default:
        return english;
    }
  }

  String _systemPrompt() {
    return 'You are JainQuest Guru, a calm and concise Jain learning guide. '
        'Explain concepts simply for teens, avoid preachy tone, and keep answers short. '
        'Always answer in $_languageName unless the user asks for another language.';
  }

  String _offlinePreface() {
    return _localized(
      english:
          'The live Guru is unavailable right now, so here is a quick offline answer:',
      hindi:
          'लाइव गुरु अभी उपलब्ध नहीं है, इसलिए यहां एक संक्षिप्त ऑफलाइन उत्तर है:',
      gujarati:
          'લાઇવ ગુરુ હાલમાં ઉપલબ્ધ નથી, તેથી અહીં એક ટૂંકો ઑફલાઇન જવાબ છે:',
    );
  }

  String _fallbackAnswer(String text) {
    final normalized = text.toLowerCase();

    if (normalized.contains('ahimsa')) {
      return _localized(
        english:
            'Ahimsa means reducing harm as far as possible in thought, speech, action, and lifestyle. It is not just “do not hit”; it also means truthful but gentle speech, mindful food choices, and compassion in everyday decisions.',
        hindi:
            'अहिंसा का अर्थ है विचार, वाणी, आचरण और जीवनशैली में यथासंभव हानि को कम करना। यह केवल “मारो मत” नहीं है; इसमें कोमल वाणी, सजग भोजन और दयालु निर्णय भी शामिल हैं।',
        gujarati:
            'અહિંસા એટલે વિચાર, વાણી, વર્તન અને જીવનશૈલીમાં શક્ય તેટલું નુકસાન ઘટાડવું. તે માત્ર “મારશો નહીં” નથી; તેમાં નરમ વાણી, જાગૃત આહાર અને દયાભર્યા નિર્ણયો પણ આવે છે.',
      );
    }

    if (normalized.contains('karma')) {
      return _localized(
        english:
            'In Jain thought, karma is a subtle material bond that sticks to the soul because of passions like anger, pride, deceit, and greed. Calm awareness, restraint, and right conduct reduce new karma and help old karma wear away.',
        hindi:
            'जैन दर्शन में कर्म एक सूक्ष्म बंधन है जो क्रोध, मान, माया और लोभ जैसी वृत्तियों के कारण आत्मा से जुड़ता है। सजगता, संयम और सही आचरण नए कर्म को घटाते हैं और पुराने कर्म को क्षीण करते हैं।',
        gujarati:
            'જૈન દર્શનમાં કર્મ સૂક્ષ્મ બંધન છે, જે ક્રોધ, માન, માયા અને લોભ જેવી વૃત્તિઓને કારણે આત્મા સાથે ચોંટે છે. જાગૃતિ, સંયમ અને સદ્આચરણ નવા કર્મને ઘટાડે છે અને જૂના કર્મને ક્ષીણ કરે છે.',
      );
    }

    if (normalized.contains('5 vows') ||
        normalized.contains('five vows') ||
        normalized.contains('5 mahavrat') ||
        normalized.contains('five mahavrat')) {
      return _localized(
        english:
            'The five core Jain vows are Ahimsa (non-violence), Satya (truthfulness), Achaurya or Asteya (non-stealing), Brahmacharya (self-restraint), and Aparigraha (non-attachment). For most teens, the key is to practice their everyday version with sincerity and balance.',
        hindi:
            'जैन धर्म के पाँच मुख्य व्रत हैं: अहिंसा, सत्य, अचौर्य/अस्तेय, ब्रह्मचर्य और अपरिग्रह। अधिकांश किशोरों के लिए महत्वपूर्ण बात यह है कि वे इनके दैनिक रूप को ईमानदारी और संतुलन से जीएँ।',
        gujarati:
            'જૈન ધર્મના પાંચ મુખ્ય વ્રતો છે: અહિંસા, સત્ય, અચૌર્ય/અસ્તેય, બ્રહ્મચર્ય અને અપરીગ્રહ. મોટાભાગના કિશોરો માટે મુખ્ય વાત એ છે કે તેઓ આ વ્રતોનું દૈનિક સ્વરૂપ પ્રામાણિકતા અને સંતુલનથી જીવે.',
      );
    }

    if (normalized.contains('moksha')) {
      return _localized(
        english:
            'Moksha is the soul’s state of complete freedom from karmic bondage and the cycle of birth and death. Jain practice moves toward moksha by purifying conduct, reducing attachment, and growing right vision, knowledge, and character.',
        hindi:
            'मोक्ष आत्मा की वह अवस्था है जिसमें वह कर्मबंधन और जन्म-मरण के चक्र से पूरी तरह मुक्त हो जाती है। जैन साधना सही दृष्टि, सही ज्ञान और सही आचरण से इस दिशा में आगे बढ़ती है।',
        gujarati:
            'મોક્ષ એ આત્માની એવી અવસ્થા છે જેમાં તે કર્મબંધન અને જન્મ-મરણના ચક્રથી સંપૂર્ણ મુક્ત થાય છે. જૈન સાધના સમ્યક દર્શન, સમ્યક જ્ઞાન અને સમ્યક આચાર દ્વારા આ દિશામાં આગળ વધે છે.',
      );
    }

    if (normalized.contains('non-attachment') ||
        normalized.contains('aparigraha') ||
        normalized.contains('attachment')) {
      return _localized(
        english:
            'Aparigraha means using things without letting them own your mind. A practical daily version is: keep what is useful, notice cravings before acting, and choose gratitude over constant accumulation.',
        hindi:
            'अपरिग्रह का अर्थ है वस्तुओं का उपयोग करना, पर उन्हें मन पर अधिकार न करने देना। इसका सरल अभ्यास है: आवश्यक चीज़ें रखें, इच्छा आते ही ठहरें, और संचय की जगह कृतज्ञता चुनें।',
        gujarati:
            'અપરીગ્રહ એટલે વસ્તુઓનો ઉપયોગ કરવો, પરંતુ તેમને મન પર કબજો ન કરવા દેવું. તેનું સરળ દૈનિક રૂપ છે: ઉપયોગી વસ્તુઓ રાખો, ઇચ્છા આવે ત્યારે રોકાઓ, અને સંગ્રહ કરતાં કૃતજ્ઞતા પસંદ કરો.',
      );
    }

    if (normalized.contains('what is jainism') ||
        normalized.contains('jainism') ||
        normalized.contains('jain dharm')) {
      return _localized(
        english:
            'Jainism is a way of life centered on non-violence, many-sided thinking, and non-attachment. Its goal is to purify the soul through careful choices in thought, speech, and action so we live with more compassion, clarity, and self-discipline.',
        hindi:
            'जैन धर्म एक जीवन-पद्धति है जो अहिंसा, अनेकांत और अपरिग्रह पर आधारित है। इसका लक्ष्य विचार, वाणी और आचरण को शुद्ध करके आत्मा को अधिक करुणामय, स्पष्ट और संयमी बनाना है।',
        gujarati:
            'જૈન ધર્મ જીવન જીવવાની એવી પદ્ધતિ છે જે અહિંસા, અનેકાંત અને અપરીગ્રહ પર આધારિત છે. તેનો હેતુ વિચાર, વાણી અને વર્તનને શુદ્ધ કરીને આત્માને વધુ દયાળુ, સ્પષ્ટ અને સંયમી બનાવવાનો છે.',
      );
    }

    return _localized(
      english:
          'I could not reach the live Guru, but I can still help with quick basics. Try asking about Jainism, Ahimsa, karma, Aparigraha, Moksha, or the five vows.',
      hindi:
          'मैं लाइव गुरु तक नहीं पहुंच पाया, लेकिन मूल बातों में मदद कर सकता हूँ। जैन धर्म, अहिंसा, कर्म, अपरिग्रह, मोक्ष या पाँच व्रतों के बारे में पूछें।',
      gujarati:
          'હું લાઇવ ગુરુ સુધી પહોંચી શક્યો નથી, પણ મૂળભૂત માર્ગદર્શન આપી શકું છું. જૈન ધર્મ, અહિંસા, કર્મ, અપરીગ્રહ, મોક્ષ અથવા પાંચ વ્રતો વિશે પૂછો.',
    );
  }

  String _offlineReply(String text) {
    return '${_offlinePreface()}\n\n${_fallbackAnswer(text)}';
  }

  Future<void> _bootstrap() async {
    final apiKey = await _fetchApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('GuruController: missing geminiApiKey in app_config/ai');
      state = state.copyWith(
        isReady: false,
        error: 'Missing API key. Add geminiApiKey in app_config/ai.',
      );
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt()),
    );
    _chat = _model?.startChat();

    if (state.messages.isEmpty) {
      state = state.copyWith(
        messages: [
          GuruMessage(
            text: _localized(
              english:
                  'Namaste! Ask me anything about Jainism, practice, or values.',
              hindi:
                  'नमस्ते! जैन धर्म, अभ्यास या मूल्यों के बारे में मुझसे कुछ भी पूछें।',
              gujarati:
                  'નમસ્તે! જૈન ધર્મ, અભ્યાસ અથવા મૂલ્યો વિશે મને કશું પણ પૂછો.',
            ),
            isUser: false,
          ),
        ],
        isReady: true,
        clearError: true,
      );
    } else {
      state = state.copyWith(isReady: true, clearError: true);
    }
  }

  Future<String?> _fetchApiKey() async {
    final snapshot =
        await _firestore.collection(_configCollection).doc(_configDoc).get();
    final data = snapshot.data();
    return data?[_apiKeyField] as String?;
  }

  Future<void> _ensureReady() async {
    _initFuture ??= _bootstrap();
    await _initFuture;
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) {
      return;
    }

    state = state.copyWith(
      isSending: true,
      messages: [
        GuruMessage(text: trimmed, isUser: true),
        ...state.messages,
      ],
    );

    try {
      await _ensureReady();
      if (_chat == null) {
        state = state.copyWith(
          isSending: false,
          messages: [
            GuruMessage(
              text: _offlineReply(trimmed),
              isUser: false,
            ),
            ...state.messages,
          ],
          clearError: true,
        );
        return;
      }

      final response = await _chat!.sendMessage(
        Content.text('Respond in $_languageName.\n\n$trimmed'),
      );
      final reply = response.text?.trim();
      state = state.copyWith(
        isSending: false,
        messages: [
          GuruMessage(
            text: reply?.isNotEmpty == true
                ? reply!
                : _localized(
                    english:
                        'I am not sure yet. Try asking in a different way.',
                    hindi:
                        'मुझे अभी पूरा भरोसा नहीं है। कृपया दूसरे तरीके से पूछें।',
                    gujarati:
                        'હાલ હું નિશ્ચિત નથી. કૃપા કરીને પ્રશ્નને બીજા રીતે પૂછો.',
                  ),
            isUser: false,
          ),
          ...state.messages,
        ],
        clearError: true,
      );
    } catch (error, stackTrace) {
      debugPrint('GuruController: sendMessage failed: $error');
      debugPrint('$stackTrace');
      state = state.copyWith(
        isSending: false,
        messages: [
          GuruMessage(
            text: _offlineReply(trimmed),
            isUser: false,
          ),
          ...state.messages,
        ],
        clearError: true,
      );
    }
  }

  Future<void> resetChat() async {
    state = state.copyWith(messages: const [], clearError: true);
    _initFuture = _bootstrap();
    await _initFuture;
  }
}

final guruProvider = StateNotifierProvider<GuruController, GuruState>((ref) {
  return GuruController(FirebaseFirestore.instance, ref);
});
