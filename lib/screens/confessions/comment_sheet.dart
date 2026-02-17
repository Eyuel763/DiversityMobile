import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/comment_model.dart';
import '../../providers/user_provider.dart';
import '../../services/comment_service.dart';

class CommentSheet extends ConsumerStatefulWidget {
  final String postId;
  const CommentSheet({super.key, required this.postId});

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();
  bool _isAnonymous = true;

  void _postComment() async {
    final user = ref.read(userProvider);
    if (user == null || _commentController.text.trim().isEmpty) return;

    final comment = CommentModel(
      commentId: '',
      authorId: user.uid,
      authorName: user.fullName,
      content: _commentController.text.trim(),
      isAnonymous: _isAnonymous,
      createdAt: DateTime.now(),
    );

    await CommentService().addComment(widget.postId, comment);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const Divider(),
          // List of comments
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: CommentService().getComments(widget.postId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final comments = snapshot.data!;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    return ListTile(
                      title: Text(c.isAnonymous ? "Anonymous" : c.authorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text(c.content),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_border, size: 20),
                        onPressed: () { /* Comment like logic */ },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Input section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(hintText: "Add a comment...", border: InputBorder.none),
                  ),
                ),
                Column(
                  children: [
                    const Text("Anon", style: TextStyle(fontSize: 10)),
                    Switch(
                      value: _isAnonymous,
                      onChanged: (val) => setState(() => _isAnonymous = val),
                    ),
                  ],
                ),
                IconButton(onPressed: _postComment, icon: const Icon(Icons.send, color: Colors.deepPurple)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}