import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/motion_pressable.dart';
import '../data/forum_models.dart';
import '../data/forum_service.dart';
import '../../../core/localization/app_strings.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final ForumService _service = ForumService();

  String? _activeCategoryId;
  String? _currentUserId;
  List<ForumCategory> _availableCategories = ForumCategory.presets;

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
    if (_availableCategories.isEmpty) {
      _showSnack(context.t('no_community'));
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _PostComposerSheet(
          service: _service,
          categories: _availableCategories,
          initialCategory: _activeCategoryId,
        );
      },
    );
  }

  Future<void> _openCommunityComposer() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CommunityComposerSheet(
          service: _service,
          onCreated: (communityId) {
            if (!mounted) return;
            setState(() => _activeCategoryId = communityId);
            _showSnack(context.t('community_created'));
          },
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
        );
      },
    );
  }

  Future<void> _deletePost(ForumPost post) async {
    final deleteOwnPostMessage = context.t('delete_own_post');
    try {
      await _service.deletePost(postId: post.id, authorId: post.authorId);
    } catch (_) {
      _showSnack(deleteOwnPostMessage);
    }
  }

  Future<void> _deleteReply(ForumReply reply) async {
    final deleteOwnReplyMessage = context.t('delete_own_reply');
    try {
      await _service.deleteReply(
        postId: reply.postId,
        replyId: reply.id,
        authorId: reply.authorId,
      );
    } catch (_) {
      _showSnack(deleteOwnReplyMessage);
    }
  }

  Future<bool> _confirmDelete({
    required String title,
    required String message,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.t('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              context.t('delete'),
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _confirmDeletePost(ForumPost post) async {
    final confirmed = await _confirmDelete(
      title: context.t('delete_post_confirm_title'),
      message: context.t('delete_post_confirm_message'),
    );
    if (confirmed) {
      await _deletePost(post);
    }
  }

  Future<void> _confirmDeleteReply(ForumReply reply) async {
    final confirmed = await _confirmDelete(
      title: context.t('delete_reply_confirm_title'),
      message: context.t('delete_reply_confirm_message'),
    );
    if (confirmed) {
      await _deleteReply(reply);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(context.t('community_forum')),
      ),
      body: SafeArea(
        child: StreamBuilder<List<ForumCommunity>>(
          stream: _service.watchCommunities(),
          builder: (context, communitiesSnapshot) {
            final communities = communitiesSnapshot.data ?? const [];
            final categories = [
              ...ForumCategory.presets,
              ...communities.map((community) => community.toCategory()),
            ];
            _availableCategories = categories;

            if (_activeCategoryId != null &&
                !categories.any((c) => c.id == _activeCategoryId)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                setState(() => _activeCategoryId = null);
              });
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  child: _CategoryStrip(
                    categories: categories,
                    activeCategoryId: _activeCategoryId,
                    onSelect: (categoryId) {
                      setState(() => _activeCategoryId = categoryId);
                    },
                    onShowAll: () => setState(() => _activeCategoryId = null),
                    onAddCommunity: _openCommunityComposer,
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
                            context.t('no_posts_yet'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg),
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
                            onDelete: () => _confirmDeletePost(post),
                            timeLabel: _formatTime(post.createdAt),
                            repliesBuilder: post.repliesCount > 0
                                ? _RepliesSection(
                                    post: post,
                                    currentUserId: _currentUserId,
                                    service: _service,
                                    onReply: (reply) => _openReplyComposer(
                                      post: post,
                                      parent: reply,
                                    ),
                                    onDelete: _confirmDeleteReply,
                                  )
                                : const SizedBox.shrink(),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostComposer,
        backgroundColor: scheme.primary,
        tooltip: context.t('create_post'),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  String _formatTime(DateTime? timestamp) {
    if (timestamp == null) return context.t('just_now');
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return context.t('just_now');
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return MaterialLocalizations.of(context)
        .formatShortDate(timestamp.toLocal());
  }
}

class _CategoryStrip extends StatelessWidget {
  final List<ForumCategory> categories;
  final String? activeCategoryId;
  final ValueChanged<String> onSelect;
  final VoidCallback onShowAll;
  final VoidCallback onAddCommunity;

  const _CategoryStrip({
    required this.categories,
    required this.activeCategoryId,
    required this.onSelect,
    required this.onShowAll,
    required this.onAddCommunity,
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
                  label: context.t('all_category'),
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
        TextButton.icon(
          onPressed: onAddCommunity,
          icon: const Icon(Icons.group_add_rounded, size: 18),
          label: Text(context.t('new_community')),
          style: TextButton.styleFrom(
            foregroundColor: scheme.onSurfaceVariant,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
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
    return MotionPressable(
      child: InkWell(
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
                  tooltip: context.t('delete_post'),
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
                        color: scheme.surfaceContainerHighest
                            .withOpacityValue(0.7),
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
                child: Text(context.t('reply')),
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
                  child: Text(context.t('reply')),
                ),
                if (isOwner)
                  IconButton(
                    onPressed: onDelete,
                    tooltip: context.t('delete_reply'),
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
    return MotionPressable(
      child: InkWell(
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

  const _ReplyComposerSheet({
    required this.post,
    required this.parent,
    required this.service,
  });

  @override
  State<_ReplyComposerSheet> createState() => _ReplyComposerSheetState();
}

class _ReplyComposerSheetState extends State<_ReplyComposerSheet> {
  late final TextEditingController _controller;
  late final FocusNode _replyFocusNode;
  bool _isSubmitting = false;
  String? _replyError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _replyFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    final text = _controller.text.trim();
    setState(() {
      _replyError = null;
      _submitError = null;
    });
    if (text.isEmpty) {
      setState(() {
        _replyError = context.t('reply_required');
      });
      _replyFocusNode.requestFocus();
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await widget.service.addReply(
        postId: widget.post.id,
        content: text,
        parentId: widget.parent?.id,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      setState(() {
        _submitError = context.t('could_not_post_reply');
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
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
                widget.parent == null
                    ? context
                        .t('reply_to', args: {'name': widget.post.authorName})
                    : context.t('reply_to',
                        args: {'name': widget.parent!.authorName}),
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
                focusNode: _replyFocusNode,
                enabled: !_isSubmitting,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (_) {
                  if (_replyError == null && _submitError == null) {
                    return;
                  }
                  setState(() {
                    _replyError = null;
                    _submitError = null;
                  });
                },
                decoration: InputDecoration(
                  labelText: context.t('reply'),
                  hintText: context.t('write_reply'),
                  errorText: _replyError,
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor:
                      scheme.surfaceContainerHighest.withOpacityValue(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_submitError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _submitError!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text(
                    context.t('be_respectful'),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.send_rounded, size: 18),
                              const SizedBox(width: AppSpacing.sm),
                              Text(context.t('reply')),
                            ],
                          ),
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

class _CommunityComposerSheet extends StatefulWidget {
  final ForumService service;
  final ValueChanged<String> onCreated;

  const _CommunityComposerSheet({
    required this.service,
    required this.onCreated,
  });

  @override
  State<_CommunityComposerSheet> createState() =>
      _CommunityComposerSheetState();
}

class _CommunityComposerSheetState extends State<_CommunityComposerSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final FocusNode _nameFocusNode;
  bool _isSubmitting = false;
  String? _nameError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    final name = _nameController.text.trim();
    setState(() {
      _nameError = null;
      _submitError = null;
    });
    if (name.isEmpty) {
      setState(() {
        _nameError = context.t('community_name_required');
      });
      _nameFocusNode.requestFocus();
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final communityId = await widget.service.createCommunity(
        name: name,
        description: _descriptionController.text,
      );
      widget.onCreated(communityId);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      setState(() {
        _submitError = context.t('could_not_create_community');
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
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
                context.t('create_community'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.t('admin_note'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                enabled: !_isSubmitting,
                maxLength: 40,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (_) {
                  if (_nameError == null && _submitError == null) {
                    return;
                  }
                  setState(() {
                    _nameError = null;
                    _submitError = null;
                  });
                },
                decoration: InputDecoration(
                  labelText: context.t('community_name'),
                  hintText: context.t('community_name'),
                  errorText: _nameError,
                  filled: true,
                  fillColor:
                      scheme.surfaceContainerHighest.withOpacityValue(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _descriptionController,
                enabled: !_isSubmitting,
                maxLines: 3,
                minLines: 2,
                maxLength: 120,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: context.t('group_about'),
                  hintText: context.t('group_about'),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor:
                      scheme.surfaceContainerHighest.withOpacityValue(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_submitError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _submitError!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.group_add_rounded, size: 18),
                              const SizedBox(width: AppSpacing.sm),
                              Text(context.t('create')),
                            ],
                          ),
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
  final List<ForumCategory> categories;
  final String? initialCategory;

  const _PostComposerSheet({
    required this.service,
    required this.categories,
    required this.initialCategory,
  });

  @override
  State<_PostComposerSheet> createState() => _PostComposerSheetState();
}

class _PostComposerSheetState extends State<_PostComposerSheet> {
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  late final FocusNode _contentFocusNode;
  bool _isSubmitting = false;
  String? _selectedCategory;
  String? _contentError;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _tagsController = TextEditingController();
    _contentFocusNode = FocusNode();
    final hasInitial = widget.initialCategory != null &&
        widget.categories.any((c) => c.id == widget.initialCategory);
    _selectedCategory = hasInitial
        ? widget.initialCategory
        : (widget.categories.isNotEmpty ? widget.categories.first.id : null);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    _contentFocusNode.dispose();
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
    if (_isSubmitting) {
      return;
    }
    final text = _contentController.text.trim();
    setState(() {
      _contentError = null;
      _submitError = null;
    });
    if (text.isEmpty) {
      setState(() {
        _contentError = context.t('write_before_posting');
      });
      _contentFocusNode.requestFocus();
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await widget.service.createPost(
        content: text,
        category: _selectedCategory!,
        tags: _parseTags(_tagsController.text),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      setState(() {
        _submitError = context.t('could_not_create_post');
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
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
                context.t('create_post'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),

              // Category Selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.categories.map((category) {
                    final isSelected = category.id == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(category.label),
                        selected: isSelected,
                        onSelected: _isSubmitting
                            ? null
                            : (selected) {
                                if (selected) {
                                  setState(
                                      () => _selectedCategory = category.id);
                                }
                              },
                        backgroundColor: scheme.surfaceContainerHighest
                            .withOpacityValue(0.5),
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
                focusNode: _contentFocusNode,
                enabled: !_isSubmitting,
                maxLines: 5,
                minLines: 3,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (_) {
                  if (_contentError == null && _submitError == null) {
                    return;
                  }
                  setState(() {
                    _contentError = null;
                    _submitError = null;
                  });
                },
                decoration: InputDecoration(
                  labelText: context.t('post_content'),
                  hintText: context.t('share_thought'),
                  errorText: _contentError,
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor:
                      scheme.surfaceContainerHighest.withOpacityValue(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _tagsController,
                enabled: !_isSubmitting,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  labelText: context.t('tags_label'),
                  hintText: context.t('tags_hint'),
                  prefixIcon: Icon(Icons.tag_rounded,
                      color: scheme.onSurfaceVariant, size: 20),
                  filled: true,
                  fillColor:
                      scheme.surfaceContainerHighest.withOpacityValue(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_submitError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _submitError!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Text(
                    context.t('be_kind'),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.send_rounded, size: 18),
                              const SizedBox(width: AppSpacing.sm),
                              Text(context.t('post')),
                            ],
                          ),
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
