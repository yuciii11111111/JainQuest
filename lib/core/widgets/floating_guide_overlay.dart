import 'package:flutter/material.dart';

class FloatingGuideOverlay extends StatelessWidget {
  const FloatingGuideOverlay({super.key});

  static const _assetPath = 'assets/images/duo_guide.png';
  static const _size = 84.0;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            _assetPath,
            width: _size,
            height: _size,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
