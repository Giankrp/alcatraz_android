import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/crypto/crypto_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/user_session.dart';
import '../../data/auth_repository.dart';

// Core Providers
final cryptoServiceProvider = Provider((ref) => CryptoService());

final apiClientProvider = Provider((ref) {
  final client = ApiClient();
  // Note: client.init() should be called at app startup
  return client;
});

// Repository Providers
final authRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cryptoService = ref.watch(cryptoServiceProvider);
  return AuthRepository(apiClient, cryptoService);
});

// State Notifier
class AuthState {
  final UserSession? session;
  final bool isLoading;
  final String? error;

  AuthState({this.session, this.isLoading = false, this.error});

  AuthState copyWith({UserSession? session, bool? isLoading, String? error}) {
    return AuthState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final CryptoService _cryptoService;

  AuthNotifier(this._repository, this._cryptoService) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.login(email, password);

      if (response.require2fa) {
        state = state.copyWith(
          isLoading: false,
          error: '2FA requerido (no implementado en MVP)',
        );
        return;
      }

      final masterKey = await _cryptoService.decryptMasterKey(
        response.protectedMasterKey!,
        password,
        response.masterKeySalt!,
        response.masterKeyIv!,
      );

      final session = UserSession(
        email: email,
        masterKey: masterKey,
        token: response.token,
      );

      state = state.copyWith(session: session, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.register(email, password);
      // After registration, we usually redirect to login or login automatically.
      // For simplicity, we'll just set isLoading to false and let the UI handle navigation.
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final account = await _repository.signInWithGoogle();
      
      if (account == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      // Since there's no backend for social login yet, 
      // we'll create a simulated session with the Google email.
      // In a production app, we would send the idToken to the backend
      // and get the encrypted master key.
      final session = UserSession(
        email: account.email,
        masterKey: 'google_session_mock_key',
        token: 'google_token_${account.id}',
      );

      state = state.copyWith(session: session, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error con Google: $e');
    }
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final cryptoService = ref.watch(cryptoServiceProvider);
  return AuthNotifier(repository, cryptoService);
});
