import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/gateway_config.dart';
import '../models/gateway_status.dart';
import '../services/gateway_service.dart';
import '../services/storage_service.dart';

class GatewayProvider extends ChangeNotifier {
  final GatewayService _gatewayService = GatewayService();
  final StorageService _storageService = StorageService();

  GatewayStatus _status = GatewayStatus(
    state: GatewayState.stopped,
    isConnected: false,
    isRegistered: false,
    lastUpdate: DateTime.now(),
  );

  GatewayConfig? _config;
  List<String> _logs = [];
  bool _isInitialized = false;

  GatewayStatus get status => _status;
  GatewayConfig? get config => _config;
  List<String> get logs => _logs;
  bool get isInitialized => _isInitialized;

  StreamSubscription<GatewayStatus>? _statusSubscription;
  StreamSubscription<String>? _logSubscription;

  GatewayProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Load configuration
      _config = await _storageService.getConfig();
      
      // Subscribe to status updates
      _statusSubscription = _gatewayService.statusStream.listen((status) {
        _status = status;
        notifyListeners();
      });

      // Subscribe to log updates
      _logSubscription = _gatewayService.logStream.listen((log) {
        _logs.add(log);
        if (_logs.length > 100) {
          _logs.removeAt(0);
        }
        _storageService.addLog(log);
        notifyListeners();
      });

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing gateway provider: $e');
    }
  }

  Future<void> updateConfig(GatewayConfig config) async {
    _config = config;
    await _storageService.saveConfig(config);
    notifyListeners();
  }

  Future<void> startGateway() async {
    if (_config == null) {
      throw Exception('Gateway not configured');
    }

    try {
      await _gatewayService.initialize(_config!);
      await _gatewayService.start();
    } catch (e) {
      print('Error starting gateway: $e');
      rethrow;
    }
  }

  Future<void> stopGateway() async {
    try {
      await _gatewayService.stop();
    } catch (e) {
      print('Error stopping gateway: $e');
      rethrow;
    }
  }

  Future<void> endCall() async {
    try {
      await _gatewayService.endCall();
    } catch (e) {
      print('Error ending call: $e');
      rethrow;
    }
  }

  Future<void> simulateSipCall(String number) async {
    try {
      await _gatewayService.handleSipCall(number);
    } catch (e) {
      print('Error simulating SIP call: $e');
      rethrow;
    }
  }

  Future<void> simulateGsmCall(String number, CallDirection direction) async {
    try {
      await _gatewayService.handleGsmCall(number, direction);
    } catch (e) {
      print('Error simulating GSM call: $e');
      rethrow;
    }
  }

  Future<void> clearLogs() async {
    _logs.clear();
    await _storageService.clearLogs();
    notifyListeners();
  }

  Future<List<String>> loadStoredLogs() async {
    return await _storageService.loadLogs();
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    _logSubscription?.cancel();
    _gatewayService.dispose();
    super.dispose();
  }
} 