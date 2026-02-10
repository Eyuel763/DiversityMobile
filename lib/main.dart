import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/auth_wrapper.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DiversityApp(),
    ),
  );
}

class DiversityApp extends StatelessWidget {
  const DiversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'Diversity',
  theme: ThemeData(
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
    ),
  ),
  home: const AuthWrapper(), 
);
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Diversity App Skeleton Ready!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}