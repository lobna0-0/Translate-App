import 'package:hive/hive.dart';
part 'lang.g.dart';

@HiveType(typeId: 1)
class Lang {
  @HiveField(1)
  final ResponseData responseData;
  @HiveField(2)
  final bool quotaFinished;
  @HiveField(3)
  final dynamic mtLangSupported;
  @HiveField(4)
  final String responseDetails;
  @HiveField(5)
  final int responseStatus;
  @HiveField(6)
  final dynamic responderId;
  @HiveField(7)
  final dynamic exceptionCode;
  @HiveField(8)
  final List<Match> matches;

  Lang({
    required this.responseData,
    required this.quotaFinished,
    required this.mtLangSupported,
    required this.responseDetails,
    required this.responseStatus,
    required this.responderId,
    required this.exceptionCode,
    required this.matches,
  });

  factory Lang.fromJson(Map<String, dynamic> json) {
    return Lang(
      responseData: ResponseData.fromJson(json['responseData'] ?? {}),
      quotaFinished: json['quotaFinished'] ?? false,
      mtLangSupported: json['mtLangSupported'],
      responseDetails: json['responseDetails'] ?? '',
      responseStatus: json['responseStatus'] ?? 0,
      responderId: json['responderId'],
      exceptionCode: json['exception_code'],
      matches: (json['matches'] is List)
          ? (json['matches'] as List)
              .map((e) => Match.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }
}

@HiveType(typeId: 2)
class Match {
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String segment;
  @HiveField(3)
  final String translation;
  @HiveField(4)
  final String source;
  @HiveField(5)
  final String target;
  @HiveField(6)
  final double quality;
  @HiveField(7)
  final dynamic reference;
  @HiveField(8)
  final int usageCount;
  @HiveField(9)
  final String subject;
  @HiveField(10)
  final String createdBy;
  @HiveField(11)
  final String lastUpdatedBy;
  @HiveField(12)
  final DateTime createDate;
  @HiveField(13)
  final DateTime lastUpdateDate;
  @HiveField(14)
  final double match;
  @HiveField(15)
  final double penalty;

  Match({
    required this.id,
    required this.segment,
    required this.translation,
    required this.source,
    required this.target,
    required this.quality,
    required this.reference,
    required this.usageCount,
    required this.subject,
    required this.createdBy,
    required this.lastUpdatedBy,
    required this.createDate,
    required this.lastUpdateDate,
    required this.match,
    required this.penalty,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'].toString(),
      segment: json['segment'] ?? '',
      translation: json['translation'] ?? '',
      source: json['source'] ?? '',
      target: json['target'] ?? '',
      quality: (json['quality'] is num)
          ? (json['quality'] as num).toDouble()
          : double.tryParse(json['quality'].toString()) ?? 0.0,
      reference: json['reference'],
      usageCount: json['usage-count'] ?? 0,
      subject: json['subject'] ?? '',
      createdBy: json['created-by'] ?? '',
      lastUpdatedBy: json['last-updated-by'] ?? '',
      createDate:
          DateTime.tryParse(json['create-date'] ?? '') ?? DateTime.now(),
      lastUpdateDate:
          DateTime.tryParse(json['last-update-date'] ?? '') ?? DateTime.now(),
      match: (json['match'] is num)
          ? (json['match'] as num).toDouble()
          : double.tryParse(json['match'].toString()) ?? 0.0,
      penalty: (json['penalty'] is num)
          ? (json['penalty'] as num).toDouble()
          : double.tryParse(json['penalty'].toString()) ?? 0.0,
    );
  }
}

@HiveType(typeId: 3)
class ResponseData {
  @HiveField(1)
  final String translatedText;
  @HiveField(2)
  final double match;

  ResponseData({
    required this.translatedText,
    required this.match,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      translatedText: json['translatedText'] ?? '',
      match: (json['match'] is num)
          ? (json['match'] as num).toDouble()
          : double.tryParse(json['match'].toString()) ?? 0.0,
    );
  }
}
