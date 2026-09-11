class VerdictException implements Exception {
  final String message;

  const VerdictException(this.message);

  @override
  String toString() => message;
}