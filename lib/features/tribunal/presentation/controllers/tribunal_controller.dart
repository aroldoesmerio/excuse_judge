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

  Future<void> judge({
    required String excuse,
  }) async {
    final normalizedExcuse = excuse.trim();

    if (normalizedExcuse.isEmpty) {
      errorMessage.value =
          'Digite uma desculpa antes de continuar.';
      verdict.value = null;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    verdict.value = null;

    try {
      final result = await judgeExcuseUseCase(
        excuse: normalizedExcuse,
      );

      verdict.value = result;
    } on Exception catch (exception) {
      errorMessage.value = exception.toString();
      verdict.value = null;
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