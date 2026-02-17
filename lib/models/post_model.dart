import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String authorId;
  final String authorName;
  final String universityName; // 
  final bool isAnonymous;
  final String content;
  final List<String> tags;
  final Map<String, int> reactionCounts;
  final int commentCount;
  final DateTime createdAt;
  final int viewCount;

  PostModel({
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.universityName,
    required this.isAnonymous,
    required this.content,
    this.tags = const [],
    this.reactionCounts = const {
      'relatable': 0,
      'support': 0,
      'laugh': 0,
      'thoughtProvoking': 0,
    },
    this.commentCount = 0,
    required this.createdAt,
    this.viewCount = 0,
  });

  // Convert Firestore Doc to PostModel
  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      postId: id,
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? 'Anonymous Student',
      universityName: map['universityName'] ?? '',
      isAnonymous: map['isAnonymous'] ?? true,
      content: map['content'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      reactionCounts: Map<String, int>.from(map['reactionCounts'] ?? {}),
      commentCount: map['commentCount'] ?? 0,
      viewCount: map['viewCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert PostModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'universityName': universityName,
      'isAnonymous': isAnonymous,
      'content': content,
      'tags': tags,
      'createdAt': FieldValue.serverTimestamp(), // Use server time for accuracy
    };
  }
}