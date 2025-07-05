class GatewayConfig {
  final String sipUsername;
  final String sipPassword;
  final String sipServer;
  final int sipPort;
  final String transport;
  final int registrationTimeout;
  final bool autoStart;
  final bool replaceDialer;
  final bool enablePermissions;

  GatewayConfig({
    required this.sipUsername,
    required this.sipPassword,
    required this.sipServer,
    this.sipPort = 5060,
    this.transport = 'UDP',
    this.registrationTimeout = 3600,
    this.autoStart = false,
    this.replaceDialer = false,
    this.enablePermissions = false,
  });

  GatewayConfig copyWith({
    String? sipUsername,
    String? sipPassword,
    String? sipServer,
    int? sipPort,
    String? transport,
    int? registrationTimeout,
    bool? autoStart,
    bool? replaceDialer,
    bool? enablePermissions,
  }) {
    return GatewayConfig(
      sipUsername: sipUsername ?? this.sipUsername,
      sipPassword: sipPassword ?? this.sipPassword,
      sipServer: sipServer ?? this.sipServer,
      sipPort: sipPort ?? this.sipPort,
      transport: transport ?? this.transport,
      registrationTimeout: registrationTimeout ?? this.registrationTimeout,
      autoStart: autoStart ?? this.autoStart,
      replaceDialer: replaceDialer ?? this.replaceDialer,
      enablePermissions: enablePermissions ?? this.enablePermissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sipUsername': sipUsername,
      'sipPassword': sipPassword,
      'sipServer': sipServer,
      'sipPort': sipPort,
      'transport': transport,
      'registrationTimeout': registrationTimeout,
      'autoStart': autoStart,
      'replaceDialer': replaceDialer,
      'enablePermissions': enablePermissions,
    };
  }

  factory GatewayConfig.fromJson(Map<String, dynamic> json) {
    return GatewayConfig(
      sipUsername: json['sipUsername'] ?? '',
      sipPassword: json['sipPassword'] ?? '',
      sipServer: json['sipServer'] ?? '',
      sipPort: json['sipPort'] ?? 5060,
      transport: json['transport'] ?? 'UDP',
      registrationTimeout: json['registrationTimeout'] ?? 3600,
      autoStart: json['autoStart'] ?? false,
      replaceDialer: json['replaceDialer'] ?? false,
      enablePermissions: json['enablePermissions'] ?? false,
    );
  }

  factory GatewayConfig.defaultConfig() {
    return GatewayConfig(
      sipUsername: '',
      sipPassword: '',
      sipServer: '192.168.88.254',
      sipPort: 5060,
      transport: 'UDP',
      registrationTimeout: 3600,
      autoStart: false,
      replaceDialer: false,
      enablePermissions: false,
    );
  }
} 