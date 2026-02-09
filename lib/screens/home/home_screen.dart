import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This listens to the userProvider we set in the Login/Onboarding screens
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("DIVERSITY"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Clear the provider and go back to login
              ref.read(userProvider.notifier).state = null;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.deepPurple.shade100,
              child: const Icon(Icons.person, size: 50, color: Colors.deepPurple),
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome, ${user?.fullName ?? 'Student'}!",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user?.universityName ?? "No University Joined",
                style: TextStyle(color: Colors.deepPurple.shade700, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Your campus wall is coming soon...",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}