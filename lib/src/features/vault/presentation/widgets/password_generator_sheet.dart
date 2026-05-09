import 'dart:math';
import 'package:flutter/material.dart';

class PasswordGeneratorSheet extends StatefulWidget {
  final Function(String) onPasswordGenerated;

  const PasswordGeneratorSheet({super.key, required this.onPasswordGenerated});

  @override
  State<PasswordGeneratorSheet> createState() => _PasswordGeneratorSheetState();
}

class _PasswordGeneratorSheetState extends State<PasswordGeneratorSheet> {
  double _length = 16;
  bool _useUppercase = true;
  bool _useLowercase = true;
  bool _useNumbers = true;
  bool _useSymbols = true;
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (_useUppercase) chars += uppercase;
    if (_useLowercase) chars += lowercase;
    if (_useNumbers) chars += numbers;
    if (_useSymbols) chars += symbols;

    if (chars.isEmpty) {
      // Fallback si desmarca todo
      chars = lowercase;
      setState(() => _useLowercase = true);
    }

    final random = Random.secure();
    String password = '';
    for (int i = 0; i < _length.toInt(); i++) {
      password += chars[random.nextInt(chars.length)];
    }

    setState(() {
      _generatedPassword = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Generar Contraseña',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Display Password
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _generatedPassword,
                    style: const TextStyle(
                      color: Color(0xFF00E676),
                      fontSize: 18,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                  onPressed: _generatePassword,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Length Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Longitud', style: TextStyle(color: Colors.grey)),
              Text(
                '${_length.toInt()}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Slider(
            value: _length,
            min: 8,
            max: 64,
            activeColor: const Color(0xFF00E676),
            inactiveColor: Colors.grey.withValues(alpha: 0.3),
            onChanged: (val) {
              setState(() => _length = val);
              _generatePassword();
            },
          ),

          // Options
          _buildSwitch('Mayúsculas (A-Z)', _useUppercase, (val) {
            setState(() => _useUppercase = val);
            _generatePassword();
          }),
          _buildSwitch('Minúsculas (a-z)', _useLowercase, (val) {
            setState(() => _useLowercase = val);
            _generatePassword();
          }),
          _buildSwitch('Números (0-9)', _useNumbers, (val) {
            setState(() => _useNumbers = val);
            _generatePassword();
          }),
          _buildSwitch('Símbolos (!@#\$)', _useSymbols, (val) {
            setState(() => _useSymbols = val);
            _generatePassword();
          }),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onPasswordGenerated(_generatedPassword);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Usar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      value: value,
      activeTrackColor: const Color(0xFF00E676).withValues(alpha: 0.5),
      activeThumbColor: const Color(0xFF00E676),
      contentPadding: EdgeInsets.zero,
      onChanged: onChanged,
    );
  }
}
