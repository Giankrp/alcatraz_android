import 'dart:ui';
import 'package:flutter/material.dart';

/// SettingsScreen: User settings and preferences screen.
/// Allows the user to modify their profile (username),
/// adjust general settings like volume and notifications,
/// and log out.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Controller for the username text field.
  // Initialized with a default value to simulate an existing user.
  final _usernameController = TextEditingController(text: 'Gian');

  // State variable for volume level (0.0 to 100.0).
  double _volume = 50.0;

  // State variable to enable/disable notifications.
  bool _notificationsEnabled = true;

  /// Resource cleanup when destroying the widget.
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We use a main Column to structure the header and scrollable content.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left alignment.
      children: [
        // Screen title "Ajustes", separated from the top edge.
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Text(
            'Ajustes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Expanded allows the ListView to occupy the remaining screen space.
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // ----------------------------------------------------------------
              // SECTION: PROFILE
              _buildSectionHeader('Perfil'),
              const SizedBox(height: 16),

              // Container with Glassmorphism effect to group profile data.
              _buildContainer(
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Circular profile icon with translucent green background.
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF00E676,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(
                              0xFF00E676,
                            ), // Characteristic neon green.
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Editable text field for the name.
                        Expanded(
                          child: TextField(
                            controller: _usernameController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Nombre de usuario',
                              labelStyle: TextStyle(color: Colors.grey),
                              border:
                                  InputBorder.none, // No border, clean style.
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        // Pencil icon to indicate editability.
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {
                            // In a real implementation, this could focus the input
                            // or enable editing if it were disabled.
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ----------------------------------------------------------------
              // SECTION: GENERAL
              _buildSectionHeader('General'),
              const SizedBox(height: 16),

              // Container for general app settings.
              _buildContainer(
                child: Column(
                  children: [
                    // Volume Control
                    Row(
                      children: [
                        const Icon(Icons.volume_up, color: Colors.grey),
                        const SizedBox(width: 16),
                        const Text(
                          'Volumen',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const Spacer(), // Pushes percentage text to the right.
                        Text(
                          '${_volume.toInt()}%', // Shows integer value.
                          style: const TextStyle(
                            color: Color(0xFF00E676),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Slider to adjust volume.
                    Slider(
                      value: _volume,
                      min: 0,
                      max: 100,
                      activeColor: const Color(0xFF00E676),
                      inactiveColor: Colors.grey.withValues(alpha: 0.3),
                      onChanged: (value) {
                        setState(() {
                          _volume = value;
                        });
                      },
                    ),

                    const Divider(color: Colors.grey, height: 32),

                    // Notifications Control
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.notifications, color: Colors.grey),
                            SizedBox(width: 16),
                            Text(
                              'Notificaciones',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        // Switch to enable/disable.
                        Switch(
                          value: _notificationsEnabled,
                          activeThumbColor: const Color(0xFF00E676),
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ----------------------------------------------------------------
              // Logout Button
              ElevatedButton(
                onPressed: () {
                  // Navigates back to the root route ('/') which is likely the LoginScreen.
                  // pushReplacementNamed removes the current screen from the stack.
                  Navigator.of(context).pushReplacementNamed('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(
                    alpha: 0.1,
                  ), // Soft red background.
                  foregroundColor: Colors.red, // Red text.
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0, // No elevation (flat).
                ),
                child: const Text('Cerrar Sesión'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper method to build section headers.
  /// Maintains style consistency (uppercase, gray, spacing).
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  /// Helper method to build card containers.
  /// Applies blur effect (Glassmorphism), rounded corners, and semi-transparent background.
  Widget _buildContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(
              0xFF1E1E2C,
            ).withValues(alpha: 0.6), // Translucent dark blue background.
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ), // Subtle border.
          ),
          child: child,
        ),
      ),
    );
  }
}
