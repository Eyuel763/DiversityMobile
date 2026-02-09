import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new confession
  Future<void> uploadPost(PostModel post) async {
    try {
      await _db.collection('posts').add(post.toMap());
    } catch (e) {
      throw Exception("Failed to upload confession: $e");
    }
  }

  // Fetch posts with optional university filter
  Stream<List<PostModel>> getPosts({String? universityFilter}) {
    Query query = _db
        .collection('posts')
        .orderBy('createdAt', descending: true);

    if (universityFilter != null) {
      query = query.where('universityName', isEqualTo: universityFilter);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Increment comment count when a new comment is added
  Future<void> incrementCommentCount(String postId) async {
    await _db.collection('posts').doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });
  }

  // Update reaction counts when a user reacts to a post
  Future<void> updateReactionCount(String postId, String reactionType, int value,) async {
    // value would be 1 to add, -1 to remove
    await _db.collection('posts').doc(postId).update({
      'reactionCounts.$reactionType': FieldValue.increment(value),
    });
  }
}
