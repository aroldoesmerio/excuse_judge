import 'package:flutter/material.dart';

class TribunalHeader extends StatelessWidget {
  const TribunalHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '⚖️',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 64,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tribunal das Desculpas',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Apresente sua defesa. O tribunal está pronto para julgar.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
