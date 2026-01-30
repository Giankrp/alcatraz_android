import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:alcatraz_android/src/features/auth/presentation/widgets/animated_bubbles_background.dart';
import 'package:alcatraz_android/src/features/vault/presentation/screens/vault_screen.dart';

/// RegisterScreen: New user registration screen.
/// This screen allows users to create a new account in the Alcatraz application.
/// It includes fields for name, email, password, and password confirmation,
/// with real-time validation and a premium dark aesthetic.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Global key to identify the form and perform validations.
  // Allows accessing the form state from anywhere in this class.
  final _formKey = GlobalKey<FormState>();

  // State variables to control password visibility.
  // When true, text is shown; when false, it is hidden (dots/asterisks).
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Text controllers to capture and manipulate user input.
  // It is necessary to use controllers to compare passwords against each other.
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Called when the widget is removed from the widget tree.
  /// It is crucial to clean up controllers here to avoid memory leaks.
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic structure of the screen.
    return Scaffold(
      backgroundColor:
          Colors.black, // Pure black background for OLED/Dark Mode aesthetic.
      // Stack allows superimposing widgets. Used here to layer the background, bubbles, and content.
      body: Stack(
        children: [
          // -----------------------------------------------------------------------
          // LAYER 1: Radial Gradient Background
          // Provides a subtle glow in the top center to give depth.
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(
                  0.0,
                  -0.5,
                ), // The gradient center is slightly above the screen center.
                radius: 1.2, // The radius covers most of the visible screen.
                // Colors from dark gray (#2A2A2A) to near black (#0D0D0D).
                colors: [Color(0xFF2A2A2A), Color(0xFF0D0D0D)],
                stops: [0.0, 1.0], // Gradient distribution.
              ),
            ),
          ),

          // -----------------------------------------------------------------------
          // LAYER 2: Animated Background Bubbles
          // Custom widget displaying floating animated bubbles.
          // Positioned.fill makes it occupy all available Stack space.
          const Positioned.fill(child: AnimatedBubblesBackground()),

          // -----------------------------------------------------------------------
          // LAYER 3: Main Content
          // SafeArea ensures content does not overlap with the status bar or device notch.
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ), // Standard side padding.
              child: Form(
                key: _formKey, // Assign the global form key.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Stretch children horizontally.
                  children: [
                    // Back Button
                    // Aligned to the top left.
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () =>
                            Navigator.pop(context), // Close the current screen.
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lock/Person Icon with Glass Effect (Glassmorphism)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          24,
                        ), // Rounded corners of the container.
                        child: BackdropFilter(
                          // Gaussian blur filter for frosted glass effect.
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: 0.05,
                              ), // Semi-transparent white background (5%).
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(
                                  alpha: 0.1,
                                ), // Subtle white border (10%).
                              ),
                            ),
                            child: const Icon(
                              Icons.person_add_outlined, // "Add User" icon.
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Title
                    const Text(
                      'Únete a Alcatraz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Descriptive Subtitle
                    const Text(
                      'Crea tu bóveda segura y protege tus secretos.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // ----------------------------------------------------------------
                    // Field: Full Name
                    const Text(
                      'Nombre completo *',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                      ), // Input text in white.
                      decoration: InputDecoration(
                        hintText: 'Juan Pérez', // Example text.
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: const Color(
                          0xFF1A1A1A,
                        ), // Very dark gray input background.
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide.none, // No visible border by default.
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                      // Validation: Name cannot be empty.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingresa tu nombre";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ----------------------------------------------------------------
                    // Field: Email
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
                      // Validation: Uses email_validator package to check format.
                      validator: (value) {
                        if (value != null && !EmailValidator.validate(value)) {
                          return "Ingrese un email valido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ----------------------------------------------------------------
                    // Field: Password
                    const Text(
                      'Contraseña *',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller:
                          _passwordController, // Assigned controller to access value later.
                      obscureText:
                          !_isPasswordVisible, // Hides text if _isPasswordVisible is false.
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
                        // Suffix icon to toggle password visibility.
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            // Update state to redraw widget with new visibility.
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
                      // Validation: Minimum 8 characters.
                      validator: (value) {
                        if (value != null && value.length < 8) {
                          return "La contraseña debe tener al menos 8 caracteres";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ----------------------------------------------------------------
                    // Field: Confirm Password
                    const Text(
                      'Confirmar Contraseña *',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '........',
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_clock_outlined,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
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
                      // Validation: Must match the main password field.
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "Las contraseñas no coinciden";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // ----------------------------------------------------------------
                    // Register Button
                    ElevatedButton(
                      onPressed: () {
                        // Validate all form fields.
                        // Returns true if all validators return null.
                        if (_formKey.currentState!.validate()) {
                          // Simulate successful registration.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registro exitoso')),
                          );
                          // Navigation: Replaces the entire navigation stack with the Vault Screen (VaultScreen).
                          // This prevents the user from going back to registration by pressing "back".
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VaultScreen(),
                            ),
                            (route) => false, // Remove all previous routes.
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // White button for high contrast.
                        foregroundColor: Colors.black, // Black text.
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Registrarse',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
