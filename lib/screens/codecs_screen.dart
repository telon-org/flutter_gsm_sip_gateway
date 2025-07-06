import 'package:flutter/material.dart';
import '../utils/text_styles.dart';

class CodecInfo {
  final String name;
  final String fullName;
  final String description;
  final String bitrate;
  final String sampleRate;
  final bool isClientSupported;
  final bool isServerSupported;
  final bool isActive;
  final String priority;
  final String quality;

  CodecInfo({
    required this.name,
    required this.fullName,
    required this.description,
    required this.bitrate,
    required this.sampleRate,
    required this.isClientSupported,
    required this.isServerSupported,
    required this.isActive,
    required this.priority,
    required this.quality,
  });

  bool get isCompatible => isClientSupported && isServerSupported;
  bool get isPreferred => isActive && isCompatible;
}

class CodecsScreen extends StatefulWidget {
  const CodecsScreen({Key? key}) : super(key: key);

  @override
  State<CodecsScreen> createState() => _CodecsScreenState();
}

class _CodecsScreenState extends State<CodecsScreen> {
  List<CodecInfo> codecs = [];
  String selectedFilter = 'All';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCodecs();
  }

  void _loadCodecs() {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        codecs = [
          CodecInfo(
            name: 'PCMU',
            fullName: 'PCM μ-law',
            description: 'Standard 64 kbps codec, widely supported',
            bitrate: '64 kbps',
            sampleRate: '8 kHz',
            isClientSupported: true,
            isServerSupported: true,
            isActive: true,
            priority: '1',
            quality: 'Excellent',
          ),
          CodecInfo(
            name: 'PCMA',
            fullName: 'PCM A-law',
            description: 'Standard 64 kbps codec, European standard',
            bitrate: '64 kbps',
            sampleRate: '8 kHz',
            isClientSupported: true,
            isServerSupported: true,
            isActive: true,
            priority: '2',
            quality: 'Excellent',
          ),
          CodecInfo(
            name: 'G729',
            fullName: 'G.729',
            description: 'Low bitrate codec, good quality at 8 kbps',
            bitrate: '8 kbps',
            sampleRate: '8 kHz',
            isClientSupported: true,
            isServerSupported: true,
            isActive: true,
            priority: '3',
            quality: 'Good',
          ),
          CodecInfo(
            name: 'G722',
            fullName: 'G.722',
            description: 'Wideband codec, better voice quality',
            bitrate: '64 kbps',
            sampleRate: '16 kHz',
            isClientSupported: true,
            isServerSupported: false,
            isActive: false,
            priority: '4',
            quality: 'Excellent',
          ),
          CodecInfo(
            name: 'G723.1',
            fullName: 'G.723.1',
            description: 'Very low bitrate codec',
            bitrate: '5.3/6.3 kbps',
            sampleRate: '8 kHz',
            isClientSupported: false,
            isServerSupported: true,
            isActive: false,
            priority: '5',
            quality: 'Fair',
          ),
          CodecInfo(
            name: 'AMR',
            fullName: 'Adaptive Multi-Rate',
            description: 'GSM mobile codec, variable bitrate',
            bitrate: '4.75-12.2 kbps',
            sampleRate: '8 kHz',
            isClientSupported: true,
            isServerSupported: false,
            isActive: false,
            priority: '6',
            quality: 'Good',
          ),
          CodecInfo(
            name: 'OPUS',
            fullName: 'Opus',
            description: 'Modern codec, excellent quality and efficiency',
            bitrate: '6-510 kbps',
            sampleRate: '8-48 kHz',
            isClientSupported: false,
            isServerSupported: false,
            isActive: false,
            priority: '7',
            quality: 'Excellent',
          ),
          CodecInfo(
            name: 'G726',
            fullName: 'G.726',
            description: 'ADPCM codec, legacy support',
            bitrate: '16-40 kbps',
            sampleRate: '8 kHz',
            isClientSupported: true,
            isServerSupported: true,
            isActive: false,
            priority: '8',
            quality: 'Good',
          ),
        ];
        isLoading = false;
      });
    });
  }

  List<CodecInfo> get filteredCodecs {
    switch (selectedFilter) {
      case 'All':
        return codecs;
      case 'Compatible':
        return codecs.where((codec) => codec.isCompatible).toList();
      case 'Active':
        return codecs.where((codec) => codec.isActive).toList();
      case 'Client Only':
        return codecs.where((codec) => codec.isClientSupported && !codec.isServerSupported).toList();
      case 'Server Only':
        return codecs.where((codec) => !codec.isClientSupported && codec.isServerSupported).toList();
      case 'Not Supported':
        return codecs.where((codec) => !codec.isClientSupported && !codec.isServerSupported).toList();
      default:
        return codecs;
    }
  }

  Color _getCompatibilityColor(CodecInfo codec) {
    if (codec.isPreferred) return Colors.green;
    if (codec.isCompatible) return Colors.blue;
    if (codec.isClientSupported || codec.isServerSupported) return Colors.orange;
    return Colors.red;
  }

  Color _getQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      case 'poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final compatibleCount = codecs.where((c) => c.isCompatible).length;
    final activeCount = codecs.where((c) => c.isActive).length;
    final clientOnlyCount = codecs.where((c) => c.isClientSupported && !c.isServerSupported).length;
    final serverOnlyCount = codecs.where((c) => !c.isClientSupported && c.isServerSupported).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.audiotrack,
              color: Colors.blue[400],
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Codecs',
              style: AppTextStyles.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadCodecs,
            icon: Icon(
              Icons.refresh,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsCards(compatibleCount, activeCount, clientOnlyCount, serverOnlyCount),
          _buildFilterChips(),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                : _buildCodecsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(int compatible, int active, int clientOnly, int serverOnly) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCardWithTooltip(
              icon: Icons.check_circle,
              title: 'Compatible',
              value: '$compatible',
              color: Colors.green,
              tooltip: 'Codecs supported by both client and server',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCardWithTooltip(
              icon: Icons.play_circle,
              title: 'Active',
              value: '$active',
              color: Colors.blue,
              tooltip: 'Currently active codecs in use',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCardWithTooltip(
              icon: Icons.phone_android,
              title: 'Client Only',
              value: '$clientOnly',
              color: Colors.orange,
              tooltip: 'Codecs supported only by client',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCardWithTooltip(
              icon: Icons.dns,
              title: 'Server Only',
              value: '$serverOnly',
              color: Colors.purple,
              tooltip: 'Codecs supported only by server',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardWithTooltip({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppTextStyles.poppins(
                fontSize: 10,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Compatible', 'Active', 'Client Only', 'Server Only', 'Not Supported'];
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: AppTextStyles.poppins(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              backgroundColor: const Color(0xFF2A2A2A),
              selectedColor: Colors.blue[600],
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? Colors.blue[600]! : Colors.grey[700]!,
                width: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCodecsList() {
    if (filteredCodecs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.audiotrack_outlined,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No codecs found',
              style: AppTextStyles.poppins(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredCodecs.length,
      itemBuilder: (context, index) {
        final codec = filteredCodecs[index];
        return _buildCodecCard(codec);
      },
    );
  }

  Widget _buildCodecCard(CodecInfo codec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getCompatibilityColor(codec).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCompatibilityColor(codec).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.audiotrack,
            color: _getCompatibilityColor(codec),
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    codec.name,
                    style: AppTextStyles.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    codec.fullName,
                    style: AppTextStyles.poppins(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            if (codec.isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ACTIVE',
                  style: AppTextStyles.poppins(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _buildSupportChip(
                label: 'Client',
                isSupported: codec.isClientSupported,
                tooltip: 'Supported by client device',
              ),
              const SizedBox(width: 8),
              _buildSupportChip(
                label: 'Server',
                isSupported: codec.isServerSupported,
                tooltip: 'Supported by SIP server',
              ),
              const SizedBox(width: 8),
              _buildQualityChip(
                quality: codec.quality,
                tooltip: 'Voice quality rating',
              ),
            ],
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Description', codec.description),
                _buildDetailRow('Bitrate', codec.bitrate),
                _buildDetailRow('Sample Rate', codec.sampleRate),
                _buildDetailRow('Priority', codec.priority),
                _buildDetailRow('Quality', codec.quality),
                _buildDetailRow('Compatible', codec.isCompatible ? 'Yes' : 'No'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: codec.isCompatible ? () {
                          // TODO: Set as preferred codec
                        } : null,
                        icon: const Icon(Icons.star, size: 16),
                        label: Text(
                          'Set Preferred',
                          style: AppTextStyles.poppins(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Show codec details
                        },
                        icon: const Icon(Icons.info, size: 16),
                        label: Text(
                          'Details',
                          style: AppTextStyles.poppins(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportChip({
    required String label,
    required bool isSupported,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSupported ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSupported ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSupported ? Icons.check : Icons.close,
              size: 12,
              color: isSupported ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.poppins(
                fontSize: 10,
                color: isSupported ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityChip({
    required String quality,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getQualityColor(quality).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getQualityColor(quality).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          quality,
          style: AppTextStyles.poppins(
            fontSize: 10,
            color: _getQualityColor(quality),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.poppins(
                fontSize: 12,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.poppins(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 