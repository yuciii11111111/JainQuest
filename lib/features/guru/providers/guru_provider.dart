import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
  static const _systemPrompt =
      'You are JainQuest Guru, a calm and concise Jain learning guide. '
      'Explain concepts simply for teens, avoid preachy tone, and keep answers short.';
  static const _welcomeMessage =
      'Namaste! Ask me anything about Jainism, practice, or values.';

  final FirebaseFirestore _firestore;
  GenerativeModel? _model;
  ChatSession? _chat;
  Future<void>? _initFuture;

  GuruController(this._firestore) : super(const GuruState()) {
    _initFuture = _bootstrap();
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
      systemInstruction: Content.system(_systemPrompt),
    );
    _chat = _model?.startChat();

    if (state.messages.isEmpty) {
      state = state.copyWith(
        messages: [const GuruMessage(text: _welcomeMessage, isUser: false)],
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
            const GuruMessage(
              text: 'I am not ready yet. Please try again later.',
              isUser: false,
              isError: true,
            ),
            ...state.messages,
          ],
          clearError: true,
        );
        return;
      }

      final response = await _chat!.sendMessage(Content.text(trimmed));
      final reply = response.text?.trim();
      state = state.copyWith(
        isSending: false,
        messages: [
          GuruMessage(
            text: reply?.isNotEmpty == true
                ? reply!
                : 'I am not sure yet. Try asking in a different way.',
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
          const GuruMessage(
            text: 'I ran into a connection issue. Please try again.',
            isUser: false,
            isError: true,
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
  return GuruController(FirebaseFirestore.instance);
});
