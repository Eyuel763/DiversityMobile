import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post_model.dart';

class ConfessionCard extends StatelessWidget {
  final PostModel post;
  const ConfessionCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Author & University
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: post.isAnonymous ? Colors.grey[300] : Colors.deepPurple[100],
                  child: Icon(
                    post.isAnonymous ? Icons.face : Icons.person,
                    color: post.isAnonymous ? Colors.grey[600] : Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.isAnonymous ? "Anonymous Student" : post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${post.universityName} • ${DateFormat.jm().format(post.createdAt)}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Content
            Text(
              post.content,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 12),

            // Tags
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                children: post.tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("#$tag", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                )).toList(),
              ),
            
            const Divider(height: 24),

            // Reactions Row (The 4 Types from SRS)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReaction(Icons.favorite_border, "Relatable", post.reactionCounts['relatable'] ?? 0),
                _buildReaction(Icons.volunteer_activism_outlined, "Support", post.reactionCounts['support'] ?? 0),
                _buildReaction(Icons.sentiment_very_satisfied, "Laugh", post.reactionCounts['laugh'] ?? 0),
                _buildReaction(Icons.lightbulb_outline, "Thought", post.reactionCounts['thoughtProvoking'] ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReaction(IconData icon, String label, int count) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(height: 2),
        Text(count.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}