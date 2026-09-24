import '../../domain/entities/verdict.dart';

class VerdictModel {
  final double credibility;
  final double creativity;
  final double excuseLevel;
  final String verdict;
  final String justification;
  final String punishment;

  const VerdictModel({
    required this.credibility,
    required this.creativity,
    required this.excuseLevel,
    required this.verdict,
    required this.justification,
    required this.punishment,
  });

  factory VerdictModel.fromJson(Map<String, dynamic> json) {
    double parseScore(String key) {
      final value = json[key];
      if (value is! num) {
        throw FormatException('O campo "$key" é obrigatório e deve ser numérico.');
      }
      final doubleValue = value.toDouble();
      if (doubleValue < 0.0 || doubleValue > 100.0 || doubleValue.isNaN) {
        throw FormatException('O campo "$key" deve estar entre 0.0 e 100.0: $doubleValue.');
      }
      return doubleValue;
    }

    final rawVerdict = json['verdict'];
    if (rawVerdict is! String) {
      throw const FormatException('O campo "verdict" é obrigatório e deve ser String.');
    }
    final normalizedVerdict = rawVerdict.trim().toUpperCase();
    const validVerdicts = {'ABSOLVIDO', 'CULPADO', 'PARCIALMENTE CULPADO'};
    if (!validVerdicts.contains(normalizedVerdict)) {
      throw FormatException('Veredito inválido recebido: "$rawVerdict".');
    }

    final rawJustification = json['justification'];
    if (rawJustification is! String) {
      throw const FormatException('O campo "justification" é obrigatório e deve ser String.');
    }
    final normalizedJustification = rawJustification.trim();
    if (normalizedJustification.isEmpty) {
      throw const FormatException('O campo "justification" não pode ser vazio.');
    }

    final rawPunishment = json['punishment'];
    if (rawPunishment is! String) {
      throw const FormatException('O campo "punishment" é obrigatório e deve ser String.');
    }
    final normalizedPunishment = rawPunishment.trim();
    if (normalizedPunishment.isEmpty) {
      throw const FormatException('O campo "punishment" não pode ser vazio.');
    }

    return VerdictModel(
      credibility: parseScore('credibility'),
      creativity: parseScore('creativity'),
      excuseLevel: parseScore('excuseLevel'),
      verdict: normalizedVerdict,
      justification: normalizedJustification,
      punishment: normalizedPunishment,
    );
  }

  Verdict toEntity() {
    return Verdict(
      credibility: credibility,
      creativity: creativity,
      excuseLevel: excuseLevel,
      verdict: verdict,
      justification: justification,
      punishment: punishment,
    );
  }
}
