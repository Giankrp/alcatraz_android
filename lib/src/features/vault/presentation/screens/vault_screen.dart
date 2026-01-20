import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient removed, just solid black from Scaffold

          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF00E676,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF00E676),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                      // Add Button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676),
                          shape: BoxShape.circle,
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
                          icon: const Icon(Icons.add, color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Buscar en la bóveda...',
                          hintStyle: TextStyle(
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: const Color(
                            0xFF1A1A1A,
                          ).withValues(alpha: 0.8),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
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

                // Bottom Navigation
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 18),
                  ),
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

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? const Color(0xFF00E676) : Colors.grey;

    return GestureDetector(
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
