import '../entities/verdict.dart';
import '../repositories/verdict_repository.dart';

class JudgeExcuseUseCase {
  final VerdictRepository repository;

  const JudgeExcuseUseCase({required this.repository});

  Future<Verdict> call({
    required String accusation,
    required String excuse,
  }) {
    return repository.judge(
      accusation: accusation,
      excuse: excuse,
    );
  }
}