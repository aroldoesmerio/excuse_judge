import 'package:flutter/material.dart';

class ExcuseInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final Future<void> Function() onJudge;

  const ExcuseInput({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onJudge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          enabled: !isLoading,
          minLines: 5,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: 'Apresente sua defesa',
            hintText:
                'Ex.: Eu ia fazer, mas o universo conspirou contra mim...',
            prefixIcon: Icon(Icons.balance),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: isLoading ? null : onJudge,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.gavel),
          label: Text(
            isLoading
                ? 'O tribunal está analisando...'
                : 'JULGAR MINHA DESCULPA',
          ),
        ),
      ],
    );
  }
}
