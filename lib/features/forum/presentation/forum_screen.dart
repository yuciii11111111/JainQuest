import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/floating_card.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _composerController = TextEditingController();
  final FocusNode _composerFocusNode = FocusNode();
  final List<_ForumFolder> _folders = [
    const _ForumFolder(id: 'general', name: 'General'),
    const _ForumFolder(id: 'reflection', name: 'Reflections'),
    const _ForumFolder(id: 'challenges', name: 'Challenges'),
  ];
  String? _activeFolderId;

  final List<_ForumPost> _posts = [
    const _ForumPost(
      id: 'post-1',
      folderId: 'general',
      author: 'Aarav Jain',
      handle: '@aarav',
      timeAgo: '2h',
      content: 'What is your favorite way to stay mindful during a busy day?',
      likes: 42,
      repliesCount: 9,
      shares: 3,
      isPinned: true,
      isLiked: false,
      isBookmarked: false,
      isReposted: false,
      replies: [],
    ),
    const _ForumPost(
      id: 'post-2',
      folderId: 'reflection',
      author: 'Maya Shah',
      handle: '@mayashah',
      timeAgo: '5h',
      content:
          'Just finished the lesson on non-violence. The reflections were powerful. What stood out to you?',
      likes: 28,
      repliesCount: 6,
      shares: 1,
      isLiked: false,
      isBookmarked: false,
      isReposted: false,
      replies: [],
    ),
    const _ForumPost(
      id: 'post-3',
      folderId: 'challenges',
      author: 'Rohan Mehta',
      handle: '@rohan',
      timeAgo: '1d',
      content:
          'Challenge: share one small act of kindness you did today. I helped a neighbor carry groceries.',
      likes: 19,
      repliesCount: 4,
      shares: 2,
      isLiked: false,
      isBookmarked: false,
      isReposted: false,
      replies: [],
    ),
  ];

  @override
  void dispose() {
    _composerController.dispose();
    _composerFocusNode.dispose();
    super.dispose();
  }

  void _submitPost() {
    final text = _composerController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something before posting.')),
      );
      return;
    }
    final folderId = _activeFolderId ?? _folders.first.id;
    setState(() {
      _posts.insert(
        0,
        _ForumPost(
          id: 'post-${DateTime.now().millisecondsSinceEpoch}',
          folderId: folderId,
          author: 'You',
          handle: '@you',
          timeAgo: 'now',
          content: text,
          likes: 0,
          repliesCount: 0,
          shares: 0,
          isLiked: false,
          isBookmarked: false,
          isReposted: false,
          replies: [],
        ),
      );
    });
    _composerController.clear();
    _composerFocusNode.unfocus();
  }

  void _toggleLike(int index) {
    final post = _posts[index];
    final isLiked = !post.isLiked;
    setState(() {
      _posts[index] = post.copyWith(
        isLiked: isLiked,
        likes: post.likes + (isLiked ? 1 : -1),
      );
    });
  }

  void _toggleRepost(int index) {
    final post = _posts[index];
    final isReposted = !post.isReposted;
    setState(() {
      _posts[index] = post.copyWith(
        isReposted: isReposted,
        shares: post.shares + (isReposted ? 1 : -1),
      );
    });
  }

  void _toggleBookmark(int index) {
    final post = _posts[index];
    setState(() {
      _posts[index] = post.copyWith(isBookmarked: !post.isBookmarked);
    });
  }

  void _incrementReply(int index) {
    final post = _posts[index];
    _openReplyComposer(post: post, index: index);
  }

  void _openReplyComposer({
    required _ForumPost post,
    required int index,
  }) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final viewInsets = MediaQuery.of(context).viewInsets;
        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
              border: const Border(top: BorderSide(color: AppColors.glassBorder)),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reply to ${post.author}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Write your reply...',
                    filled: true,
                    fillColor: AppColors.backgroundElevated.withOpacityValue(0.6),
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
                            color: AppColors.textMuted,
                          ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isEmpty) {
                          return;
                        }
                        final updatedReplies = List<_ForumReply>.from(post.replies)
                          ..insert(
                            0,
                            _ForumReply(
                              author: 'You',
                              handle: '@you',
                              timeAgo: 'now',
                              content: text,
                            ),
                          );
                        setState(() {
                          _posts[index] = post.copyWith(
                            replies: updatedReplies,
                            repliesCount: post.repliesCount + 1,
                          );
                        });
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Reply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(controller.dispose);
  }

  void _openMyActivity() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ForumProfileScreen(posts: _posts),
      ),
    );
  }

  void _openCreateFolderDialog() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create folder'),
          content: TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Folder name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) {
                  return;
                }
                final id = 'folder-${DateTime.now().millisecondsSinceEpoch}';
                setState(() {
                  _folders.add(_ForumFolder(id: id, name: name));
                  _activeFolderId = id;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    ).whenComplete(controller.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final visiblePosts = _activeFolderId == null
        ? _posts
        : _posts.where((post) => post.folderId == _activeFolderId).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Community Forum'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
          ),
          IconButton(
            onPressed: _openMyActivity,
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
              child: _FolderStrip(
                folders: _folders,
                activeFolderId: _activeFolderId,
                onSelectFolder: (folderId) {
                  setState(() => _activeFolderId = folderId);
                },
                onShowAll: () => setState(() => _activeFolderId = null),
                onCreateFolder: _openCreateFolderDialog,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FloatingCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary,
                          child: Text('Y'),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundElevated.withOpacityValue(0.6),
                              borderRadius: BorderRadius.circular(AppRadius.small),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: TextField(
                              controller: _composerController,
                              focusNode: _composerFocusNode,
                              maxLines: 4,
                              minLines: 1,
                              style: Theme.of(context).textTheme.bodyMedium,
                              decoration: const InputDecoration(
                                hintText: "Share a thought, ask a question, or start a challenge...",
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Text(
                          'Be kind, be curious.',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _submitPost,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: const Text('Post'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: visiblePosts.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final post = visiblePosts[index];
                  final sourceIndex = _posts.indexOf(post);
                  return _PostCard(
                    post: post,
                    onLike: () => _toggleLike(sourceIndex),
                    onRepost: () => _toggleRepost(sourceIndex),
                    onBookmark: () => _toggleBookmark(sourceIndex),
                    onReply: () => _incrementReply(sourceIndex),
                    folderName: _folders.firstWhere((folder) => folder.id == post.folderId).name,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final _ForumPost post;
  final VoidCallback onLike;
  final VoidCallback onRepost;
  final VoidCallback onBookmark;
  final VoidCallback onReply;
  final String folderName;

  const _PostCard({
    required this.post,
    required this.onLike,
    required this.onRepost,
    required this.onBookmark,
    required this.onReply,
    required this.folderName,
  });

  @override
  Widget build(BuildContext context) {
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
                child: Text(post.author.substring(0, 1)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundElevated,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            folderName,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '• ${post.timeAgo}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          post.author,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          post.handle,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    if (post.isPinned)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: AppGradients.warm,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Text(
                          'Pinned',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded),
                color: AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _PostMetric(
                icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                label: '${post.likes}',
                color: post.isLiked ? AppColors.danger : AppColors.textSecondary,
                onTap: onLike,
              ),
              const SizedBox(width: AppSpacing.md),
              _PostMetric(
                icon: Icons.chat_bubble_outline_rounded,
                label: '${post.repliesCount}',
                color: AppColors.textSecondary,
                onTap: onReply,
              ),
              const SizedBox(width: AppSpacing.md),
              _PostMetric(
                icon: Icons.repeat_rounded,
                label: '${post.shares}',
                color: post.isReposted ? AppColors.success : AppColors.textSecondary,
                onTap: onRepost,
              ),
              const Spacer(),
              IconButton(
                onPressed: onBookmark,
                icon: Icon(
                  post.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                ),
                color: post.isBookmarked ? AppColors.secondary : AppColors.textMuted,
              ),
            ],
          ),
          if (post.replies.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Divider(color: AppColors.backgroundElevated.withOpacityValue(0.7), height: 1),
            const SizedBox(height: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: post.replies
                  .map(
                    (reply) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _ReplyBubble(reply: reply),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReplyBubble extends StatelessWidget {
  final _ForumReply reply;

  const _ReplyBubble({required this.reply});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated.withOpacityValue(0.6),
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                reply.author,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                reply.handle,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '• ${reply.timeAgo}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            reply.content,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
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
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForumPost {
  final String id;
  final String folderId;
  final String author;
  final String handle;
  final String timeAgo;
  final String content;
  final int likes;
  final int repliesCount;
  final int shares;
  final bool isPinned;
  final bool isLiked;
  final bool isBookmarked;
  final bool isReposted;
  final List<_ForumReply> replies;

  const _ForumPost({
    required this.id,
    required this.folderId,
    required this.author,
    required this.handle,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.repliesCount,
    required this.shares,
    this.isPinned = false,
    required this.isLiked,
    required this.isBookmarked,
    required this.isReposted,
    required this.replies,
  });

  _ForumPost copyWith({
    String? id,
    String? folderId,
    String? author,
    String? handle,
    String? timeAgo,
    String? content,
    int? likes,
    int? repliesCount,
    int? shares,
    bool? isPinned,
    bool? isLiked,
    bool? isBookmarked,
    bool? isReposted,
    List<_ForumReply>? replies,
  }) {
    return _ForumPost(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      author: author ?? this.author,
      handle: handle ?? this.handle,
      timeAgo: timeAgo ?? this.timeAgo,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      repliesCount: repliesCount ?? this.repliesCount,
      shares: shares ?? this.shares,
      isPinned: isPinned ?? this.isPinned,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isReposted: isReposted ?? this.isReposted,
      replies: replies ?? this.replies,
    );
  }
}

class _ForumReply {
  final String author;
  final String handle;
  final String timeAgo;
  final String content;

  const _ForumReply({
    required this.author,
    required this.handle,
    required this.timeAgo,
    required this.content,
  });
}

class ForumProfileScreen extends StatelessWidget {
  final List<_ForumPost> posts;

  const ForumProfileScreen({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    final liked = posts.where((post) => post.isLiked).toList();
    final reposted = posts.where((post) => post.isReposted).toList();
    final bookmarked = posts.where((post) => post.isBookmarked).toList();
    final myPosts = posts.where((post) => post.author == 'You').toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('My Activity'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Liked'),
              Tab(text: 'Retweeted'),
              Tab(text: 'Bookmarked'),
              Tab(text: 'My Posts'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _ActivityList(posts: liked, emptyLabel: 'No liked posts yet.'),
              _ActivityList(posts: reposted, emptyLabel: 'No retweeted posts yet.'),
              _ActivityList(posts: bookmarked, emptyLabel: 'No bookmarked posts yet.'),
              _ActivityList(posts: myPosts, emptyLabel: 'You have not posted yet.'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<_ForumPost> posts;
  final String emptyLabel;

  const _ActivityList({
    required this.posts,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => _PostCard(
        post: posts[index],
        onLike: () {},
        onRepost: () {},
        onBookmark: () {},
        onReply: () {},
      ),
    );
  }
}
