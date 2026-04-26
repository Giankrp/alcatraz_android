import 'dart:math';

import 'package:dio/dio.dart';
import '../domain/models/auth_models.dart';
import '../../../core/network/api_client.dart';
import '../../../core/crypto/crypto_service.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final CryptoService _cryptoService;

  AuthRepository(this._apiClient, this._cryptoService);

  Future<LoginResponse> login(String email, String password) async {
    // 1. Hash deterministic for Login
    final authHash = await _cryptoService.hashMasterPassword(password, email);

    try {
      final response = await _apiClient.dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': authHash},
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Credenciales inválidas');
      }
      throw Exception('Error al iniciar sesión: ${e.message}');
    }
  }

  Future<void> register(String email, String password) async {
    // 1. Hash deterministic for Login
    final authHash = await _cryptoService.hashMasterPassword(password, email);

    // 2. Generate random Master Key
    final masterKey = _cryptoService.generateMasterKey();

    // 3. Encrypt Master Key with user's password
    final protectedKeyData = await _cryptoService.encryptMasterKey(
      masterKey,
      password,
    );

    // 4. Generate and encrypt with Recovery Key
    // Note: Replicating web logic where Recovery Key is just another "protector"
    final recoveryKey = _generateRecoveryKey();
    final recoveryProtectedKeyData = await _cryptoService.encryptMasterKey(
      masterKey,
      recoveryKey,
    );

    final request = RegisterRequest(
      email: email,
      password: authHash,
      protectedMasterKey: protectedKeyData['protected_master_key']!,
      masterKeyIv: protectedKeyData['master_key_iv']!,
      masterKeySalt: protectedKeyData['master_key_salt']!,
      recoveryKey: recoveryKey,
      recoveryProtectedMasterKey:
          recoveryProtectedKeyData['protected_master_key']!,
      recoveryKeyIv: recoveryProtectedKeyData['master_key_iv']!,
      recoveryKeySalt: recoveryProtectedKeyData['master_key_salt']!,
    );

    try {
      await _apiClient.dio.post('/api/auth/register', data: request.toJson());
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('El email ya está registrado');
      }
      throw Exception('Error al registrarse: ${e.message}');
    }
  }

  String _generateRecoveryKey() {
    // Replicating web logic: RK-XXXX-XXXX-XXXX-XXXX
    final random = Random.secure();
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Avoid ambiguous chars

    String gen(int len) =>
        List.generate(len, (_) => chars[random.nextInt(chars.length)]).join();

    return 'RK-${gen(4)}-${gen(4)}-${gen(4)}-${gen(4)}';
  }
}
