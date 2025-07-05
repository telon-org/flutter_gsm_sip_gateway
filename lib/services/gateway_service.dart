import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import '../models/gateway_config.dart';
import '../models/gateway_status.dart';

class GatewayService {
  static final GatewayService _instance = GatewayService._internal();
  factory GatewayService() => _instance;
  GatewayService._internal();

  final Logger _logger = Logger();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  GatewayConfig? _config;
  GatewayStatus _status = GatewayStatus(
    state: GatewayState.stopped,
    isConnected: false,
    isRegistered: false,
    lastUpdate: DateTime.now(),
  );

  final StreamController<GatewayStatus> _statusController = 
      StreamController<GatewayStatus>.broadcast();
  final StreamController<String> _logController = 
      StreamController<String>.broadcast();

  Stream<GatewayStatus> get statusStream => _statusController.stream;
  Stream<String> get logStream => _logController.stream;
  GatewayStatus get currentStatus => _status;

  // Simulated SIP and GSM endpoints
  bool _sipConnected = false;
  bool _sipRegistered = false;
  bool _gsmConnected = false;
  CallInfo? _currentCall;

  Future<void> initialize(GatewayConfig config) async {
    _config = config;
    _log('Initializing gateway with config: ${config.sipUsername}@${config.sipServer}');
    
    await _updateStatus(GatewayState.starting);
    
    try {
      // Get device info for configuration
      final deviceId = await _getDeviceId();
      _log('Device ID: $deviceId');
      
      // Initialize endpoints
      await _initializeSip();
      await _initializeGsm();
      
      await _updateStatus(GatewayState.running);
      _log('Gateway initialized successfully');
    } catch (e) {
      _log('Error initializing gateway: $e');
      await _updateStatus(GatewayState.error, errorMessage: e.toString());
    }
  }

  Future<void> start() async {
    if (_config == null) {
      throw Exception('Gateway not configured');
    }
    
    _log('Starting gateway...');
    await _updateStatus(GatewayState.starting);
    
    try {
      // Simulate SIP registration
      await _registerSip();
      
      // Simulate GSM connection
      await _connectGsm();
      
      await _updateStatus(GatewayState.registered);
      _log('Gateway started successfully');
    } catch (e) {
      _log('Error starting gateway: $e');
      await _updateStatus(GatewayState.error, errorMessage: e.toString());
    }
  }

  Future<void> stop() async {
    _log('Stopping gateway...');
    
    // Simulate cleanup
    _sipConnected = false;
    _sipRegistered = false;
    _gsmConnected = false;
    _currentCall = null;
    
    await _updateStatus(GatewayState.stopped);
    _log('Gateway stopped');
  }

  Future<void> handleSipCall(String number) async {
    _log('SIP call received: $number');
    
    if (_currentCall != null) {
      _log('Call already in progress, rejecting new call');
      return;
    }

    _currentCall = CallInfo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      number: number,
      direction: CallDirection.incoming,
      state: CallState.ringing,
      startTime: DateTime.now(),
      sipCallId: 'sip_${DateTime.now().millisecondsSinceEpoch}',
    );

    await _updateStatus(GatewayState.callInProgress, currentCall: _currentCall);
    
    // Simulate GSM call initiation
    await _initiateGsmCall(number);
  }

  Future<void> handleGsmCall(String number, CallDirection direction) async {
    _log('GSM call: $number ($direction)');
    
    if (direction == CallDirection.incoming) {
      _log('Rejecting incoming GSM call for security');
      return;
    }

    _currentCall = CallInfo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      number: number,
      direction: direction,
      state: CallState.connecting,
      startTime: DateTime.now(),
      gsmCallId: 'gsm_${DateTime.now().millisecondsSinceEpoch}',
    );

    await _updateStatus(GatewayState.callInProgress, currentCall: _currentCall);
  }

  Future<void> endCall() async {
    if (_currentCall == null) return;
    
    _log('Ending call: ${_currentCall!.number}');
    
    final endedCall = _currentCall!.copyWith(
      state: CallState.disconnected,
      endTime: DateTime.now(),
    );
    
    // Add to recent calls
    final recentCalls = List<CallInfo>.from(_status.recentCalls);
    recentCalls.insert(0, endedCall);
    if (recentCalls.length > 10) {
      recentCalls.removeLast();
    }
    
    _currentCall = null;
    
    await _updateStatus(
      _sipRegistered ? GatewayState.registered : GatewayState.running,
      recentCalls: recentCalls,
    );
  }

  Future<String> _getDeviceId() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.id;
    }
    return 'unknown';
  }

  Future<void> _initializeSip() async {
    _log('Initializing SIP endpoint...');
    await Future.delayed(Duration(seconds: 1));
    _sipConnected = true;
    _log('SIP endpoint initialized');
  }

  Future<void> _initializeGsm() async {
    _log('Initializing GSM endpoint...');
    await Future.delayed(Duration(seconds: 1));
    _gsmConnected = true;
    _log('GSM endpoint initialized');
  }

  Future<void> _registerSip() async {
    _log('Registering with SIP server...');
    await Future.delayed(Duration(seconds: 2));
    _sipRegistered = true;
    _log('SIP registration successful');
  }

  Future<void> _connectGsm() async {
    _log('Connecting to GSM network...');
    await Future.delayed(Duration(seconds: 1));
    _gsmConnected = true;
    _log('GSM connection established');
  }

  Future<void> _initiateGsmCall(String number) async {
    _log('Initiating GSM call to: $number');
    await Future.delayed(Duration(seconds: 1));
    
    if (_currentCall != null) {
      _currentCall = _currentCall!.copyWith(
        state: CallState.connecting,
        gsmCallId: 'gsm_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _updateStatus(GatewayState.callInProgress, currentCall: _currentCall);
    }
  }

  Future<void> _updateStatus(
    GatewayState state, {
    String? errorMessage,
    CallInfo? currentCall,
    List<CallInfo>? recentCalls,
  }) async {
    _status = _status.copyWith(
      state: state,
      isConnected: _sipConnected || _gsmConnected,
      isRegistered: _sipRegistered,
      errorMessage: errorMessage,
      currentCall: currentCall ?? _status.currentCall,
      recentCalls: recentCalls ?? _status.recentCalls,
      lastUpdate: DateTime.now(),
    );
    
    _statusController.add(_status);
  }

  void _log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] $message';
    _logger.i(logMessage);
    _logController.add(logMessage);
  }

  void dispose() {
    _statusController.close();
    _logController.close();
  }
} 