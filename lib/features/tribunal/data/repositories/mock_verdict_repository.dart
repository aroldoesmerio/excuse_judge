import '../../domain/entities/verdict.dart';
import '../../domain/repositories/verdict_repository.dart';

class MockVerdictRepository implements VerdictRepository {
  @override
  Future<Verdict> judge({
    required String excuse,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );

    return const Verdict(
      credibility: 42.5,
      creativity: 71.8,
      excuseLevel: 88.3,
      verdict: 'CULPADO',
      justification:
          'A justificativa apresenta alguns elementos plausíveis, '
          'mas possui sinais claros de desculpa.',
      punishment:
          'Você foi condenado a cumprir sua próxima tarefa sem reclamar.',
    );
  }
}