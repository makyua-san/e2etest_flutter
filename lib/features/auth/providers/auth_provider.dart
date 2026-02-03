import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String? username;
  final String? error;

  const AuthState({
    this.isLoggedIn = false,
    this.username,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? username,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      username: username ?? this.username,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simple validation: any non-empty username/password
    if (username.isEmpty || password.isEmpty) {
      state = state.copyWith(
        error: 'Username and password are required',
      );
      return false;
    }

    // Demo: accept any credentials
    state = AuthState(
      isLoggedIn: true,
      username: username,
    );
    return true;
  }

  void logout() {
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
