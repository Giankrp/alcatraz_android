import 'package:flutter/material.dart';
import 'package:alcatraz_android/src/features/vault/presentation/screens/vault_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const VaultScreen(),
    );
  }
}
