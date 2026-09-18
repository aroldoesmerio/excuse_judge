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
    final theme = Theme.of(context);

    final normalizedVerdict = verdict.verdict.trim().toUpperCase();
    final isGuilty = normalizedVerdict.contains('CULPAD') ||
        normalizedVerdict.contains('CONDENAD');

    final verdictColor =
        isGuilty ? const Color(0xFF9E2A2B) : const Color(0xFF2E6B34);
    final verdictBgColor =
        isGuilty ? const Color(0xFFFFF1F1) : const Color(0xFFF1F9F3);
    final verdictBorderColor =
        isGuilty ? const Color(0xFFFFCDD2) : const Color(0xFFC8E6C9);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: verdictBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: verdictBorderColor,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    isGuilty ? 'DECISÃO DO TRIBUNAL' : 'PARECER FAVORÁVEL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: verdictColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    verdict.verdict,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: verdictColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'MÉTRICAS AVALIADAS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _ScoreRow(
              label: 'Credibilidade',
              value: verdict.credibility,
              color: const Color(0xFF2D6A4F),
            ),
            _ScoreRow(
              label: 'Criatividade',
              value: verdict.creativity,
              color: const Color(0xFF5A4D8C),
            ),
            _ScoreRow(
              label: 'Nível de desculpa',
              value: verdict.excuseLevel,
              color: const Color(0xFFC85A17),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F3EA),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE2D9C8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 18,
                        color: Color(0xFF5A3E2B),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'JUSTIFICATIVA DO JÚRI',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF5A3E2B),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    verdict.justification,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF2B231D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: verdictBgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: verdictBorderColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isGuilty
                            ? Icons.gavel_rounded
                            : Icons.verified_rounded,
                        size: 18,
                        color: verdictColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isGuilty ? 'SENTENÇA APLICADA' : 'DECISÃO FINAL',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: verdictColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    verdict.punishment,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: verdictColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ScoreRow({
    required this.label,
    required this.value,
    required this.color,
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
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${value.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: color,
            backgroundColor: color.withAlpha(35),
          ),
        ],
      ),
    );
  }
}
