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
              '⚖️ VEREDITO',
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
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
            Text(
              '📜 JUSTIFICATIVA',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(verdict.justification),
            const SizedBox(height: 16),
            Text(
              '⛓️ SENTENÇA',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
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
    final progress = (value / 100).clamp(0.0, 1.0).toDouble();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('${value.toStringAsFixed(1)}%'),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondary,
            backgroundColor:
                Theme.of(context).colorScheme.secondary.withAlpha(45),
          ),
        ],
      ),
    );
  }
}
