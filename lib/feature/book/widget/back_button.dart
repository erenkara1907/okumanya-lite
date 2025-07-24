// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Microphone widget for recording audio
class BackButtonArrow extends StatefulWidget {
  /// Creates a microphone widget
  const BackButtonArrow({
    super.key,
    this.onTap,
  });

  /// [onTap] callback when the microphone is tapped
  final void Function()? onTap;

  @override
  State<BackButtonArrow> createState() => _BackButtonArrowState();
}

class _BackButtonArrowState extends State<BackButtonArrow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white24,
          ),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
