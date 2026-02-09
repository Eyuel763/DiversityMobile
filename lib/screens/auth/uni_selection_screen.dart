import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';

class UniSelectionScreen extends ConsumerStatefulWidget {
  final User firebaseUser; // Passed from the login screen
  const UniSelectionScreen({super.key, required this.firebaseUser});

  @override
  ConsumerState<UniSelectionScreen> createState() => _UniSelectionScreenState();
}

class _UniSelectionScreenState extends ConsumerState<UniSelectionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedUni = "";
  bool _isLoading = false;

  final List<String> _universityOptions = [
    "Addis Ababa University",
    "Addis Ababa Science and Technology University",
    "Jimma University",
    "Haramaya University",
    "Axum University",
    "Mekelle University",
    "Other",
  ];

  Future<void> _completeProfile() async {
    if (_selectedUni.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a university")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newUser = UserModel(
        uid: widget.firebaseUser.uid,
        fullName: widget.firebaseUser.displayName ?? "Student",
        email: widget.firebaseUser.email ?? "",
        universityName: _selectedUni,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uid)
          .set(newUser.toMap());

      // Update State
      ref.read(userProvider.notifier).state = newUser;
      
      // The app will automatically navigate to Home via the Auth Wrapper 
      
    } catch (e) {
      // Tell the user why it failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection Error: ${e.toString()}")),
      );
    } finally {
      // Stop loading regardless of success or failure
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("One Last Step")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Which university do you attend?", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return _universityOptions.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _selectedUni = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: "Search University",
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
            const Spacer(),
            SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _completeProfile, // Disable button if loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Create My Account", style: TextStyle(fontSize: 18)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}