import 'package:excuse_judge/features/tribunal/domain/entities/verdict.dart';
import 'package:excuse_judge/features/tribunal/domain/repositories/verdict_repository.dart';
import 'package:excuse_judge/features/tribunal/domain/usecases/judge_excuse_usecase.dart';
import 'package:excuse_judge/features/tribunal/presentation/controllers/tribunal_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeJudgeExcuseUseCase implements JudgeExcuseUseCase {
  @override
  VerdictRepository get repository => throw UnimplementedError();

  int callCount = 0;
  String? capturedAccusation;
  String? capturedExcuse;
  Verdict? verdictToReturn;
  Exception? exceptionToThrow;
  void Function()? onCall;

  @override
  Future<Verdict> call({
    required String accusation,
    required String excuse,
  }) async {
    callCount++;
    capturedAccusation = accusation;
    capturedExcuse = excuse;
    onCall?.call();

    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    return verdictToReturn!;
  }
}

void main() {
  group('TribunalController', () {
    late FakeJudgeExcuseUseCase fakeUseCase;
    late TribunalController controller;

    const dummyVerdict = Verdict(
      credibility: 50.0,
      creativity: 70.0,
      excuseLevel: 80.0,
      verdict: 'CULPADO',
      justification: 'Justificativa de teste.',
      punishment: 'Sentença de teste.',
    );

    setUp(() {
      fakeUseCase = FakeJudgeExcuseUseCase();
      controller = TribunalController(judgeExcuseUseCase: fakeUseCase);
    });

    tearDown(() {
      controller.dispose();
    });

    group('Validação da acusação', () {
      test('quando vazia, define mensagem de erro e não chama o caso de uso', () async {
        final result = await controller.judge(
          accusation: '',
          excuse: 'Defesa válida',
        );

        expect(controller.errorMessage.value, 'Informe a acusação antes de continuar.');
        expect(controller.verdict.value, isNull);
        expect(controller.isLoading.value, isFalse);
        expect(fakeUseCase.callCount, 0);
        expect(result, isNull);
      });

      test('quando contiver apenas espaços em branco, define mensagem de erro e não chama o caso de uso', () async {
        final result = await controller.judge(
          accusation: '     ',
          excuse: 'Defesa válida',
        );

        expect(controller.errorMessage.value, 'Informe a acusação antes de continuar.');
        expect(controller.verdict.value, isNull);
        expect(controller.isLoading.value, isFalse);
        expect(fakeUseCase.callCount, 0);
        expect(result, isNull);
      });
    });

    group('Validação da defesa', () {
      test('quando vazia, define mensagem de erro e não chama o caso de uso', () async {
        final result = await controller.judge(
          accusation: 'Acusação válida',
          excuse: '',
        );

        expect(controller.errorMessage.value, 'Informe sua defesa antes de continuar.');
        expect(controller.verdict.value, isNull);
        expect(controller.isLoading.value, isFalse);
        expect(fakeUseCase.callCount, 0);
        expect(result, isNull);
      });

      test('quando contiver apenas espaços em branco, define mensagem de erro e não chama o caso de uso', () async {
        final result = await controller.judge(
          accusation: 'Acusação válida',
          excuse: '     ',
        );

        expect(controller.errorMessage.value, 'Informe sua defesa antes de continuar.');
        expect(controller.verdict.value, isNull);
        expect(controller.isLoading.value, isFalse);
        expect(fakeUseCase.callCount, 0);
        expect(result, isNull);
      });
    });

    group('Normalização', () {
      test('trata accusation e excuse com trim() antes de repassar ao caso de uso', () async {
        fakeUseCase.verdictToReturn = dummyVerdict;

        await controller.judge(
          accusation: '   Acusação com espaços   ',
          excuse: '   Defesa com espaços   ',
        );

        expect(fakeUseCase.capturedAccusation, 'Acusação com espaços');
        expect(fakeUseCase.capturedExcuse, 'Defesa com espaços');
      });
    });

    group('Sucesso', () {
      test('atualiza verdict, limpa erro e desativa loading ao concluir julgamento', () async {
        fakeUseCase.verdictToReturn = dummyVerdict;
        bool wasLoadingDuringCall = false;

        fakeUseCase.onCall = () {
          wasLoadingDuringCall = controller.isLoading.value;
        };

        final result = await controller.judge(
          accusation: 'Acusação',
          excuse: 'Defesa',
        );

        expect(wasLoadingDuringCall, isTrue);
        expect(controller.verdict.value, same(dummyVerdict));
        expect(controller.errorMessage.value, isNull);
        expect(controller.isLoading.value, isFalse);
        expect(result, same(dummyVerdict));
      });
    });

    group('Erro', () {
      test('captura Exception, preenche errorMessage, zera verdict e desativa loading', () async {
        final exception = Exception('Falha ao processar julgamento');
        fakeUseCase.exceptionToThrow = exception;

        final result = await controller.judge(
          accusation: 'Acusação',
          excuse: 'Defesa',
        );

        expect(controller.errorMessage.value, exception.toString());
        expect(controller.verdict.value, isNull);
        expect(controller.isLoading.value, isFalse);
        expect(result, isNull);
      });
    });

    group('Reset', () {
      test('restaura verdict, errorMessage e isLoading para o estado inicial', () async {
        fakeUseCase.verdictToReturn = dummyVerdict;

        await controller.judge(
          accusation: 'Acusação',
          excuse: 'Defesa',
        );

        expect(controller.verdict.value, isNotNull);

        controller.reset();

        expect(controller.verdict.value, isNull);
        expect(controller.errorMessage.value, isNull);
        expect(controller.isLoading.value, isFalse);
      });
    });
  });
}
