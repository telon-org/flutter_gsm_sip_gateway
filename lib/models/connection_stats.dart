class ConnectionStats {
  final double asr; // Answer Seizure Ratio
  final double asd; // Average Setup Delay
  final double acd; // Average Call Duration
  final double cdr; // Call Drop Rate
  final double mos; // Mean Opinion Score
  final int totalAttempts;
  final int successfulCalls;
  final double successRate;
  final DateTime lastCallTime;
  final Duration totalCallTime;
  final int totalCalls;

  ConnectionStats({
    required this.asr,
    required this.asd,
    required this.acd,
    required this.cdr,
    required this.mos,
    required this.totalAttempts,
    required this.successfulCalls,
    required this.successRate,
    required this.lastCallTime,
    required this.totalCallTime,
    required this.totalCalls,
  });

  factory ConnectionStats.fromJson(Map<String, dynamic> json) {
    return ConnectionStats(
      asr: (json['asr'] ?? 0.0).toDouble(),
      asd: (json['asd'] ?? 0.0).toDouble(),
      acd: (json['acd'] ?? 0.0).toDouble(),
      cdr: (json['cdr'] ?? 0.0).toDouble(),
      mos: (json['mos'] ?? 0.0).toDouble(),
      totalAttempts: json['totalAttempts'] ?? 0,
      successfulCalls: json['successfulCalls'] ?? 0,
      successRate: (json['successRate'] ?? 0.0).toDouble(),
      lastCallTime: DateTime.parse(json['lastCallTime'] ?? DateTime.now().toIso8601String()),
      totalCallTime: Duration(seconds: json['totalCallTimeSeconds'] ?? 0),
      totalCalls: json['totalCalls'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asr': asr,
      'asd': asd,
      'acd': acd,
      'cdr': cdr,
      'mos': mos,
      'totalAttempts': totalAttempts,
      'successfulCalls': successfulCalls,
      'successRate': successRate,
      'lastCallTime': lastCallTime.toIso8601String(),
      'totalCallTimeSeconds': totalCallTime.inSeconds,
      'totalCalls': totalCalls,
    };
  }

  ConnectionStats copyWith({
    double? asr,
    double? asd,
    double? acd,
    double? cdr,
    double? mos,
    int? totalAttempts,
    int? successfulCalls,
    double? successRate,
    DateTime? lastCallTime,
    Duration? totalCallTime,
    int? totalCalls,
  }) {
    return ConnectionStats(
      asr: asr ?? this.asr,
      asd: asd ?? this.asd,
      acd: acd ?? this.acd,
      cdr: cdr ?? this.cdr,
      mos: mos ?? this.mos,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      successfulCalls: successfulCalls ?? this.successfulCalls,
      successRate: successRate ?? this.successRate,
      lastCallTime: lastCallTime ?? this.lastCallTime,
      totalCallTime: totalCallTime ?? this.totalCallTime,
      totalCalls: totalCalls ?? this.totalCalls,
    );
  }
} 