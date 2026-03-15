import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_language.dart';
import '../localization/language_provider.dart';
import '../localization/translation_service.dart';

class TrText extends ConsumerStatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TrText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  ConsumerState<TrText> createState() => _TrTextState();
}

class _TrTextState extends ConsumerState<TrText> {
  late Future<String> _translationFuture;
  late String _seedText;
  AppLanguage? _seedLanguage;
  String? _cachedText;

  @override
  void initState() {
    super.initState();
    final language = ref.read(appLanguageProvider);
    _primeTranslation(language);
  }

  @override
  void didUpdateWidget(covariant TrText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text) {
      return;
    }
    _primeTranslation(_seedLanguage ?? ref.read(appLanguageProvider));
  }

  void _primeTranslation(AppLanguage language) {
    _seedLanguage = language;
    _seedText = widget.text;
    _cachedText =
        TranslationService.instance.getCached(widget.text, language) ??
            widget.text;
    _translationFuture =
        TranslationService.instance.translate(widget.text, language);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    if (_seedLanguage != language || _seedText != widget.text) {
      _primeTranslation(language);
    }

    final cached = TranslationService.instance.getCached(widget.text, language);
    if (cached != null) {
      return Text(
        cached,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    return FutureBuilder<String>(
      future: _translationFuture,
      initialData: _cachedText ?? widget.text,
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? _cachedText ?? widget.text,
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        );
      },
    );
  }
}
