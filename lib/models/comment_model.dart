import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String authorId;
  final String authorName;
  final String content;
  final bool isAnonymous;
  final int likeCount;
  final DateTime createdAt;

  CommentModel({
    required this.commentId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.isAnonymous,
    this.likeCount = 0,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommentModel(
      commentId: id,
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? 'Anonymous',
      content: map['content'] ?? '',
      isAnonymous: map['isAnonymous'] ?? true,
      likeCount: map['likeCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'isAnonymous': isAnonymous,
      'likeCount': likeCount,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}