import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String universityName;
  final String profileImageUrl;
  final List<String> joinedGroups;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.universityName,
    this.profileImageUrl = '',
    this.joinedGroups = const [],
    required this.createdAt,
  });

  // Convert Firestore Document to UserModel object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      universityName: map['universityName'] ?? 'General Student',
      profileImageUrl: map['profileImageUrl'] ?? '',
      joinedGroups: List<String>.from(map['joinedGroups'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert UserModel object back to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'universityName': universityName,
      'profileImageUrl': profileImageUrl,
      'joinedGroups': joinedGroups,
      'createdAt': createdAt,
    };
  }
}