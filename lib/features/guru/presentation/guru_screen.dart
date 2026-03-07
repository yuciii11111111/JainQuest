import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/glass_card.dart';
import '../providers/guru_provider.dart';

class GuruScreen extends ConsumerStatefulWidget {
  const GuruScreen({super.key});

  @override
  ConsumerState<GuruScreen> createState() => _GuruScreenState();
}

class _GuruScreenState extends ConsumerState<GuruScreen> {
  final List<String> _popularQuestions = const [
    'What is Jainism in one minute?',
    'Why is Ahimsa important?',
    'How does karma work?',
    'What are the 5 vows?',
    'What is Moksha?',
    'How can I practice non-attachment daily?',
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? value]) async {
    final text = (value ?? _controller.text).trim();
    if (text.isEmpty) {
      return;
    }
    _controller.clear();
    await ref.read(guruProvider.notifier).sendMessage(text);
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    ref.listen<GuruState>(guruProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTop());
      }
    });
    final state = ref.watch(guruProvider);
    final showSuggestions = state.messages.length <= 1;

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
                  Image.asset(
                    'assets/images/duo_guide.png',
                    height: 32,
                    width: 32,
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
                  if (state.isSending)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    color: scheme.onSurfaceVariant,
                    onPressed: () =>
                        ref.read(guruProvider.notifier).resetChat(),
                  ),
                ],
              ),
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  state.error!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.danger,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (showSuggestions)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final message = state.messages[index];
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
                      onPressed: state.isSending ? null : _sendMessage,
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

class _ChatBubble extends StatelessWidget {
  final GuruMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isUser = message.isUser;
    final bubbleColor = isUser
        ? AppColors.primary.withOpacityValue(0.2)
        : scheme.surfaceContainerHighest.withOpacityValue(0.7);
    final borderColor = message.isError ? AppColors.danger : scheme.outline;
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
                  color: message.isError ? AppColors.danger : scheme.onSurface,
                ),
          ),
        ),
      ],
    );
  }
}
