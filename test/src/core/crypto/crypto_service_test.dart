import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:alcatraz_android/src/core/crypto/crypto_service.dart';

void main() {
  late CryptoService cryptoService;

  setUp(() {
    cryptoService = CryptoService();
  });

  group('CryptoService Tests', () {
    const testPassword = 'Password123!';
    const testEmail = 'test@example.com';

    test('hashMasterPassword should return consistent hash', () async {
      final hash1 = await cryptoService.hashMasterPassword(
        testPassword,
        testEmail,
      );
      final hash2 = await cryptoService.hashMasterPassword(
        testPassword,
        testEmail,
      );

      expect(hash1, isNotEmpty);
      expect(hash1.length, 64); // Hex string of 32 bytes
      expect(hash1, equals(hash2));
    });

    test('generateMasterKey should return a valid base64 string', () {
      final masterKey = cryptoService.generateMasterKey();
      expect(masterKey, isNotEmpty);

      // Verify it's valid base64 and has 32 bytes (256 bits)
      final decoded = base64.decode(masterKey);
      expect(decoded.length, 32);
    });

    test('Master Key Encryption/Decryption Cycle', () async {
      final originalMasterKey = cryptoService.generateMasterKey();

      final encryptedResults = await cryptoService.encryptMasterKey(
        originalMasterKey,
        testPassword,
      );

      expect(encryptedResults.containsKey('protected_master_key'), true);
      expect(encryptedResults.containsKey('master_key_iv'), true);
      expect(encryptedResults.containsKey('master_key_salt'), true);

      final decryptedMasterKey = await cryptoService.decryptMasterKey(
        encryptedResults['protected_master_key']!,
        testPassword,
        encryptedResults['master_key_salt']!,
        encryptedResults['master_key_iv']!,
      );

      expect(decryptedMasterKey, equals(originalMasterKey));
    });

    test('Data Encryption/Decryption Cycle', () async {
      final masterKey = cryptoService.generateMasterKey();
      final testData = {
        'username': 'admin',
        'password': 'secret_password_456',
        'url': 'https://example.com',
        'notes': 'Some private notes.',
      };

      final encryptedData = await cryptoService.encryptData(
        testData,
        masterKey,
      );

      expect(encryptedData.containsKey('encrypted_data'), true);
      expect(encryptedData.containsKey('iv'), true);

      final decryptedData = await cryptoService.decryptData(
        encryptedData['encrypted_data']!,
        encryptedData['iv']!,
        masterKey,
      );

      expect(decryptedData['username'], equals(testData['username']));
      expect(decryptedData['password'], equals(testData['password']));
      expect(decryptedData['url'], equals(testData['url']));
      expect(decryptedData['notes'], equals(testData['notes']));
    });
  });
}
