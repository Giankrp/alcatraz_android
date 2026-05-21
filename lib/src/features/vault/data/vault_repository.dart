import 'package:dio/dio.dart';
import '../domain/models/vault_models.dart';
import '../../../core/network/api_client.dart';
import '../../../core/crypto/crypto_service.dart';

class VaultRepository {
  final ApiClient _apiClient;
  final CryptoService _cryptoService;

  VaultRepository(this._apiClient, this._cryptoService);

  String _getIconForType(String type) {
    switch (type) {
      case 'password':
        return 'i-heroicons-key';
      case 'note':
        return 'i-heroicons-document-text';
      case 'card':
        return 'i-heroicons-credit-card';
      case 'identity':
        return 'i-heroicons-user-circle';
      default:
        return 'i-heroicons-question-mark-circle';
    }
  }

  Future<List<VaultItem>> getItems() async {
    try {
      final response = await _apiClient.dio.get('/api/vault/items');
      final List itemsJson = response.data;

      return itemsJson.map((json) => VaultItem.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Error al obtener ítems: ${e.message}');
    }
  }

  Future<VaultItem> getItemDetails(String id, String masterKey) async {
    try {
      final response = await _apiClient.dio.get('/api/vault/items/$id');
      final item = VaultItem.fromJson(response.data);
      
      final decryptedContent = await decryptItemContent(item, masterKey);
      return item.copyWith(decryptedContent: decryptedContent);
    } on DioException catch (e) {
      throw Exception('Error al obtener detalles: ${e.message}');
    }
  }

  Future<DecryptedVaultContent> decryptItemContent(
    VaultItem item,
    String masterKey,
  ) async {
    try {
      final decryptedMap = await _cryptoService.decryptData(
        item.secret.data,
        item.secret.iv,
        masterKey,
      );
      return DecryptedVaultContent.fromJson(decryptedMap);
    } catch (e) {
      throw Exception('Error al descifrar contenido: $e');
    }
  }

  Future<void> createItem(
    String title,
    String type,
    DecryptedVaultContent content,
    String masterKey,
  ) async {
    final encryptedData = await _cryptoService.encryptData(
      content.toJson(),
      masterKey,
    );

    final String icon = _getIconForType(type);

    final data = {
      'title': title,
      'type': type,
      'icon': icon,
      'secret': {
        'data': encryptedData['encrypted_data'],
        'iv': encryptedData['iv'],
        'salt': encryptedData['salt'],
      },
    };

    try {
      await _apiClient.dio.post('/api/vault/items', data: data);
    } on DioException catch (e) {
      throw Exception('Error al crear ítem: ${e.message}');
    }
  }

  Future<void> updateItem(
    String id,
    String title,
    String type,
    DecryptedVaultContent content,
    String masterKey,
  ) async {
    final encryptedData = await _cryptoService.encryptData(
      content.toJson(),
      masterKey,
    );

    final String icon = _getIconForType(type);

    final data = {
      'title': title,
      'type': type,
      'icon': icon,
      'secret': {
        'data': encryptedData['encrypted_data'],
        'iv': encryptedData['iv'],
        'salt': encryptedData['salt'],
      },
    };

    try {
      await _apiClient.dio.put('/api/vault/items/$id', data: data);
    } on DioException catch (e) {
      throw Exception('Error al actualizar ítem: ${e.message}');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _apiClient.dio.delete('/api/vault/items/$id');
    } on DioException catch (e) {
      throw Exception('Error al eliminar ítem: ${e.message}');
    }
  }
}
