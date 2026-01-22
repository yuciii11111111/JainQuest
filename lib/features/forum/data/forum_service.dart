import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/storage_service.dart';
import 'forum_models.dart';

class ForumService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ForumService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection('forum_posts');

  Future<User> _ensureUser() async {
    final current = _auth.currentUser;
    if (current != null) {
      return current;
    }
    final result = await _auth.signInAnonymously();
    if (result.user == null) {
      throw StateError('Unable to authenticate user.');
    }
    return result.user!;
  }

  Future<String> currentUserId() async {
    final user = await _ensureUser();
    return user.uid;
  }

  Stream<List<ForumPost>> watchPosts({String? category}) {
    Query<Map<String, dynamic>> query = _posts.orderBy('createdAt', descending: true);
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs.map(ForumPost.fromDoc).toList(),
        );
  }

  Stream<List<ForumReply>> watchReplies(String postId) {
    return _posts
        .doc(postId)
        .collection('replies')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ForumReply.fromDoc(postId, doc))
              .toList(),
        );
  }

  Future<void> createPost({
    required String content,
    required String category,
    required List<String> tags,
  }) async {
    final user = await _ensureUser();
    final profile = StorageService.getUserProfile();
    final displayName = (profile.displayName ?? 'Learner').trim();
    final handle = _buildHandle(displayName, user.uid);

    await _posts.add({
      'authorId': user.uid,
      'authorName': displayName,
      'authorHandle': handle,
      'category': category,
      'content': content,
      'tags': tags,
      'createdAt': FieldValue.serverTimestamp(),
      'likesCount': 0,
      'repliesCount': 0,
      'likedBy': <String>[],
    });
  }

  Future<void> toggleLike(ForumPost post) async {
    final user = await _ensureUser();
    final postRef = _posts.doc(post.id);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(postRef);
      if (!snap.exists) {
        return;
      }
      final data = snap.data() as Map<String, dynamic>? ?? {};
      final likedBy = List<String>.from(data['likedBy'] as List<dynamic>? ?? const []);
      final isLiked = likedBy.contains(user.uid);
      if (isLiked) {
        likedBy.remove(user.uid);
      } else {
        likedBy.add(user.uid);
      }
      tx.update(postRef, {
        'likedBy': likedBy,
        'likesCount': FieldValue.increment(isLiked ? -1 : 1),
      });
    });
  }

  Future<void> addReply({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    final user = await _ensureUser();
    final profile = StorageService.getUserProfile();
    final displayName = (profile.displayName ?? 'Learner').trim();
    final handle = _buildHandle(displayName, user.uid);

    final replyRef = _posts.doc(postId).collection('replies').doc();
    await _firestore.runTransaction((tx) async {
      tx.set(replyRef, {
        'authorId': user.uid,
        'authorName': displayName,
        'authorHandle': handle,
        'content': content,
        'parentId': parentId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      tx.update(_posts.doc(postId), {
        'repliesCount': FieldValue.increment(1),
      });
    });
  }

  Future<void> deletePost({
    required String postId,
    required String authorId,
  }) async {
    final user = await _ensureUser();
    if (user.uid != authorId) {
      throw StateError('Only the owner can delete this post.');
    }

    final replySnap = await _posts.doc(postId).collection('replies').get();
    final batch = _firestore.batch();
    for (final doc in replySnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_posts.doc(postId));
    await batch.commit();
  }

  Future<void> deleteReply({
    required String postId,
    required String replyId,
    required String authorId,
  }) async {
    final user = await _ensureUser();
    if (user.uid != authorId) {
      throw StateError('Only the owner can delete this reply.');
    }

    final repliesSnap =
        await _posts.doc(postId).collection('replies').get();
    if (repliesSnap.docs.isEmpty) {
      return;
    }

    final childrenMap = <String, List<String>>{};
    for (final doc in repliesSnap.docs) {
      final data = doc.data();
      final parentId = data['parentId'] as String?;
      if (parentId == null) continue;
      childrenMap.putIfAbsent(parentId, () => []).add(doc.id);
    }

    final toDelete = <String>{};
    final queue = <String>[replyId];
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      if (!toDelete.add(current)) continue;
      final children = childrenMap[current] ?? const [];
      queue.addAll(children);
    }

    if (toDelete.isEmpty) {
      return;
    }

    final batch = _firestore.batch();
    final repliesRef = _posts.doc(postId).collection('replies');
    for (final id in toDelete) {
      batch.delete(repliesRef.doc(id));
    }
    batch.update(_posts.doc(postId), {
      'repliesCount': FieldValue.increment(-toDelete.length),
    });
    await batch.commit();
  }

  String _buildHandle(String name, String userId) {
    final trimmed = name.trim();
    if (trimmed.isNotEmpty) {
      return '@${trimmed.toLowerCase().replaceAll(RegExp(r'\\s+'), '')}';
    }
    return '@user${userId.substring(0, 4)}';
  }
}
