import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_scheduler/utils/constants.dart';

/// 🔹 Auth state stream provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return supabase.auth.onAuthStateChange;
});

class AuthRepository {
  /// -----------------------------
  /// Email + Password Sign In
  /// -----------------------------
  Future<void> signInEmail({
    required String email,
    required String password,
  }) async {
    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (res.session == null) {
      throw Exception('Email sign-in failed');
    }
  }

  /// -----------------------------
  /// Email + Password Sign Up
  /// -----------------------------
  Future<void> signUpEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    if (res.user == null) {
      throw Exception('Sign-up failed');
    }
  }

  /// -----------------------------
  /// Google Sign-In (v7.x API)
  /// -----------------------------
  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn.instance.authenticate();

    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('Google sign-in failed: Missing ID token');
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
  }

Future<String> getBranchIdByCode(String branchCode) async {
  final res = await supabase
      .from('branches')
      .select('id')
      .eq('code', branchCode)
      .single();

  return res['id'] as String;
}

  /// -----------------------------
  /// Update / Insert Profile
  /// -----------------------------
  Future<void> updateProfile({
    required String branchId,
    required String section,
    required String subsection,
    required String phone,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await supabase.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'full_name': (user.userMetadata?['full_name'] ?? '').toString(),
      'branch_id': branchId,
      'section': section,
      'subsection': subsection,
      'avatar_url': user.userMetadata?['avatar_url'],
      'phone': phone,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// -----------------------------
  /// Sign Out
  /// -----------------------------
  Future<void> signOut() async {
    await supabase.auth.signOut();
    await GoogleSignIn.instance.signOut();
  }

  /// -----------------------------
  /// Helpers
  /// -----------------------------
  User? get currentUser => supabase.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
}

/// 🔹 Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});