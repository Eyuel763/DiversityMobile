import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a comment and increment the post's comment count
  Future<void> addComment(String postId, CommentModel comment) async {
    final batch = _db.batch();
    
    DocumentReference commentRef = _db.collection('posts').doc(postId).collection('comments').doc();
    DocumentReference postRef = _db.collection('posts').doc(postId);

    batch.set(commentRef, comment.toMap());
    batch.update(postRef, {'commentCount': FieldValue.increment(1)});
    
    await batch.commit();
  }

  // Stream of comments for a post
  Stream<List<CommentModel>> getComments(String postId) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => CommentModel.fromMap(doc.data(), doc.id)).toList());
  }
}