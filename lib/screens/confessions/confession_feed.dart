import 'package:flutter/material.dart';
import '../../services/post_service.dart';
import '../../models/post_model.dart';
import '../../widgets/confession_card.dart';

class ConfessionFeed extends StatelessWidget {
  final String? universityFilter;
  const ConfessionFeed({super.key, this.universityFilter});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostModel>>(
      stream: PostService().getPosts(universityFilter: universityFilter),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong: ${snapshot.error}"));
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  universityFilter == null 
                    ? "No confessions yet. Be the first!" 
                    : "No confessions from $universityFilter yet.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80), // bottom padding for FAB
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return ConfessionCard(post: posts[index]);
          },
        );
      },
    );
  }
}