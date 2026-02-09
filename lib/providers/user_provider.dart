import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// This is the global "box" that holds the user data
final userProvider = StateProvider<UserModel?>((ref) => null);