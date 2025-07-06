import 'package:flutter/material.dart';
import '../utils/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          'Analytics',
          style: AppTextStyles.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              'Today',
              'Week',
              'Month',
              'Year',
            ].map((period) => PopupMenuItem(
              value: period,
              child: Text(period),
            )).toList(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue[400],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          tabs: [
            Tab(text: 'Calls'),
            Tab(text: 'Quality'),
            Tab(text: 'Usage'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCallsTab(),
          _buildQualityTab(),
          _buildUsageTab(),
        ],
      ),
    );
  }

  Widget _buildCallsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 24),
          _buildCallStats(),
          const SizedBox(height: 24),
          _buildCallChart(),
          const SizedBox(height: 24),
          _buildCallHistory(),
        ],
      ),
    );
  }

  Widget _buildQualityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 24),
          _buildQualityMetrics(),
          const SizedBox(height: 24),
          _buildQualityChart(),
          const SizedBox(height: 24),
          _buildQualityDetails(),
        ],
      ),
    );
  }

  Widget _buildUsageTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 24),
          _buildUsageStats(),
          const SizedBox(height: 24),
          _buildUsageChart(),
          const SizedBox(height: 24),
          _buildUsageDetails(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[600]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.blue[400],
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'Period: $_selectedPeriod',
            style: AppTextStyles.poppinsBold(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Calls',
            value: '156',
            icon: Icons.call,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Incoming',
            value: '89',
            icon: Icons.call_received,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Outgoing',
            value: '67',
            icon: Icons.call_made,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildCallChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Call Volume',
            style: AppTextStyles.poppinsBold(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            child: _buildMockChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildCallHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Calls',
            style: AppTextStyles.poppinsBold(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildCallHistoryItem('+1234567890', 'Incoming', '2 min ago', Colors.green),
          _buildCallHistoryItem('+0987654321', 'Outgoing', '5 min ago', Colors.orange),
          _buildCallHistoryItem('+1122334455', 'Incoming', '12 min ago', Colors.green),
        ],
      ),
    );
  }

  Widget _buildQualityMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Avg MOS',
            value: '4.2',
            icon: Icons.signal_cellular_alt,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Latency',
            value: '45ms',
            icon: Icons.speed,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Packet Loss',
            value: '0.2%',
            icon: Icons.warning,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildQualityChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quality Trends',
            style: AppTextStyles.poppinsBold(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            child: _buildMockChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quality Details',
            style: AppTextStyles.poppinsBold(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildQualityDetailItem('SIP MOS', '4.3', Colors.blue),
          _buildQualityDetailItem('GSM MOS', '4.1', Colors.green),
          _buildQualityDetailItem('SIP Latency', '42ms', Colors.orange),
          _buildQualityDetailItem('GSM Latency', '38ms', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildUsageStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Data Used',
            value: '2.4GB',
            icon: Icons.data_usage,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'SMS Sent',
            value: '45',
            icon: Icons.sms,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Balance',
            value: '\$12.50',
            icon: Icons.account_balance_wallet,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildUsageChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage Trends',
            style: AppTextStyles.poppinsBold(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            child: _buildMockChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage Details',
            style: AppTextStyles.poppinsBold(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildUsageDetailItem('Voice Calls', '2.1GB', Colors.blue),
          _buildUsageDetailItem('SMS Messages', '45', Colors.green),
          _buildUsageDetailItem('Data Transfer', '0.3GB', Colors.orange),
          _buildUsageDetailItem('Remaining', '\$12.50', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.poppinsBold(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.poppins(
              fontSize: 12,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMockChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Chart Placeholder',
          style: AppTextStyles.poppins(
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildCallHistoryItem(String number, String type, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            type == 'Incoming' ? Icons.call_received : Icons.call_made,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: AppTextStyles.poppinsBold(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  type,
                  style: AppTextStyles.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.poppins(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityDetailItem(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.poppins(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.poppinsBold(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageDetailItem(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.poppins(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.poppinsBold(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
} 