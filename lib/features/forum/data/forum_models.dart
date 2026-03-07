import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  final String id;
  final String authorId;
  final String authorName;
  final String authorHandle;
  final String category;
  final String content;
  final List<String> tags;
  final DateTime? createdAt;
  final int likesCount;
  final int repliesCount;
  final List<String> likedBy;

  const ForumPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorHandle,
    required this.category,
    required this.content,
    required this.tags,
    required this.createdAt,
    required this.likesCount,
    required this.repliesCount,
    required this.likedBy,
  });

  factory ForumPost.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ForumPost(
      id: doc.id,
      authorId: (data['authorId'] as String?) ?? '',
      authorName: (data['authorName'] as String?) ?? 'Learner',
      authorHandle: (data['authorHandle'] as String?) ?? '@learner',
      category: (data['category'] as String?) ?? 'general',
      content: (data['content'] as String?) ?? '',
      tags: List<String>.from(data['tags'] as List<dynamic>? ?? const []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      likesCount: (data['likesCount'] as int?) ?? 0,
      repliesCount: (data['repliesCount'] as int?) ?? 0,
      likedBy: List<String>.from(data['likedBy'] as List<dynamic>? ?? const []),
    );
  }

  bool isLikedBy(String? userId) {
    if (userId == null) return false;
    return likedBy.contains(userId);
  }
}

class ForumReply {
  final String id;
  final String postId;
  final String? parentId;
  final String authorId;
  final String authorName;
  final String authorHandle;
  final String content;
  final DateTime? createdAt;

  const ForumReply({
    required this.id,
    required this.postId,
    required this.parentId,
    required this.authorId,
    required this.authorName,
    required this.authorHandle,
    required this.content,
    required this.createdAt,
  });

  factory ForumReply.fromDoc(
    String postId,
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return ForumReply(
      id: doc.id,
      postId: postId,
      parentId: data['parentId'] as String?,
      authorId: (data['authorId'] as String?) ?? '',
      authorName: (data['authorName'] as String?) ?? 'Learner',
      authorHandle: (data['authorHandle'] as String?) ?? '@learner',
      content: (data['content'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ForumCategory {
  final String id;
  final String label;

  const ForumCategory({required this.id, required this.label});

  static const List<ForumCategory> presets = [
    ForumCategory(id: 'general', label: 'General'),
    ForumCategory(id: 'reflection', label: 'Reflections'),
    ForumCategory(id: 'challenges', label: 'Challenges'),
  ];
}

class ForumCommunity {
  final String id;
  final String name;
  final String description;
  final String adminId;
  final String adminName;
  final String adminHandle;
  final DateTime? createdAt;

  const ForumCommunity({
    required this.id,
    required this.name,
    required this.description,
    required this.adminId,
    required this.adminName,
    required this.adminHandle,
    required this.createdAt,
  });

  factory ForumCommunity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ForumCommunity(
      id: doc.id,
      name: (data['name'] as String?) ?? 'Community',
      description: (data['description'] as String?) ?? '',
      adminId: (data['adminId'] as String?) ?? '',
      adminName: (data['adminName'] as String?) ?? 'Learner',
      adminHandle: (data['adminHandle'] as String?) ?? '@learner',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  ForumCategory toCategory() {
    return ForumCategory(id: id, label: name);
  }
}
