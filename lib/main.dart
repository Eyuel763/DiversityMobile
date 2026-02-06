import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE), // Primary brand color
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const PlaceholderScreen(), 
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