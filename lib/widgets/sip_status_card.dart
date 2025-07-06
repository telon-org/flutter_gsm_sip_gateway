import 'package:flutter/material.dart';
import '../utils/text_styles.dart';
import '../models/sip_connection.dart';

class SipStatusCard extends StatelessWidget {
  final SipConnection connection;

  const SipStatusCard({
    Key? key,
    required this.connection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(connection.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(connection.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(connection.status),
                  color: _getStatusColor(connection.status),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIP Connection',
                      style: AppTextStyles.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getStatusText(connection.status),
                      style: AppTextStyles.poppins(
                        fontSize: 12,
                        color: _getStatusColor(connection.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (connection.isRegistered)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Registered',
                    style: AppTextStyles.poppins(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  label: 'Server',
                  value: connection.server,
                  icon: Icons.dns,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  label: 'Port',
                  value: '${connection.port}',
                  icon: Icons.settings_ethernet,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  label: 'Transport',
                  value: connection.transport,
                  icon: Icons.network_check,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Connection Quality',
            style: AppTextStyles.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQualityMetric(
                  label: 'MOS',
                  value: connection.mos.toStringAsFixed(1),
                  color: _getMosColor(connection.mos),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQualityMetric(
                  label: 'Jitter',
                  value: '${connection.jitter.toStringAsFixed(1)}ms',
                  color: _getJitterColor(connection.jitter),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQualityMetric(
                  label: 'Latency',
                  value: '${connection.latency.toStringAsFixed(1)}ms',
                  color: _getLatencyColor(connection.latency),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQualityMetric(
                  label: 'Packet Loss',
                  value: '${connection.packetLoss.toStringAsFixed(1)}%',
                  color: _getPacketLossColor(connection.packetLoss),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  label: 'Bandwidth In',
                  value: '${connection.bandwidthIn.toStringAsFixed(0)} kbps',
                  icon: Icons.download,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  label: 'Bandwidth Out',
                  value: '${connection.bandwidthOut.toStringAsFixed(0)} kbps',
                  icon: Icons.upload,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Codecs',
            style: AppTextStyles.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...connection.activeCodecs.map((codec) => _buildCodecChip(
                codec,
                isActive: true,
              )),
              ...connection.supportedCodecs
                  .where((codec) => !connection.activeCodecs.contains(codec))
                  .map((codec) => _buildCodecChip(
                    codec,
                    isActive: false,
                  )),
            ],
          ),
          if (connection.isRegistered) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    label: 'Last Registration',
                    value: _formatDateTime(connection.lastRegistration),
                    icon: Icons.schedule,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    label: 'Expires',
                    value: _formatDateTime(connection.registrationExpiry),
                    icon: Icons.timer,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.poppins(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.poppins(
            fontSize: 12,
            color: Colors.grey[300],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQualityMetric({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.poppins(
              fontSize: 10,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodecChip(String codec, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.blue.withOpacity(0.2)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive 
              ? Colors.blue.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        codec,
        style: AppTextStyles.poppins(
          fontSize: 10,
          color: isActive ? Colors.blue : Colors.grey[400],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'connected':
        return Icons.check_circle;
      case 'connecting':
        return Icons.sync;
      case 'disconnected':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'connected':
        return Colors.green;
      case 'connecting':
        return Colors.orange;
      case 'disconnected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'connected':
        return 'Connected';
      case 'connecting':
        return 'Connecting...';
      case 'disconnected':
        return 'Disconnected';
      default:
        return 'Unknown';
    }
  }

  Color _getMosColor(double mos) {
    if (mos >= 4.0) return Colors.green;
    if (mos >= 3.0) return Colors.orange;
    return Colors.red;
  }

  Color _getJitterColor(double jitter) {
    if (jitter <= 20) return Colors.green;
    if (jitter <= 50) return Colors.orange;
    return Colors.red;
  }

  Color _getLatencyColor(double latency) {
    if (latency <= 100) return Colors.green;
    if (latency <= 200) return Colors.orange;
    return Colors.red;
  }

  Color _getPacketLossColor(double packetLoss) {
    if (packetLoss <= 1.0) return Colors.green;
    if (packetLoss <= 5.0) return Colors.orange;
    return Colors.red;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 