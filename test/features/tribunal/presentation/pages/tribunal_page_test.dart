import 'package:excuse_judge/features/tribunal/presentation/pages/tribunal_page.dart';
import 'package:excuse_judge/features/tribunal/presentation/pages/verdict_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TribunalPage', () {
    testWidgets('exibe mensagem de validação visual ao tentar julgar sem preencher os campos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TribunalPage(),
        ),
      );

      final judgeButton = find.widgetWithText(ElevatedButton, 'JULGAR CASO');
      expect(judgeButton, findsOneWidget);

      await tester.ensureVisible(judgeButton);
      await tester.tap(judgeButton);
      await tester.pump();

      expect(find.text('Informe a acusação antes de continuar.'), findsOneWidget);
    });

    testWidgets('executa fluxo completo de julgamento e retorno com campos limpos ao acionar novo julgamento', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TribunalPage(),
        ),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.at(0), 'Chegou 30 minutos atrasado');
      await tester.enterText(textFields.at(1), 'Havia uma manada de capivaras na pista');
      await tester.pump();

      final judgeButton = find.widgetWithText(ElevatedButton, 'JULGAR CASO');
      await tester.ensureVisible(judgeButton);
      await tester.tap(judgeButton);

      await tester.pump();
      expect(find.text('O tribunal está julgando...'), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(VerdictPage), findsOneWidget);
      expect(find.text('Resultado do Julgamento'), findsOneWidget);

      final newTrialButton = find.text('NOVO JULGAMENTO');
      expect(newTrialButton, findsOneWidget);

      await tester.ensureVisible(newTrialButton);
      await tester.tap(newTrialButton);
      await tester.pumpAndSettle();

      expect(find.byType(TribunalPage), findsOneWidget);
      expect(find.byType(VerdictPage), findsNothing);

      final accusationField = tester.widget<TextField>(textFields.at(0));
      expect(accusationField.controller?.text, isEmpty);

      final excuseField = tester.widget<TextField>(textFields.at(1));
      expect(excuseField.controller?.text, isEmpty);
    });
  });
}
