import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alcatraz_android/src/features/settings/presentation/screens/settings_screen.dart';

/// VaultScreen: Main application screen.
/// Displays the password vault and other secure user items.
/// Also manages the app's main navigation via a bottom bar,
/// allowing switching between Vault, Cards, Notes, and Settings.
class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  // Selected index for the bottom navigation bar.
  // 0: Vault, 1: Cards, 2: Notes, 3: Settings.
  // Initially shows the Vault (0).
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme.
      body: Stack(
        children: [
          // ----------------------------------------------------------------
          // LAYER 1 and ONLY: Main Content
          // SafeArea is used to avoid overlaps with the system UI.
          SafeArea(
            child: Column(
              children: [
                // Expanded makes the main content occupy all remaining space
                // above the navigation bar.
                Expanded(
                  // NAVIGATION LOGIC:
                  // If selected index is 3, show Settings Screen.
                  // Otherwise, show Vault View (Column).
                  // NOTE: For a more complex app, an IndexedStack would be better
                  // to preserve each tab's state, or a nested router.
                  child: _selectedIndex == 3
                      ? const SettingsScreen()
                      : Column(
                          children: [
                            const SizedBox(height: 20),

                            // ----------------------------------------------------------
                            // HEADER
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Logo and Title
                                  Row(
                                    children: [
                                      // Decorative lock icon
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF00E676,
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.lock_outline,
                                          color: Color(0xFF00E676),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // App Title
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Bóveda Segura',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'ALCATRAZ',
                                            style: TextStyle(
                                              color: const Color(
                                                0xFF00E676,
                                              ).withValues(alpha: 0.8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Floating/Round "Add" Button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00E676),
                                      shape: BoxShape.circle,
                                      // Green glowing shadow effect
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF00E676,
                                          ).withValues(alpha: 0.4),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        // Action to add new secure item
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ----------------------------------------------------------
                            // SEARCH BAR
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: TextField(
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Buscar en la bóveda...',
                                      hintStyle: TextStyle(
                                        color: Colors.grey.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      // Semi-transparent dark background
                                      fillColor: const Color(
                                        0xFF1A1A1A,
                                      ).withValues(alpha: 0.8),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // ----------------------------------------------------------
                            // ITEM GRID (The Vault)
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 2, // 2 columns per row
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                mainAxisSpacing: 16, // Vertical spacing
                                crossAxisSpacing: 16, // Horizontal spacing
                                childAspectRatio:
                                    1.1, // Card aspect ratio (wider than tall)
                                children: [
                                  // Example hardcoded items
                                  _buildVaultCard(
                                    icon: FontAwesomeIcons.idCard,
                                    title: 'DNI',
                                    subtitle: 'gian@gmail.com',
                                    tag: 'IDENTITY',
                                    tagColor: const Color(0xFF00E676),
                                  ),
                                  _buildVaultCard(
                                    icon: FontAwesomeIcons.key,
                                    title: 'Google',
                                    subtitle: 'g.user...',
                                  ),
                                  _buildVaultCard(
                                    icon: FontAwesomeIcons.key,
                                    title: 'Contraseña',
                                    subtitle: 'user_99...',
                                  ),
                                  _buildVaultCard(
                                    icon: FontAwesomeIcons.creditCard,
                                    title: 'Visa Platinum',
                                    subtitle: '**** 4242',
                                    tag: 'VISA',
                                    tagColor: const Color(0xFF00E676),
                                  ),
                                  _buildVaultCard(
                                    icon: FontAwesomeIcons.fileLines,
                                    title: 'Notas Privadas',
                                    subtitle: 'Información sensible',
                                  ),
                                  _buildVaultCard(
                                    icon: FontAwesomeIcons.briefcase,
                                    title: 'Trabajo',
                                    subtitle: 'Slack, Jira, VPN',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),

                // --------------------------------------------------------------
                // BOTTOM NAVIGATION BAR
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    border: Border(
                      top: BorderSide(
                        // Subtle top divider line
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Navigation items. Each has an associated index.
                      _buildNavItem(Icons.lock, 'Bóveda', 0),
                      _buildNavItem(Icons.credit_card, 'Tarjetas', 1),
                      _buildNavItem(Icons.description, 'Notas', 2),
                      _buildNavItem(Icons.settings, 'Ajustes', 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an individual card for the vault grid.
  /// Displays an icon, title, subtitle, and optionally a tag.
  Widget _buildVaultCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String? tag,
    Color? tagColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        // Glassmorphism effect
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          // Vertical structure: Icon/Tag top, Texts bottom.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top row: Icon and Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Item Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 18),
                  ),
                  // Optional tag (e.g., VISA, IDENTITY)
                  if (tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            tagColor?.withValues(alpha: 0.1) ??
                            Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: tagColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              // Bottom row: Title and Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a bottom navigation bar item.
  /// Changes color (green) if selected, or gray if not.
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    // Neon green color if selected, gray if not.
    final color = isSelected ? const Color(0xFF00E676) : Colors.grey;

    return GestureDetector(
      // On tap, update the selected index and redraw the screen.
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
