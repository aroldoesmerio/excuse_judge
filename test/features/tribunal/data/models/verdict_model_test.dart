import 'package:excuse_judge/features/tribunal/data/models/verdict_model.dart';
import 'package:excuse_judge/features/tribunal/domain/entities/verdict.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VerdictModel', () {
    Map<String, dynamic> buildValidJson({
      dynamic credibility = 45.5,
      dynamic creativity = 80.0,
      dynamic excuseLevel = 75.0,
      dynamic verdict = 'CULPADO',
      dynamic justification = 'Justificativa válida.',
      dynamic punishment = 'Sentença válida.',
    }) {
      return <String, dynamic>{
        'credibility': credibility,
        'creativity': creativity,
        'excuseLevel': excuseLevel,
        'verdict': verdict,
        'justification': justification,
        'punishment': punishment,
      };
    }

    test('1. JSON válido cria VerdictModel corretamente', () {
      final json = buildValidJson(
        credibility: 45.5,
        creativity: 80.0,
        excuseLevel: 75.0,
        verdict: 'CULPADO',
        justification: 'Justificativa plausível com sinais de desculpa.',
        punishment: 'Cumprir a tarefa sem reclamar.',
      );

      final model = VerdictModel.fromJson(json);

      expect(model.credibility, 45.5);
      expect(model.creativity, 80.0);
      expect(model.excuseLevel, 75.0);
      expect(model.verdict, 'CULPADO');
      expect(model.justification, 'Justificativa plausível com sinais de desculpa.');
      expect(model.punishment, 'Cumprir a tarefa sem reclamar.');
    });

    test('2. toEntity() cria Verdict com os mesmos valores', () {
      final json = buildValidJson();
      final model = VerdictModel.fromJson(json);

      final entity = model.toEntity();

      expect(entity, isA<Verdict>());
      expect(entity.credibility, model.credibility);
      expect(entity.creativity, model.creativity);
      expect(entity.excuseLevel, model.excuseLevel);
      expect(entity.verdict, model.verdict);
      expect(entity.justification, model.justification);
      expect(entity.punishment, model.punishment);
    });

    test('3. credibility abaixo de 0 lança FormatException', () {
      final json = buildValidJson(credibility: -0.1);

      expect(() => VerdictModel.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('4. credibility acima de 100 lança FormatException', () {
      final json = buildValidJson(credibility: 100.1);

      expect(() => VerdictModel.fromJson(json), throwsA(isA<FormatException>()));
    });

    test('5. creativity fora do intervalo lança FormatException', () {
      final jsonBelowZero = buildValidJson(creativity: -1.0);
      final jsonAboveHundred = buildValidJson(creativity: 105.0);

      expect(() => VerdictModel.fromJson(jsonBelowZero), throwsA(isA<FormatException>()));
      expect(() => VerdictModel.fromJson(jsonAboveHundred), throwsA(isA<FormatException>()));
    });

    test('6. excuseLevel fora do intervalo lança FormatException', () {
      final jsonBelowZero = buildValidJson(excuseLevel: -0.5);
      final jsonAboveHundred = buildValidJson(excuseLevel: 100.5);

      expect(() => VerdictModel.fromJson(jsonBelowZero), throwsA(isA<FormatException>()));
      expect(() => VerdictModel.fromJson(jsonAboveHundred), throwsA(isA<FormatException>()));
    });

    test('7. verdict inválido lança FormatException', () {
      final jsonInvalidVerdict = buildValidJson(verdict: 'INOCENTE');
      final jsonEmptyVerdict = buildValidJson(verdict: '');

      expect(() => VerdictModel.fromJson(jsonInvalidVerdict), throwsA(isA<FormatException>()));
      expect(() => VerdictModel.fromJson(jsonEmptyVerdict), throwsA(isA<FormatException>()));
    });

    test('8. justification vazia lança FormatException', () {
      final jsonEmpty = buildValidJson(justification: '');
      final jsonWhitespaceOnly = buildValidJson(justification: '    ');

      expect(() => VerdictModel.fromJson(jsonEmpty), throwsA(isA<FormatException>()));
      expect(() => VerdictModel.fromJson(jsonWhitespaceOnly), throwsA(isA<FormatException>()));
    });

    test('9. punishment vazia lança FormatException', () {
      final jsonEmpty = buildValidJson(punishment: '');
      final jsonWhitespaceOnly = buildValidJson(punishment: '    ');

      expect(() => VerdictModel.fromJson(jsonEmpty), throwsA(isA<FormatException>()));
      expect(() => VerdictModel.fromJson(jsonWhitespaceOnly), throwsA(isA<FormatException>()));
    });

    group('10. campo obrigatório ausente lança FormatException', () {
      for (final key in [
        'credibility',
        'creativity',
        'excuseLevel',
        'verdict',
        'justification',
        'punishment',
      ]) {
        test('campo "$key" ausente', () {
          final json = buildValidJson()..remove(key);

          expect(() => VerdictModel.fromJson(json), throwsA(isA<FormatException>()));
        });
      }
    });

    test('11. valores numéricos inteiros são aceitos e convertidos para double', () {
      final json = buildValidJson(
        credibility: 50,
        creativity: 80,
        excuseLevel: 100,
      );

      final model = VerdictModel.fromJson(json);

      expect(model.credibility, 50.0);
      expect(model.credibility, isA<double>());
      expect(model.creativity, 80.0);
      expect(model.creativity, isA<double>());
      expect(model.excuseLevel, 100.0);
      expect(model.excuseLevel, isA<double>());
    });

    test('12. espaços externos em verdict, justification e punishment são tratados com trim()', () {
      final json = buildValidJson(
        verdict: '   absolvido   ',
        justification: '   Justificativa com espaços externos   ',
        punishment: '   Sentença com espaços externos   ',
      );

      final model = VerdictModel.fromJson(json);

      expect(model.verdict, 'ABSOLVIDO');
      expect(model.justification, 'Justificativa com espaços externos');
      expect(model.punishment, 'Sentença com espaços externos');
    });
  });
}
