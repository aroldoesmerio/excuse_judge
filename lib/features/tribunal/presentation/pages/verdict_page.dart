import 'package:flutter/material.dart';

import '../../domain/entities/verdict.dart';
import '../widgets/verdict_card.dart';

class VerdictPage extends StatelessWidget {
  final Verdict verdict;

  const VerdictPage({
    super.key,
    required this.verdict,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tribunal das Desculpas'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Resultado do Julgamento',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      VerdictCard(
                        verdict: verdict,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('NOVO JULGAMENTO'),
                      ),
                      // Estrutura reservada para futura ação "COMPARTILHAR VEREDITO"
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
