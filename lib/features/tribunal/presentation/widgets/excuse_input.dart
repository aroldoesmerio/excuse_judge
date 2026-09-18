import 'package:flutter/material.dart';

class ExcuseInput extends StatelessWidget {
  final TextEditingController accusationController;
  final TextEditingController excuseController;
  final bool isLoading;
  final Future<void> Function() onJudge;

  const ExcuseInput({
    super.key,
    required this.accusationController,
    required this.excuseController,
    required this.isLoading,
    required this.onJudge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: accusationController,
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Do que você está sendo acusado?',
            hintText: 'Ex.: Chegar atrasado ao trabalho',
            prefixIcon: Icon(Icons.gavel_outlined),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: excuseController,
          enabled: !isLoading,
          minLines: 4,
          maxLines: 7,
          decoration: const InputDecoration(
            labelText: 'Qual é a sua defesa?',
            hintText: 'Ex.: O trânsito estava completamente parado...',
            prefixIcon: Icon(Icons.balance_outlined),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: isLoading ? null : onJudge,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.balance),
          label: Text(
            isLoading ? 'O tribunal está julgando...' : 'JULGAR CASO',
          ),
        ),
      ],
    );
  }
}
