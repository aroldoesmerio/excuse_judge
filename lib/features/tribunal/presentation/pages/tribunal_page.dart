import 'package:flutter/material.dart';

import '../../data/repositories/mock_verdict_repository.dart';
import '../../domain/usecases/judge_excuse_usecase.dart';
import '../controllers/tribunal_controller.dart';
import '../widgets/excuse_input.dart';
import '../widgets/tribunal_header.dart';
import 'verdict_page.dart';

class TribunalPage extends StatefulWidget {
  const TribunalPage({
    super.key,
  });

  @override
  State<TribunalPage> createState() => _TribunalPageState();
}

class _TribunalPageState extends State<TribunalPage> {
  late final TextEditingController _accusationController;
  late final TextEditingController _excuseController;
  late final TribunalController _tribunalController;

  @override
  void initState() {
    super.initState();

    _accusationController = TextEditingController();
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
    _accusationController.dispose();
    _excuseController.dispose();
    _tribunalController.dispose();

    super.dispose();
  }

  Future<void> _judgeCase() async {
    final verdict = await _tribunalController.judge(
      accusation: _accusationController.text,
      excuse: _excuseController.text,
    );

    if (verdict != null && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VerdictPage(
            verdict: verdict,
          ),
        ),
      );

      if (mounted) {
        _resetCase();
      }
    }
  }

  void _resetCase() {
    _accusationController.clear();
    _excuseController.clear();
    _tribunalController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tribunal das Desculpas'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                  minHeight: constraints.maxHeight,
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
                            accusationController: _accusationController,
                            excuseController: _excuseController,
                            isLoading: isLoading,
                            onJudge: _judgeCase,
                          ),
                          const SizedBox(height: 16),
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
                                  fontWeight: FontWeight.w500,
                                ),
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
        },
      ),
    );
  }
}