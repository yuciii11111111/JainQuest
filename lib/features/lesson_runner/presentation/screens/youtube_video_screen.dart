import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/lesson_models.dart';
import '../../../../core/widgets/common_widgets.dart';

class YoutubeVideoScreenWidget extends StatefulWidget {
  final YoutubeVideoScreen screen;
  final VoidCallback onContinue;

  const YoutubeVideoScreenWidget({
    super.key,
    required this.screen,
    required this.onContinue,
  });

  @override
  State<YoutubeVideoScreenWidget> createState() => _YoutubeVideoScreenWidgetState();
}

class _YoutubeVideoScreenWidgetState extends State<YoutubeVideoScreenWidget> {
  VideoPlayerController? _controller;
  bool _isReady = false;
  bool _isPlaying = false;
  bool _videoSupported = true;
  Duration _clipStart = Duration.zero;
  Duration _clipEnd = const Duration(seconds: 8);

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final asset = widget.screen.videoAsset;
    if (asset == null || asset.isEmpty) return;

    try {
      _clipStart = Duration(seconds: widget.screen.clipStartSeconds ?? 0);
      final defaultEnd = _clipStart + const Duration(seconds: 8);
      _clipEnd = Duration(seconds: widget.screen.clipEndSeconds ?? defaultEnd.inSeconds);

      final controller = VideoPlayerController.asset(asset);
      await controller.initialize();
      await controller.setLooping(false);
      await controller.seekTo(_clipStart);
      controller.addListener(_clipListener);

      if (mounted) {
        setState(() {
          _controller = controller;
          _isReady = true;
        });
      }
    } on UnimplementedError {
      if (mounted) {
        setState(() => _videoSupported = false);
      }
    }
  }

  void _clipListener() {
    final controller = _controller;
    if (controller == null) return;
    if (!controller.value.isInitialized) return;
    final position = controller.value.position;
    if (position >= _clipEnd && controller.value.isPlaying) {
      controller.pause();
      setState(() => _isPlaying = false);
    }
  }

  Future<void> _togglePlay() async {
    final controller = _controller;
    if (controller == null) return;
    if (!_isReady) return;

    if (_isPlaying) {
      await controller.pause();
      setState(() => _isPlaying = false);
    } else {
      final position = controller.value.position;
      if (position >= _clipEnd || position < _clipStart) {
        await controller.seekTo(_clipStart);
      }
      await controller.play();
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _restart() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.seekTo(_clipStart);
    await controller.play();
    setState(() => _isPlaying = true);
  }

  Future<void> _openExternally() async {
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('External video playback not supported on web')),
        );
      }
      return;
    }
    try {
      final data = await rootBundle.load(widget.screen.videoAsset!);
      final tempDir = await Directory.systemTemp.createTemp('jq_video');
      final filePath = '${tempDir.path}/lesson_preview.mp4';
      final file = File(filePath);
      await file.writeAsBytes(data.buffer.asUint8List());
      final uri = Uri.file(filePath);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open video externally')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video unavailable: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_clipListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasVideoAsset = widget.screen.videoAsset != null &&
        widget.screen.videoAsset!.isNotEmpty;
    final canShowVideo = hasVideoAsset && _videoSupported;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacityValue(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.play_circle_filled_rounded,
                        color: AppColors.secondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.screen.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.screen.note,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                if (!canShowVideo)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _videoSupported
                              ? 'Video snippet is unavailable.'
                              : 'Video playback is not supported on this device.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (hasVideoAsset) ...[
                          const SizedBox(height: AppSpacing.sm),
                          PrimaryButton(
                            label: 'Open video externally',
                            icon: Icons.open_in_new_rounded,
                            onPressed: _openExternally,
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.card),
                          ),
                          child: AspectRatio(
                            aspectRatio: _isReady
                                ? _controller!.value.aspectRatio
                                : 16 / 9,
                            child: _isReady
                                ? VideoPlayer(_controller!)
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                        if (_isReady)
                          VideoProgressIndicator(
                            _controller!,
                            allowScrubbing: true,
                            colors: VideoProgressColors(
                              playedColor: AppColors.primary,
                              bufferedColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              backgroundColor: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: _togglePlay,
                                icon: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                ),
                              ),
                              IconButton(
                                onPressed: _restart,
                                icon: const Icon(Icons.replay_rounded),
                              ),
                              const Spacer(),
                              Text(
                                'Clip ${_clipStart.inSeconds}s - ${_clipEnd.inSeconds}s',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      'Short video clip for this lesson.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: PrimaryButton(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: widget.onContinue,
            ),
          ),
        ),
      ],
    );
  }
}
