import '../../domain/entities/verdict.dart';
import '../../domain/repositories/verdict_repository.dart';

enum MockVerdictScenario {
  absolvido,
  culpado,
  parcialmenteCulpado,
}

class MockVerdictRepository implements VerdictRepository {
  final MockVerdictScenario defaultScenario;

  const MockVerdictRepository({
    this.defaultScenario = MockVerdictScenario.culpado,
  });

  static const _absolvidoVerdict = Verdict(
    credibility: 92.0,
    creativity: 65.0,
    excuseLevel: 12.0,
    verdict: 'ABSOLVIDO',
    justification:
        'A justificativa apresentada é sólida, plausível e resiste à análise do tribunal.',
    punishment:
        'Você foi absolvido de todas as acusações. O caso foi arquivado.',
  );

  static const _culpadoVerdict = Verdict(
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

  static const _parcialmenteCulpadoVerdict = Verdict(
    credibility: 65.0,
    creativity: 58.0,
    excuseLevel: 50.0,
    verdict: 'PARCIALMENTE CULPADO',
    justification:
        'Há fundamentos legítimos em sua narrativa, mas o tribunal detectou exageros e omissões parciais.',
    punishment:
        'Sentença atenuada: cumprir a tarefa com direito a apenas uma reclamação formal.',
  );

  @override
  Future<Verdict> judge({
    required String accusation,
    required String excuse,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );

    return switch (defaultScenario) {
      MockVerdictScenario.absolvido => _absolvidoVerdict,
      MockVerdictScenario.culpado => _culpadoVerdict,
      MockVerdictScenario.parcialmenteCulpado => _parcialmenteCulpadoVerdict,
    };
  }
}