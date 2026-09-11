import 'package:flutter/material.dart';

import '../../data/repositories/mock_verdict_repository.dart';
import '../../domain/entities/verdict.dart';
import '../../domain/usecases/judge_excuse_usecase.dart';
import '../controllers/tribunal_controller.dart';
import '../widgets/excuse_input.dart';
import '../widgets/tribunal_header.dart';
import '../widgets/verdict_card.dart';

class TribunalPage extends StatefulWidget {
  const TribunalPage({
    super.key,
  });

  @override
  State<TribunalPage> createState() => _TribunalPageState();
}

class _TribunalPageState extends State<TribunalPage> {
  late final TextEditingController _excuseController;
  late final TribunalController _tribunalController;

  @override
  void initState() {
    super.initState();

    _excuseController = TextEditingController();

    final repository = MockVerdictRepository();

    final useCase = JudgeExcuseUseCase(
      repository: repository,
    );

    _tribunalController = TribunalController(
      judgeExcuseUseCase: useCase,
    );
  }

  @override
  void dispose() {
    _excuseController.dispose();
    _tribunalController.dispose();

    super.dispose();
  }

  Future<void> _judgeExcuse() async {
    await _tribunalController.judge(
      excuse: _excuseController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tribunal das Desculpas'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ValueListenableBuilder<bool>(
              valueListenable: _tribunalController.isLoading,
              builder: (
                context,
                isLoading,
                _,
              ) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TribunalHeader(),
                    const SizedBox(height: 32),
                    ExcuseInput(
                      controller: _excuseController,
                      isLoading: isLoading,
                      onJudge: _judgeExcuse,
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<String?>(
                      valueListenable:
                          _tribunalController.errorMessage,
                      builder: (
                        context,
                        errorMessage,
                        _,
                      ) {
                        if (errorMessage == null) {
                          return const SizedBox.shrink();
                        }

                        return Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .error,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<Verdict?>(
                      valueListenable:
                          _tribunalController.verdict,
                      builder: (
                        context,
                        verdict,
                        _,
                      ) {
                        if (verdict == null) {
                          return const SizedBox.shrink();
                        }

                        return VerdictCard(
                          verdict: verdict,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}