import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/glass_card.dart';

class GuruScreen extends StatefulWidget {
  const GuruScreen({super.key});

  @override
  State<GuruScreen> createState() => _GuruScreenState();
}

class _GuruScreenState extends State<GuruScreen> {
  static const String _apiKey = 'AIzaSyBQBR71RQwphVdHZRbzlN-7xMVgaAY_qsc';

  final List<String> _popularQuestions = const [
    'What is Jainism in one minute?',
    'Why is Ahimsa important?',
    'How does karma work?',
    'What are the 5 vows?',
    'What is Moksha?',
    'How can I practice non-attachment daily?',
  ];

  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final GenerativeModel _model;
  late final ChatSession _chat;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      systemInstruction: Content.system(
        'You are JainQuest Guru, a calm and concise Jain learning guide. '
        'Explain concepts simply for teens, avoid preachy tone, and keep answers short.',
      ),
    );
    _chat = _model.startChat();
    _messages.add(
      const _ChatMessage(
        text: 'Namaste! Ask me anything about Jainism, practice, or values.',
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? value]) async {
    final text = (value ?? _controller.text).trim();
    if (text.isEmpty || _isSending) {
      return;
    }

    setState(() {
      _messages.insert(0, _ChatMessage(text: text, isUser: true));
      _isSending = true;
    });
    _controller.clear();
    _scrollToTop();

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final reply = response.text?.trim();
      setState(() {
        _messages.insert(
          0,
          _ChatMessage(
            text: reply?.isNotEmpty == true
                ? reply!
                : 'I am not sure yet. Try asking in a different way.',
            isUser: false,
          ),
        );
      });
    } catch (error) {
      setState(() {
        _messages.insert(
          0,
          _ChatMessage(
            text: 'I ran into a connection issue. Please try again.',
            isUser: false,
            isError: true,
          ),
        );
      });
    } finally {
      setState(() {
        _isSending = false;
      });
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showSuggestions = _messages.length <= 1;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.psychology_rounded,
                    color: AppColors.highlight,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Ask Guru',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  if (_isSending)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    color: AppColors.textSecondary,
                    onPressed: () {
                      setState(() {
                        _messages
                          ..clear()
                          ..add(
                            const _ChatMessage(
                              text:
                                  'Namaste! Ask me anything about Jainism, practice, or values.',
                              isUser: false,
                            ),
                          );
                      });
                    },
                  ),
                ],
              ),
            ),
            if (showSuggestions)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: _popularQuestions.map((question) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: FloatingCard(
                          onTap: () => _sendMessage(question),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            question,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _ChatBubble(message: message);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Type your question...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded),
                      color: AppColors.primary,
                      onPressed: _isSending ? null : _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;

  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final bubbleColor = isUser
        ? AppColors.primary.withOpacityValue(0.2)
        : AppColors.backgroundCard.withOpacityValue(0.7);
    final borderColor =
        message.isError ? AppColors.danger : AppColors.glassBorder;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final margin = isUser
        ? const EdgeInsets.only(left: AppSpacing.xl, bottom: AppSpacing.sm)
        : const EdgeInsets.only(right: AppSpacing.xl, bottom: AppSpacing.sm);

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: margin,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            message.text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: message.isError
                      ? AppColors.danger
                      : AppColors.textPrimary,
                ),
          ),
        ),
      ],
    );
  }
}
