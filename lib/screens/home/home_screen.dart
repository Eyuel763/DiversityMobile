import 'package:flutter/material.dart';
import '../confessions/post_compose_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Diversity Wall")),
      body: const Center(child: Text("Feed will appear here")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allows sheet to expand with keyboard
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const PostComposeSheet(),
          );
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}