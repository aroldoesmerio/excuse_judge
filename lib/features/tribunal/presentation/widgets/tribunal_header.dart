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
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
