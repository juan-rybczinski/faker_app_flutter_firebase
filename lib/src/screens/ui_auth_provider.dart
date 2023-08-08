import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProviderListProvider = Provider<List<AuthProvider>>((ref) {
  return [EmailAuthProvider()];
});
