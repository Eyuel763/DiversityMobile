import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/post_model.dart';
import '../providers/user_provider.dart';
import '../services/post_service.dart';

class ConfessionCard extends ConsumerWidget {
  final PostModel post;
  const ConfessionCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  backgroundColor: post.isAnonymous
                      ? Colors.grey[300]
                      : Colors.deepPurple[100],
                  child: Icon(
                    post.isAnonymous ? Icons.face : Icons.person,
                    color: post.isAnonymous
                        ? Colors.grey[600]
                        : Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.isAnonymous
                            ? "Anonymous Student"
                            : post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${post.universityName} • ${DateFormat.jm().format(post.createdAt)}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        softWrap: true,
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
                children: post.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "#$tag",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

            const Divider(height: 24),

            // Reactions Row (Now interactive)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReaction(
                  ref,
                  Icons.favorite_border,
                  Icons.favorite,
                  "relatable",
                  post.reactionCounts['relatable'] ?? 0,
                ),
                _buildReaction(
                  ref,
                  Icons.volunteer_activism_outlined,
                  Icons.volunteer_activism,
                  "support",
                  post.reactionCounts['support'] ?? 0,
                ),
                _buildReaction(
                  ref,
                  Icons.sentiment_very_satisfied_outlined,
                  Icons.sentiment_very_satisfied,
                  "laugh",
                  post.reactionCounts['laugh'] ?? 0,
                ),
                _buildReaction(
                  ref,
                  Icons.lightbulb_outline,
                  Icons.lightbulb,
                  "thoughtProvoking",
                  post.reactionCounts['thoughtProvoking'] ?? 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReaction(
    WidgetRef ref,
    IconData inactiveIcon, // Outline version
    IconData activeIcon, // Filled version
    String type,
    int count,
  ) {
    final user = ref.watch(userProvider);
    if (user == null) return const SizedBox();

    return StreamBuilder<String?>(
      stream: PostService().getUserReaction(post.postId, user.uid),
      builder: (context, snapshot) {
        final activeReactionType = snapshot.data;
        final isSelected = activeReactionType == type;

        return InkWell(
          onTap: () async {
            await PostService().toggleReaction(
              postId: post.postId,
              userId: user.uid,
              reactionType: type,
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                Icon(
                  // SWAP THE ICON HERE
                  isSelected ? activeIcon : inactiveIcon,
                  size: 22, // Slightly larger to feel more like a "button"
                  color: isSelected ? Colors.black : Colors.grey[600],
                ),
                const SizedBox(height: 2),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
