import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alcatraz_android/src/features/auth/presentation/widgets/animated_bubbles_background.dart';
import 'package:alcatraz_android/src/features/vault/presentation/screens/vault_screen.dart';
import 'package:alcatraz_android/src/features/auth/presentation/screens/register_screen.dart';
import 'package:alcatraz_android/src/features/auth/presentation/providers/auth_provider.dart';

/// LoginScreen: Application login screen.
/// Main entry point for unauthenticated users.
/// Offers email/password login and (simulated) social options.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Form key to handle validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Password visibility state.
  bool _isPasswordVisible = false;

  // "Remember credentials" checkbox state.
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      final authState = ref.read(authProvider);
      if (authState.session != null && mounted) {
        // Navigates to Vault if login is successful.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VaultScreen()),
        );
      } else if (authState.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Pure black background.
      body: Stack(
        children: [
          // ----------------------------------------------------------------
          // LAYER 1: Radial Gradient Background
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

          // ----------------------------------------------------------------
          // LAYER 2: Bubble Animation
          const Positioned.fill(child: AnimatedBubblesBackground()),

          // ----------------------------------------------------------------
          // LAYER 3: Form Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // Logo/Lock Icon with Glassmorphism effect
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

                      // Welcome Title
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

                      // ----------------------------------------------------------------
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
                        iconWidget: const Icon(
                          FontAwesomeIcons.github,
                          size: 20,
                        ),
                        label: 'GitHub',
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

                      // ----------------------------------------------------------------
                      // Field: Email
                      const Text(
                        'Email *',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'gian@correo.com',
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
                          if (value == null || value.isEmpty) {
                            return "Ingrese su email";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "Ingrese un email válido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // ----------------------------------------------------------------
                      // Field: Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Contraseña *',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
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
                          if (value == null || value.isEmpty) {
                            return "Ingrese su contraseña";
                          }
                          if (value.length < 8) {
                            return "La contraseña debe tener al menos 8 caracteres";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // ----------------------------------------------------------------
                      // Login Button
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Row(
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

                      // ----------------------------------------------------------------
                      // Link to Registration
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes cuenta? ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
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
