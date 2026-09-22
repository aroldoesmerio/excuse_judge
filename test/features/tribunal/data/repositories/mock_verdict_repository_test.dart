import 'package:excuse_judge/features/tribunal/data/repositories/mock_verdict_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockVerdictRepository', () {
    test('cenário padrão retorna CULPADO com seus dados principais', () async {
      const repository = MockVerdictRepository();

      final verdict = await repository.judge(
        accusation: 'Acusação qualquer',
        excuse: 'Defesa qualquer',
      );

      expect(verdict.verdict, 'CULPADO');
      expect(verdict.credibility, 42.5);
      expect(verdict.creativity, 71.8);
      expect(verdict.excuseLevel, 88.3);
      expect(verdict.justification, contains('sinais claros de desculpa'));
      expect(verdict.punishment, contains('condenado'));
    });

    test('defaultScenario: MockVerdictScenario.absolvido retorna ABSOLVIDO com seus dados principais', () async {
      const repository = MockVerdictRepository(
        defaultScenario: MockVerdictScenario.absolvido,
      );

      final verdict = await repository.judge(
        accusation: 'Acusação qualquer',
        excuse: 'Defesa qualquer',
      );

      expect(verdict.verdict, 'ABSOLVIDO');
      expect(verdict.credibility, 92.0);
      expect(verdict.creativity, 65.0);
      expect(verdict.excuseLevel, 12.0);
      expect(verdict.justification, contains('sólida'));
      expect(verdict.punishment, contains('absolvido'));
    });

    test('defaultScenario: MockVerdictScenario.parcialmenteCulpado retorna PARCIALMENTE CULPADO com seus dados principais', () async {
      const repository = MockVerdictRepository(
        defaultScenario: MockVerdictScenario.parcialmenteCulpado,
      );

      final verdict = await repository.judge(
        accusation: 'Acusação qualquer',
        excuse: 'Defesa qualquer',
      );

      expect(verdict.verdict, 'PARCIALMENTE CULPADO');
      expect(verdict.credibility, 65.0);
      expect(verdict.creativity, 58.0);
      expect(verdict.excuseLevel, 50.0);
      expect(verdict.justification, contains('fundamentos legítimos'));
      expect(verdict.punishment, contains('Sentença atenuada'));
    });
  });
}
