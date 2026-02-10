import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/post_model.dart';
import '../../providers/user_provider.dart';
import '../../services/post_service.dart';

class PostComposeSheet extends ConsumerStatefulWidget {
  const PostComposeSheet({super.key});

  @override
  ConsumerState<PostComposeSheet> createState() => _PostComposeSheetState();
}

class _PostComposeSheetState extends ConsumerState<PostComposeSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isAnonymous = true;
  bool _isLoading = false;
  final List<String> _selectedTags = [];
  final List<String> _availableTags = ["Academics", "MentalHealth", "Funny", "Relationship"];

  void _submitPost() async {
    final user = ref.read(userProvider);
    if (user == null || _controller.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final newPost = PostModel(
      postId: '', 
      authorId: user.uid,
      authorName: user.fullName,
      universityName: user.universityName,
      isAnonymous: _isAnonymous,
      content: _controller.text.trim(),
      tags: _selectedTags,
      createdAt: DateTime.now(),
    );

    try {
      await PostService().uploadPost(newPost);
      if (mounted) Navigator.pop(context); // Close the overlay
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Making the sheet responsive to keyboard
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Moves sheet up when keyboard appears
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Sheet only takes as much space as needed
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              const Text("New Confession", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitPost,
                child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text("Post"),
              ),
            ],
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Post Anonymously"),
            value: _isAnonymous,
            onChanged: (val) => setState(() => _isAnonymous = val),
          ),
          TextField(
            controller: _controller,
            maxLines: 5,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "What's your secret?",
              border: InputBorder.none,
            ),
          ),
          Wrap(
            spacing: 8,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return ChoiceChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected && _selectedTags.length < 3) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}