import 'package:flutter/material.dart';

class TribunalHeader extends StatelessWidget {
  const TribunalHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCF7),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFD6A84F),
              width: 2.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x225A3E2B),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.balance_rounded,
              size: 46,
              color: Color(0xFF5A3E2B),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0x1F5A3E2B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0x335A3E2B),
            ),
          ),
          child: const Text(
            'SESSÃO DO JÚRI',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5A3E2B),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tribunal das Desculpas',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Apresente sua defesa. Toda desculpa merece um julgamento imparcial.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
