import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_card.dart';
import '../data/forum_models.dart';
import '../data/forum_service.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final ForumService _service = ForumService();

  String? _activeCategoryId;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final uid = await _service.currentUserId();
    if (mounted) {
      setState(() => _currentUserId = uid);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openPostComposer() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _PostComposerSheet(
          service: _service,
          initialCategory: _activeCategoryId,
          onError: _showSnack,
        );
      },
    );
  }

  Future<void> _openReplyComposer({
    required ForumPost post,
    ForumReply? parent,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ReplyComposerSheet(
          post: post,
          parent: parent,
          service: _service,
          onError: _showSnack,
        );
      },
    );
  }

  Future<void> _deletePost(ForumPost post) async {
    try {
      await _service.deletePost(postId: post.id, authorId: post.authorId);
    } catch (_) {
      _showSnack('You can only delete your own post.');
    }
  }

  Future<void> _deleteReply(ForumReply reply) async {
    try {
      await _service.deleteReply(
        postId: reply.postId,
        replyId: reply.id,
        authorId: reply.authorId,
      );
    } catch (_) {
      _showSnack('You can only delete your own reply.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Community Forum'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: _CategoryStrip(
                categories: ForumCategory.presets,
                activeCategoryId: _activeCategoryId,
                onSelect: (categoryId) {
                  setState(() => _activeCategoryId = categoryId);
                },
                onShowAll: () => setState(() => _activeCategoryId = null),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ForumPost>>(
                stream: _service.watchPosts(category: _activeCategoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final posts = snapshot.data ?? const [];
                  if (posts.isEmpty) {
                    return Center(
                      child: Text(
                        'No posts yet. Start the conversation!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _PostCard(
                        post: post,
                        currentUserId: _currentUserId,
                        onLike: () => _service.toggleLike(post),
                        onReply: () => _openReplyComposer(post: post),
                        onDelete: () => _deletePost(post),
                        timeLabel: _formatTime(post.createdAt),
                        repliesBuilder: _RepliesSection(
                          post: post,
                          currentUserId: _currentUserId,
                          service: _service,
                          onReply: (reply) =>
                              _openReplyComposer(post: post, parent: reply),
                          onDelete: _deleteReply,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostComposer,
        backgroundColor: scheme.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  String _formatTime(DateTime? timestamp) {
    if (timestamp == null) return 'just now';
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
  }
}

class _CategoryStrip extends StatelessWidget {
  final List<ForumCategory> categories;
  final String? activeCategoryId;
  final ValueChanged<String> onSelect;
  final VoidCallback onShowAll;

  const _CategoryStrip({
    required this.categories,
    required this.activeCategoryId,
    required this.onSelect,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _CategoryChip(
                  label: 'All',
                  isActive: activeCategoryId == null,
                  onTap: onShowAll,
                ),
                for (final category in categories)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.sm),
                    child: _CategoryChip(
                      label: category.label,
                      isActive: category.id == activeCategoryId,
                      onTap: () => onSelect(category.id),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Icon(Icons.filter_list_rounded, color: scheme.onSurfaceVariant),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : scheme.surfaceContainerHighest.withOpacityValue(0.7),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isActive ? AppColors.primary : scheme.outline,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isActive ? Colors.white : scheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final ForumPost post;
  final String? currentUserId;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onDelete;
  final String timeLabel;
  final Widget repliesBuilder;

  const _PostCard({
    required this.post,
    required this.currentUserId,
    required this.onLike,
    required this.onReply,
    required this.onDelete,
    required this.timeLabel,
    required this.repliesBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isOwner = currentUserId != null && currentUserId == post.authorId;
    final isLiked = post.isLikedBy(currentUserId);

    return FloatingCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacityValue(0.8),
                child: Text(_initials(post.authorName)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      '${post.authorHandle} • $timeLabel',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              if (isOwner)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: scheme.onSurfaceVariant,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withOpacityValue(0.7),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: scheme.outline),
                      ),
                      child: Text(
                        '#$tag',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _PostMetric(
                icon: isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: '${post.likesCount}',
                color: isLiked ? AppColors.danger : scheme.onSurfaceVariant,
                onTap: onLike,
              ),
              const SizedBox(width: AppSpacing.md),
              _PostMetric(
                icon: Icons.chat_bubble_outline_rounded,
                label: '${post.repliesCount}',
                color: scheme.onSurfaceVariant,
                onTap: onReply,
              ),
              const Spacer(),
              TextButton(
                onPressed: onReply,
                child: const Text('Reply'),
              ),
            ],
          ),
          repliesBuilder,
        ],
      ),
    );
  }
}

class _RepliesSection extends StatelessWidget {
  final ForumPost post;
  final String? currentUserId;
  final ForumService service;
  final ValueChanged<ForumReply> onReply;
  final ValueChanged<ForumReply> onDelete;

  const _RepliesSection({
    required this.post,
    required this.currentUserId,
    required this.service,
    required this.onReply,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ForumReply>>(
      stream: service.watchReplies(post.id),
      builder: (context, snapshot) {
        final replies = snapshot.data ?? const [];
        if (replies.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: _ReplyThread(
            replies: replies,
            currentUserId: currentUserId,
            onReply: onReply,
            onDelete: onDelete,
          ),
        );
      },
    );
  }
}

class _ReplyThread extends StatelessWidget {
  final List<ForumReply> replies;
  final String? currentUserId;
  final ValueChanged<ForumReply> onReply;
  final ValueChanged<ForumReply> onDelete;

  const _ReplyThread({
    required this.replies,
    required this.currentUserId,
    required this.onReply,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = <String?, List<ForumReply>>{};
    for (final reply in replies) {
      grouped.putIfAbsent(reply.parentId, () => []).add(reply);
    }

    List<Widget> buildReplies(String? parentId, int depth) {
      final list = grouped[parentId] ?? const [];
      return list
          .map(
            (reply) => _ReplyNode(
              reply: reply,
              depth: depth,
              isOwner: currentUserId == reply.authorId,
              onReply: () => onReply(reply),
              onDelete: () => onDelete(reply),
              childReplies: buildReplies(reply.id, depth + 1),
            ),
          )
          .toList();
    }

    return Column(
      children: buildReplies(null, 0),
    );
  }
}

class _ReplyNode extends StatelessWidget {
  final ForumReply reply;
  final int depth;
  final bool isOwner;
  final VoidCallback onReply;
  final VoidCallback onDelete;
  final List<Widget> childReplies;

  const _ReplyNode({
    required this.reply,
    required this.depth,
    required this.isOwner,
    required this.onReply,
    required this.onDelete,
    required this.childReplies,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final indent = (depth * 16).clamp(0, 48).toDouble();

    return Padding(
      padding: EdgeInsets.only(left: indent, bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacityValue(0.6),
          borderRadius: BorderRadius.circular(AppRadius.small),
          border: Border.all(color: scheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  reply.authorName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  reply.authorHandle,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: onReply,
                  child: const Text('Reply'),
                ),
                if (isOwner)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    color: scheme.onSurfaceVariant,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              reply.content,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (childReplies.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Column(children: childReplies),
            ],
          ],
        ),
      ),
    );
  }
}

class _PostMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PostMetric({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

String _initials(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '?';
  return trimmed.substring(0, 1).toUpperCase();
}

class _ReplyComposerSheet extends StatefulWidget {
  final ForumPost post;
  final ForumReply? parent;
  final ForumService service;
  final ValueChanged<String> onError;

  const _ReplyComposerSheet({
    required this.post,
    required this.parent,
    required this.service,
    required this.onError,
  });

  @override
  State<_ReplyComposerSheet> createState() => _ReplyComposerSheetState();
}

class _ReplyComposerSheetState extends State<_ReplyComposerSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.large),
          ),
          border: Border(top: BorderSide(color: scheme.outline)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.parent == null
                    ? 'Reply to ${widget.post.authorName}'
                    : 'Reply to ${widget.parent!.authorName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.parent == null
                    ? widget.post.content
                    : widget.parent!.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _controller,
                maxLines: 4,
                minLines: 1,
                autofocus: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Write your reply...',
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest.withOpacityValue(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text(
                    'Be respectful.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final text = _controller.text.trim();
                      if (text.isEmpty) {
                        return;
                      }
                      try {
                        await widget.service.addReply(
                          postId: widget.post.id,
                          content: text,
                          parentId: widget.parent?.id,
                        );
                        if (mounted) Navigator.of(context).pop();
                      } catch (e) {
                        widget.onError('Could not post reply.');
                      }
                    },
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Reply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostComposerSheet extends StatefulWidget {
  final ForumService service;
  final String? initialCategory;
  final ValueChanged<String> onError;

  const _PostComposerSheet({
    required this.service,
    required this.initialCategory,
    required this.onError,
  });

  @override
  State<_PostComposerSheet> createState() => _PostComposerSheetState();
}

class _PostComposerSheetState extends State<_PostComposerSheet> {
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _tagsController = TextEditingController();
    _selectedCategory =
        widget.initialCategory ?? ForumCategory.presets.first.id;
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .map((tag) => tag.toLowerCase())
        .toSet()
        .toList();
  }

  Future<void> _submit() async {
    final text = _contentController.text.trim();
    if (text.isEmpty) {
      widget.onError('Write something before posting.');
      return;
    }

    try {
      await widget.service.createPost(
        content: text,
        category: _selectedCategory!,
        tags: _parseTags(_tagsController.text),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      widget.onError('Could not create post. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.large),
          ),
          border: Border(top: BorderSide(color: scheme.outline)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Post',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),

              // Category Selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ForumCategory.presets.map((category) {
                    final isSelected = category.id == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(category.label),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = category.id);
                          }
                        },
                        backgroundColor:
                            scheme.surfaceContainerHighest.withOpacityValue(0.5),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : scheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          side: BorderSide(
                            color:
                                isSelected ? AppColors.primary : scheme.outline,
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _contentController,
                maxLines: 5,
                minLines: 3,
                autofocus: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText:
                      'Share a thought, ask a question, or start a challenge...',
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest.withOpacityValue(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _tagsController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Tags (comma separated)',
                  prefixIcon: Icon(Icons.tag_rounded,
                      color: scheme.onSurfaceVariant, size: 20),
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest.withOpacityValue(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Text(
                    'Be kind, be curious.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Post'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
