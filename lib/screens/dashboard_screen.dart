import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/gateway_status.dart';
import '../providers/gateway_provider.dart';
import '../widgets/status_card.dart';
import '../widgets/call_controls.dart';
import '../widgets/recent_logs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)?.appTitle ?? 'GSM-SIP Gateway',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Consumer<GatewayProvider>(
        builder: (context, provider, child) {
          final status = provider.status;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Cards
                Row(
                  children: [
                    Expanded(
                      child: StatusCard(
                        title: AppLocalizations.of(context)?.gatewayStatus ?? 'Gateway Status',
                        status: status.statusText,
                        icon: _getStatusIcon(status.state),
                        color: _getStatusColor(status.state),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatusCard(
                        title: AppLocalizations.of(context)?.sipConnection ?? 'SIP Connection',
                        status: status.isRegistered ? (AppLocalizations.of(context)?.registered ?? 'Registered') : (AppLocalizations.of(context)?.disconnected ?? 'Disconnected'),
                        icon: status.isRegistered ? Icons.check_circle : Icons.error,
                        color: status.isRegistered ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatusCard(
                        title: AppLocalizations.of(context)?.gsmConnection ?? 'GSM Connection',
                        status: status.isConnected ? (AppLocalizations.of(context)?.connected ?? 'Connected') : (AppLocalizations.of(context)?.disconnected ?? 'Disconnected'),
                        icon: status.isConnected ? Icons.phone_android : Icons.phone_disabled,
                        color: status.isConnected ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatusCard(
                        title: AppLocalizations.of(context)?.activeCalls ?? 'Active Calls',
                        status: status.currentCall != null ? (AppLocalizations.of(context)?.oneActive ?? '1 Active') : (AppLocalizations.of(context)?.noCalls ?? 'No Calls'),
                        icon: status.currentCall != null ? Icons.call : Icons.call_end,
                        color: status.currentCall != null ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Control Buttons
                CallControls(
                  isRunning: status.isRunning,
                  hasActiveCall: status.currentCall != null,
                  onStart: () => provider.startGateway(),
                  onStop: () => provider.stopGateway(),
                  onEndCall: () => provider.endCall(),
                ),
                const SizedBox(height: 24),

                // Recent Logs
                RecentLogs(
                  logs: provider.logs,
                  onViewAll: () {
                    Navigator.pushNamed(context, '/logs');
                  },
                ),
                const SizedBox(height: 16),

                // Test Buttons (for development)
                if (status.isRunning) ...[
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)?.testControls ?? 'Test Controls',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => provider.simulateSipCall('50015'),
                          icon: const Icon(Icons.call_received),
                          label: Text(AppLocalizations.of(context)?.testSipCall ?? 'Test SIP Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => provider.simulateGsmCall('+1234567890', CallDirection.outgoing),
                          icon: const Icon(Icons.call_made),
                          label: Text(AppLocalizations.of(context)?.testGsmCall ?? 'Test GSM Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getStatusIcon(GatewayState state) {
    switch (state) {
      case GatewayState.stopped:
        return Icons.stop_circle;
      case GatewayState.starting:
        return Icons.play_circle_outline;
      case GatewayState.running:
        return Icons.play_circle;
      case GatewayState.error:
        return Icons.error;
      case GatewayState.connecting:
        return Icons.sync;
      case GatewayState.registered:
        return Icons.check_circle;
      case GatewayState.callInProgress:
        return Icons.call;
    }
  }

  Color _getStatusColor(GatewayState state) {
    switch (state) {
      case GatewayState.stopped:
        return Colors.grey;
      case GatewayState.starting:
        return Colors.orange;
      case GatewayState.running:
        return Colors.blue;
      case GatewayState.error:
        return Colors.red;
      case GatewayState.connecting:
        return Colors.orange;
      case GatewayState.registered:
        return Colors.green;
      case GatewayState.callInProgress:
        return Colors.purple;
    }
  }
} 