import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../confessions/confession_feed.dart';
import '../confessions/post_compose_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return DefaultTabController(
      length: 2, // Two tabs: My Campus and Global
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Diversity Wall", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: false,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "My Campus"),
              Tab(text: "Global"),
            ],
          ),
        ),
      body: TabBarView(
          children: [
            // Tab 1: Filtered by user's university
            ConfessionFeed(universityFilter: user?.universityName),
            
            // Tab 2: No filter (shows everything)
            const ConfessionFeed(universityFilter: null),
          ],
        ),
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
      ),
    );
  }
}