import 'package:flutter/foundation.dart';
import '../models/line_info.dart';
import '../models/connection_stats.dart';
import '../models/sip_connection.dart';
import '../models/active_call.dart';
import '../models/gateway_config.dart';
import '../services/storage_service.dart';

class DashboardProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  
  // Lines information
  List<LineInfo> _lines = [];
  bool _isLoadingLines = false;
  String? _linesError;

  // Connection statistics
  ConnectionStats? _connectionStats;
  bool _isLoadingStats = false;
  String? _statsError;

  // SIP connection
  SipConnection? _sipConnection;
  bool _isLoadingSip = false;
  String? _sipError;

  // Active calls
  List<ActiveCall> _activeCalls = [];
  bool _isLoadingCalls = false;
  String? _callsError;

  // Gateway configuration
  GatewayConfig? _config;
  bool _isLoadingConfig = false;
  String? _configError;

  // Device information
  Map<String, dynamic> _deviceInfo = {};
  bool _isLoadingDeviceInfo = false;
  String? _deviceInfoError;

  // Getters
  List<LineInfo> get lines => _lines;
  bool get isLoadingLines => _isLoadingLines;
  String? get linesError => _linesError;

  ConnectionStats? get connectionStats => _connectionStats;
  bool get isLoadingStats => _isLoadingStats;
  String? get statsError => _statsError;

  SipConnection? get sipConnection => _sipConnection;
  bool get isLoadingSip => _isLoadingSip;
  String? get sipError => _sipError;

  List<ActiveCall> get activeCalls => _activeCalls;
  bool get isLoadingCalls => _isLoadingCalls;
  String? get callsError => _callsError;

  GatewayConfig? get config => _config;
  bool get isLoadingConfig => _isLoadingConfig;
  String? get configError => _configError;

  Map<String, dynamic> get deviceInfo => _deviceInfo;
  bool get isLoadingDeviceInfo => _isLoadingDeviceInfo;
  String? get deviceInfoError => _deviceInfoError;

  // Computed properties
  int get activeLinesCount => _lines.where((line) => line.status == 'active').length;
  int get callingLinesCount => _lines.where((line) => line.status == 'calling').length;
  int get totalLinesCount => _lines.length;
  
  double get totalBalance => _lines.fold(0.0, (sum, line) => sum + line.balance);
  
  bool get hasActiveCalls => _activeCalls.isNotEmpty;
  int get activeCallsCount => _activeCalls.length;

  // Initialize provider
  Future<void> initialize() async {
    await Future.wait([
      loadLines(),
      loadConnectionStats(),
      loadSipConnection(),
      loadActiveCalls(),
      loadConfig(),
      loadDeviceInfo(),
    ]);
  }

  // Load lines information
  Future<void> loadLines() async {
    _isLoadingLines = true;
    _linesError = null;
    notifyListeners();

    try {
      // Simulate API call - replace with actual implementation
      await Future.delayed(const Duration(milliseconds: 500));
      
      _lines = [
        LineInfo(
          id: '1',
          phoneNumber: '+1234567890',
          imei: '123456789012345',
          operator: 'Operator A',
          technology: '4G',
          status: 'active',
          signalLevel: 85,
          lac: '1234',
          cellId: '5678',
          balance: 100.50,
          currency: 'USD',
          lastBalanceUpdate: DateTime.now(),
          isPhysical: true,
          slotNumber: 0,
          supportsDataDuringCall: true,
          supportsDataFromCallNumber: false,
          canChangeImei: true,
          canRecordVoiceToRadio: true,
          canGetVoiceFromRadio: true,
          canWriteToVoiceCommunication: true,
        ),
        LineInfo(
          id: '2',
          phoneNumber: '+0987654321',
          imei: '987654321098765',
          operator: 'Operator B',
          technology: '3G',
          status: 'inactive',
          signalLevel: 65,
          lac: '5678',
          cellId: '1234',
          balance: 75.25,
          currency: 'USD',
          lastBalanceUpdate: DateTime.now(),
          isPhysical: true,
          slotNumber: 1,
          supportsDataDuringCall: false,
          supportsDataFromCallNumber: false,
          canChangeImei: false,
          canRecordVoiceToRadio: false,
          canGetVoiceFromRadio: false,
          canWriteToVoiceCommunication: false,
        ),
      ];
    } catch (e) {
      _linesError = e.toString();
    } finally {
      _isLoadingLines = false;
      notifyListeners();
    }
  }

  // Load connection statistics
  Future<void> loadConnectionStats() async {
    _isLoadingStats = true;
    _statsError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      _connectionStats = ConnectionStats(
        asr: 85.5,
        asd: 2.3,
        acd: 180.0,
        cdr: 2.1,
        mos: 4.2,
        totalAttempts: 1250,
        successfulCalls: 1068,
        successRate: 85.4,
        lastCallTime: DateTime.now().subtract(const Duration(minutes: 15)),
        totalCallTime: const Duration(hours: 45, minutes: 30),
        totalCalls: 1068,
      );
    } catch (e) {
      _statsError = e.toString();
    } finally {
      _isLoadingStats = false;
      notifyListeners();
    }
  }

  // Load SIP connection
  Future<void> loadSipConnection() async {
    _isLoadingSip = true;
    _sipError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 400));
      
      _sipConnection = SipConnection(
        status: 'connected',
        server: 'sip.example.com',
        port: 5060,
        transport: 'UDP',
        lastRegistration: DateTime.now().subtract(const Duration(minutes: 5)),
        registrationExpiry: DateTime.now().add(const Duration(hours: 23, minutes: 55)),
        jitter: 15.2,
        latency: 45.8,
        bandwidthIn: 128.0,
        bandwidthOut: 128.0,
        packetLoss: 0.5,
        mos: 4.1,
        supportedCodecs: ['PCMU', 'PCMA', 'G729', 'G722'],
        activeCodecs: ['PCMU', 'G729'],
        username: 'user123',
        isRegistered: true,
      );
    } catch (e) {
      _sipError = e.toString();
    } finally {
      _isLoadingSip = false;
      notifyListeners();
    }
  }

  // Load active calls
  Future<void> loadActiveCalls() async {
    _isLoadingCalls = true;
    _callsError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      _activeCalls = [
        ActiveCall(
          id: 'call1',
          direction: 'incoming',
          fromNumber: '+1234567890',
          toNumber: '+0987654321',
          startTime: DateTime.now().subtract(const Duration(minutes: 3)),
          duration: const Duration(minutes: 3, seconds: 45),
          status: 'connected',
          lineId: '1',
          isSipSpeakerEnabled: false,
          isGsmSpeakerEnabled: true,
          isSipMicrophoneEnabled: true,
          isGsmMicrophoneEnabled: false,
          isRecording: false,
          recordingPath: '',
          sipMos: 4.2,
          gsmMos: 4.0,
          sipJitter: 12.5,
          gsmJitter: 8.3,
          sipLatency: 42.1,
          gsmLatency: 35.7,
        ),
      ];
    } catch (e) {
      _callsError = e.toString();
    } finally {
      _isLoadingCalls = false;
      notifyListeners();
    }
  }

  // Load configuration
  Future<void> loadConfig() async {
    _isLoadingConfig = true;
    _configError = null;
    notifyListeners();

    try {
      _config = await _storage.getConfig();
    } catch (e) {
      _configError = e.toString();
    } finally {
      _isLoadingConfig = false;
      notifyListeners();
    }
  }

  // Load device information
  Future<void> loadDeviceInfo() async {
    _isLoadingDeviceInfo = true;
    _deviceInfoError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      
      _deviceInfo = {
        'osVersion': 'Android 12',
        'hasRoot': true,
        'radioFirmware': 'v2.1.3',
        'serialNumber': 'SN123456789',
        'supports2G': true,
        'supports3G': true,
        'supports4G': true,
        'supports5G': false,
        'supportsVoLTE': true,
        'supportsVoWiFi': false,
        'maxActiveLines': 4,
        'maxPassiveLines': 8,
        'maxWaitingCalls': 10,
        'maxTransferCalls': 5,
        'physicalSimSlots': 2,
        'eSimProfiles': 1,
        'supportsRemoteSim': true,
      };
    } catch (e) {
      _deviceInfoError = e.toString();
    } finally {
      _isLoadingDeviceInfo = false;
      notifyListeners();
    }
  }

  // Update line status
  Future<void> updateLineStatus(String lineId, String status) async {
    final index = _lines.indexWhere((line) => line.id == lineId);
    if (index != -1) {
      _lines[index] = _lines[index].copyWith(status: status);
      notifyListeners();
    }
  }

  // Update line balance
  Future<void> updateLineBalance(String lineId, double balance) async {
    final index = _lines.indexWhere((line) => line.id == lineId);
    if (index != -1) {
      _lines[index] = _lines[index].copyWith(
        balance: balance,
        lastBalanceUpdate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Add active call
  void addActiveCall(ActiveCall call) {
    _activeCalls.add(call);
    notifyListeners();
  }

  // Remove active call
  void removeActiveCall(String callId) {
    _activeCalls.removeWhere((call) => call.id == callId);
    notifyListeners();
  }

  // Update active call
  void updateActiveCall(ActiveCall updatedCall) {
    final index = _activeCalls.indexWhere((call) => call.id == updatedCall.id);
    if (index != -1) {
      _activeCalls[index] = updatedCall;
      notifyListeners();
    }
  }

  // Refresh all data
  Future<void> refresh() async {
    await initialize();
  }
} 