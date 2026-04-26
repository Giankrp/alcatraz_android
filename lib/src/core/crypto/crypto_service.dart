import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class CryptoService {
  // Argon2id parameters matching Web and Go
  static const int _iterations = 3;
  static const int _memory = 64 * 1024; // 64 MB
  static const int _parallelism = 2;

  final _aesGcm = AesGcm.with256bits();
  final _random = Random.secure();

  /// Derives an authentication hash from the master password and email.
  Future<String> hashMasterPassword(String password, String email) async {
    final salt = utf8.encode(email.toLowerCase().trim());

    final argon2id = Argon2id(
      parallelism: _parallelism,
      memory: _memory,
      iterations: _iterations,
      hashLength: 32,
    );

    final secretKey = await argon2id.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );

    final bytes = await secretKey.extractBytes();
    return _bufferToHex(Uint8List.fromList(bytes));
  }

  /// Derives a Key Encryption Key (KEK) from the master password and a salt.
  Future<SecretKey> deriveKEK(String password, Uint8List salt) async {
    final argon2id = Argon2id(
      parallelism: _parallelism,
      memory: _memory,
      iterations: _iterations,
      hashLength: 32,
    );

    return await argon2id.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
  }

  /// Generates a random 256-bit Master Key.
  String generateMasterKey() {
    final bytes = _generateRandomBytes(32);
    return base64.encode(bytes);
  }

  /// Encrypts the Master Key with the user's password.
  Future<Map<String, String>> encryptMasterKey(
    String masterKeyBase64,
    String password,
  ) async {
    final masterKeyBytes = base64.decode(masterKeyBase64);
    final salt = _generateRandomBytes(16);
    final iv = _generateRandomBytes(12);

    final kek = await deriveKEK(password, salt);

    final secretBox = await _aesGcm.encrypt(
      masterKeyBytes,
      secretKey: kek,
      nonce: iv,
    );

    // Replicate Web Crypto behavior: ciphertext + tag
    final combined = Uint8List.fromList(
      secretBox.cipherText + secretBox.mac.bytes,
    );

    return {
      'protected_master_key': base64.encode(combined),
      'master_key_iv': base64.encode(iv),
      'master_key_salt': base64.encode(salt),
    };
  }

  /// Decrypts the Master Key using the user's password and metadata.
  Future<String> decryptMasterKey(
    String protectedKeyBase64,
    String password,
    String saltBase64,
    String ivBase64,
  ) async {
    final protectedKey = base64.decode(protectedKeyBase64);
    final salt = base64.decode(saltBase64);
    final iv = base64.decode(ivBase64);

    final kek = await deriveKEK(password, salt);

    final actualCipherText = protectedKey.sublist(0, protectedKey.length - 16);
    final macBytes = protectedKey.sublist(protectedKey.length - 16);

    final boxWithMac = SecretBox(
      actualCipherText,
      nonce: iv,
      mac: Mac(macBytes),
    );

    final decryptedBytes = await _aesGcm.decrypt(boxWithMac, secretKey: kek);

    return base64.encode(decryptedBytes);
  }

  /// Encrypts a Map using the Master Key.
  /// Returns a Map with base64 encoded strings: {encrypted_data, iv, salt}
  Future<Map<String, String>> encryptData(
    Map<String, dynamic> data,
    String masterKeyBase64,
  ) async {
    final jsonData = json.encode(data);
    final dataBytes = utf8.encode(jsonData);
    final masterKeyBytes = base64.decode(masterKeyBase64);
    final iv = _generateRandomBytes(12);

    final secretKey = SecretKey(masterKeyBytes);
    final secretBox = await _aesGcm.encrypt(
      dataBytes,
      secretKey: secretKey,
      nonce: iv,
    );

    final combined = Uint8List.fromList(
      secretBox.cipherText + secretBox.mac.bytes,
    );

    return {
      'encrypted_data': base64.encode(combined),
      'iv': base64.encode(iv),
      'salt': 'static',
    };
  }

  /// Decrypts a blob using the Master Key and returns a Map.
  Future<Map<String, dynamic>> decryptData(
    String encryptedDataB64,
    String ivB64,
    String masterKeyBase64,
  ) async {
    final encryptedData = base64.decode(encryptedDataB64);
    final iv = base64.decode(ivB64);
    final masterKeyBytes = base64.decode(masterKeyBase64);

    final actualCipherText = encryptedData.sublist(
      0,
      encryptedData.length - 16,
    );
    final macBytes = encryptedData.sublist(encryptedData.length - 16);

    final secretKey = SecretKey(masterKeyBytes);
    final secretBox = SecretBox(
      actualCipherText,
      nonce: iv,
      mac: Mac(macBytes),
    );

    final decryptedBytes = await _aesGcm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    final decodedString = utf8.decode(decryptedBytes);
    return json.decode(decodedString) as Map<String, dynamic>;
  }

  Uint8List _generateRandomBytes(int length) {
    return Uint8List.fromList(
      List.generate(length, (_) => _random.nextInt(256)),
    );
  }

  String _bufferToHex(Uint8List buffer) {
    return buffer.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
