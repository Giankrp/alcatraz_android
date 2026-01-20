import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alcatraz_android/src/features/auth/presentation/widgets/animated_bubbles_background.dart';
import 'package:alcatraz_android/src/features/vault/presentation/screens/vault_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.5),
                radius: 1.2,
                colors: [Color(0xFF2A2A2A), Color(0xFF0D0D0D)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Animated Bubbles
          const Positioned.fill(child: AnimatedBubblesBackground()),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    // Lock Icon with Glass Effect
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    const Text(
                      'Inicia sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    const Text(
                      'Bienvenido de vuelta. Protegemos tus\ndatos con máxima seguridad.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Social Login Buttons
                    _buildSocialButton(
                      iconWidget: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png',
                        height: 20,
                        width: 20,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(FontAwesomeIcons.google, size: 20),
                      ),
                      label: 'Google',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildSocialButton(
                      iconWidget: const Icon(FontAwesomeIcons.github, size: 20),
                      label: 'GitHub',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildSocialButton(
                      iconWidget: const Icon(FontAwesomeIcons.apple, size: 20),
                      label: 'Apple',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 32),
                    // Divider
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'O CONTINÚA CON',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Email Input
                    const Text(
                      'Email *',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'tu@correo.com',
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value != null && !EmailValidator.validate(value)) {
                          return "Ingrese un email valido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password Input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Contraseña *',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Forgot password logic
                          },
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '........',
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.length < 8) {
                          return "La contraseña debe tener al menos 8 caracteres";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Remember Me Checkbox
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            fillColor: WidgetStateProperty.resolveWith(
                              (states) => Colors.transparent,
                            ),
                            side: const BorderSide(color: Colors.grey),
                            checkColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Recordar credenciales',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VaultScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Acceder',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Regístrate',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required Widget iconWidget,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [iconWidget, const SizedBox(width: 12), Text(label)],
        ),
      ),
    );
  }
}
