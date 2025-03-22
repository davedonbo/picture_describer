import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  final bool isLoading;
  final String description;
  final VoidCallback onSpeak;

  const DescriptionSection({
    super.key,
    required this.isLoading,
    required this.description,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          const CircularProgressIndicator(
            semanticsLabel: 'Processing image',
          ),
        if (description.isNotEmpty) ...[
          Semantics(
            liveRegion: true,
            child: Text(
              description,
              style: const TextStyle(fontSize: 20, height: 1.5),
            ),
          ),
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(Icons.volume_up, size: 40),
            onPressed: onSpeak,
            tooltip: 'Read description aloud',
          ),
        ],
      ],
    );
  }
}