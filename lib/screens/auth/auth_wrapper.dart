import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';
import 'uni_selection_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userModel = ref.watch(userProvider);
    final AuthService authService = AuthService();

    return authState.when(
      data: (firebaseUser) {
        if (firebaseUser == null) {
          return const LoginScreen();
        }

        // If we have a Firebase user but no local UserModel yet, try to fetch it
        if (userModel == null) {
          return FutureBuilder(
            future: authService.getUserData(firebaseUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              
              if (snapshot.hasData && snapshot.data != null) {
                // User exists in Firestore! Update provider and go to Home
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(userProvider.notifier).state = snapshot.data;
                });
                return const HomeScreen(); 
              } else {
                // New user! Go to Uni Selection
                return UniSelectionScreen(firebaseUser: firebaseUser);
              }
            },
          );
        }

        // User is fully logged in and has a profile
        return const HomeScreen();
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, stack) => Scaffold(body: Center(child: Text("Error: $e"))),
    );
  }
}