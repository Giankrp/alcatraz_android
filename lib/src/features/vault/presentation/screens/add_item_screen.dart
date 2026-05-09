import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vault_provider.dart';
import '../../domain/models/vault_models.dart';
import '../widgets/password_generator_sheet.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  final VaultItem? existingItem;

  const AddItemScreen({super.key, this.existingItem});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedType = 'password';
  bool _isPasswordVisible = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _titleController.text = item.title;
      _selectedType = ['password', 'card', 'note'].contains(item.type) ? item.type : 'password';
      
      final content = item.decryptedContent;
      if (content != null) {
        _usernameController.text = content.username;
        _passwordController.text = content.password;
        _urlController.text = content.url;
        _notesController.text = content.notes;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showPasswordGenerator() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PasswordGeneratorSheet(
        onPasswordGenerated: (password) {
          setState(() {
            _passwordController.text = password;
          });
        },
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final content = DecryptedVaultContent(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      url: _urlController.text.trim(),
      notes: _notesController.text.trim(),
    );

    if (widget.existingItem != null) {
      await ref.read(vaultProvider.notifier).updateItem(
        widget.existingItem!.id!,
        _titleController.text.trim(),
        _selectedType,
        content,
      );
    } else {
      await ref.read(vaultProvider.notifier).addItem(
        _titleController.text.trim(),
        _selectedType,
        content,
      );
    }

    if (mounted) {
      final state = ref.read(vaultProvider);
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() => _isSaving = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ítem guardado en tu bóveda.'),
            backgroundColor: Color(0xFF00E676),
          ),
        );
        Navigator.pop(context); // Volver a la bóveda
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingItem != null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(isEditing ? 'Editar Ítem' : 'Nuevo Ítem', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Type Selector
                DropdownButtonFormField<String>(
                  initialValue: _selectedType, // DropdownButtonFormField doesn't strictly deprecate 'value' unless you use initialValue, but I'll stick to value + onChanged as it's the standard for controlled dropdowns
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Tipo de Ítem', Icons.category),
                  items: const [
                    DropdownMenuItem(value: 'password', child: Text('Contraseña / Login')),
                    DropdownMenuItem(value: 'card', child: Text('Tarjeta de Crédito')),
                    DropdownMenuItem(value: 'note', child: Text('Nota Segura')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _selectedType = value);
                  },
                ),
                const SizedBox(height: 16),
                
                // Title
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Título (Ej. Google, Netflix)', Icons.title),
                  validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),

                // Username / Email
                if (_selectedType == 'password' || _selectedType == 'card')
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(_selectedType == 'password' ? 'Usuario / Email' : 'Nombre en Tarjeta', Icons.person),
                  ),
                if (_selectedType == 'password' || _selectedType == 'card')
                  const SizedBox(height: 16),

                // Password
                if (_selectedType == 'password' || _selectedType == 'card')
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(_selectedType == 'password' ? 'Contraseña' : 'Número de Tarjeta', Icons.lock).copyWith(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.auto_awesome, color: Color(0xFF00E676)),
                            onPressed: _showPasswordGenerator,
                            tooltip: 'Generar',
                          ),
                          IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_selectedType == 'password' || _selectedType == 'card')
                  const SizedBox(height: 16),

                // URL
                if (_selectedType == 'password')
                  TextFormField(
                    controller: _urlController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('URL / Sitio web', Icons.link),
                  ),
                if (_selectedType == 'password')
                  const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: _inputDecoration('Notas seguras...', Icons.notes),
                ),
                const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Actualizar Ítem' : 'Guardar Ítem', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }
}
