import 'dart:typed_data';
import 'package:flutter/material.dart';

class EditPhotoPage extends StatelessWidget {
  const EditPhotoPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
    required this.imageBytes,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kép szerkesztése'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.memory(imageBytes),
        ),
      ),
    );
  }
}
