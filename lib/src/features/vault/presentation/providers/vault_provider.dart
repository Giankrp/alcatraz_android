import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/vault_models.dart';
import '../../data/vault_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final vaultRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cryptoService = ref.watch(cryptoServiceProvider);
  return VaultRepository(apiClient, cryptoService);
});

class VaultState {
  final List<VaultItem> items;
  final bool isLoading;

  final String? error;

  VaultState({this.items = const [], this.isLoading = false, this.error});

  VaultState copyWith({
    List<VaultItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return VaultState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class VaultNotifier extends StateNotifier<VaultState> {
  final VaultRepository _repository;
  final Ref _ref;

  VaultNotifier(this._repository, this._ref) : super(VaultState());

  Future<void> fetchItems() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _repository.getItems();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<VaultItem?> loadItemDetails(String id) async {
    final session = _ref.read(authProvider).session;
    if (session == null) return null;

    try {
      return await _repository.getItemDetails(id, session.masterKey);
    } catch (e) {
      state = state.copyWith(error: 'Error al cargar detalles: $e');
      return null;
    }
  }

  Future<void> addItem(
    String title,
    String type,
    DecryptedVaultContent content,
  ) async {
    final session = _ref.read(authProvider).session;
    if (session == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.createItem(title, type, content, session.masterKey);
      await fetchItems(); // Refresh
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateItem(
    String id,
    String title,
    String type,
    DecryptedVaultContent content,
  ) async {
    final session = _ref.read(authProvider).session;
    if (session == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateItem(id, title, type, content, session.masterKey);
      await fetchItems(); // Refresh
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteItem(String id) async {
    final session = _ref.read(authProvider).session;
    if (session == null) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteItem(id);
      await fetchItems(); // Refresh
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final vaultProvider = StateNotifierProvider<VaultNotifier, VaultState>((ref) {
  final repository = ref.watch(vaultRepositoryProvider);
  return VaultNotifier(repository, ref);
});
