import 'package:excuse_judge/features/tribunal/domain/entities/verdict.dart';
import 'package:excuse_judge/features/tribunal/domain/repositories/verdict_repository.dart';
import 'package:excuse_judge/features/tribunal/domain/usecases/judge_excuse_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeVerdictRepository implements VerdictRepository {
  String? capturedAccusation;
  String? capturedExcuse;
  late Verdict verdictToReturn;

  @override
  Future<Verdict> judge({
    required String accusation,
    required String excuse,
  }) async {
    capturedAccusation = accusation;
    capturedExcuse = excuse;
    return verdictToReturn;
  }
}

void main() {
  group('JudgeExcuseUseCase', () {
    test('recebe accusation e excuse, repassa ao repository e retorna o Verdict', () async {
      final repository = FakeVerdictRepository();
      final useCase = JudgeExcuseUseCase(repository: repository);

      const expectedVerdict = Verdict(
        credibility: 45.0,
        creativity: 80.0,
        excuseLevel: 92.5,
        verdict: 'CULPADO',
        justification: 'Desculpa esfarrapada.',
        punishment: 'Cumprir a tarefa imediatamente.',
      );
      repository.verdictToReturn = expectedVerdict;

      const accusation = 'Chegar atrasado na reunião';
      const excuse = 'O despertador não tocou';

      final result = await useCase(
        accusation: accusation,
        excuse: excuse,
      );

      expect(repository.capturedAccusation, accusation);
      expect(repository.capturedExcuse, excuse);
      expect(result, same(expectedVerdict));
    });
  });
}
