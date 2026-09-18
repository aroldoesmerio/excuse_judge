import '../entities/verdict.dart';

abstract interface class VerdictRepository {
  Future<Verdict> judge({
    required String accusation,
    required String excuse,
  });
}