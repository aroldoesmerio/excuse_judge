import 'package:flutter/foundation.dart';

import '../../domain/entities/verdict.dart';
import '../../domain/usecases/judge_excuse_usecase.dart';

class TribunalController {
  final JudgeExcuseUseCase judgeExcuseUseCase;

  final ValueNotifier<Verdict?> verdict =
      ValueNotifier<Verdict?>(null);

  final ValueNotifier<bool> isLoading =
      ValueNotifier<bool>(false);

  final ValueNotifier<String?> errorMessage =
      ValueNotifier<String?>(null);

  TribunalController({
    required this.judgeExcuseUseCase,
  });

  Future<Verdict?> judge({
    required String accusation,
    required String excuse,
  }) async {
    final normalizedAccusation = accusation.trim();
    final normalizedExcuse = excuse.trim();

    if (normalizedAccusation.isEmpty) {
      errorMessage.value = 'Informe a acusação antes de continuar.';
      verdict.value = null;
      return null;
    }

    if (normalizedExcuse.isEmpty) {
      errorMessage.value = 'Informe sua defesa antes de continuar.';
      verdict.value = null;
      return null;
    }

    isLoading.value = true;
    errorMessage.value = null;
    verdict.value = null;

    try {
      final result = await judgeExcuseUseCase(
        accusation: normalizedAccusation,
        excuse: normalizedExcuse,
      );

      verdict.value = result;
      return result;
    } on Exception catch (exception) {
      errorMessage.value = exception.toString();
      verdict.value = null;
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    verdict.value = null;
    errorMessage.value = null;
    isLoading.value = false;
  }

  void dispose() {
    verdict.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}