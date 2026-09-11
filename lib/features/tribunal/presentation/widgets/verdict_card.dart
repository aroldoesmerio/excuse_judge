import 'package:flutter/material.dart';

import '../../domain/entities/verdict.dart';

class VerdictCard extends StatelessWidget {
  final Verdict verdict;

  const VerdictCard({
    super.key,
    required this.verdict,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'VEREDITO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              verdict.verdict,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _ScoreRow(
              label: 'Credibilidade',
              value: verdict.credibility,
            ),
            _ScoreRow(
              label: 'Criatividade',
              value: verdict.creativity,
            ),
            _ScoreRow(
              label: 'Nível de desculpa',
              value: verdict.excuseLevel,
            ),
            const SizedBox(height: 16),
            Text(verdict.justification),
            const SizedBox(height: 16),
            Text(verdict.punishment),
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final double value;

  const _ScoreRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Text('$label: ${value.toStringAsFixed(1)}%');
  }
}
