import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'uni_selection_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService _auth = AuthService();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.deepPurple.shade800, Colors.deepPurple.shade400],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Icon(Icons.Diversity_3, size: 100, color: Colors.white),  // Comment for latter use when we have a custom logo
            const SizedBox(height: 20),
            const Text(
              "DIVERSITY",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Connect with your campus anonymously",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: Image.asset(
                'assets/icons/google.png',
                height: 24,
              ), 
              label: const Text("Continue with Google"),
              onPressed: () async {
                final user = await _auth.signInWithGoogle();
                if (user != null) {
                  final userModel = await _auth.getUserData(user.uid);

                  if (userModel == null) {
                    // Move to University Selection Screen
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => UniSelectionScreen(firebaseUser: user)),
                      );
                    }
                  } else {
                    // Existing user found! Save them to our global provider.
                    ref.read(userProvider.notifier).state = userModel;
                    // Navigate to Home
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
