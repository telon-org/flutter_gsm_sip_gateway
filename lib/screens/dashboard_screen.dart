import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/text_styles.dart';
import '../providers/dashboard_provider.dart';
import '../providers/gateway_provider.dart';
import '../widgets/status_card.dart';
import '../widgets/line_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/active_call_card.dart';
import '../widgets/sip_status_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();

    // Initialize dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider.initialize();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
                  await dashboardProvider.refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildQuickStats(),
                          const SizedBox(height: 24),
                          _buildActiveCalls(),
                          const SizedBox(height: 24),
                          _buildLinesSection(),
                          const SizedBox(height: 24),
                          _buildSipStatus(),
                          const SizedBox(height: 24),
                          _buildConnectionStats(),
                          const SizedBox(height: 100), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.router,
              color: Colors.blue[400],
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.appTitle ?? 'GSM-SIP Gateway',
                  style: AppTextStyles.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    return Text(
                      '${provider.activeLinesCount} active lines • ${provider.activeCallsCount} calls',
                      style: AppTextStyles.poppins(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: Icon(
              Icons.settings,
              color: Colors.grey[400],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child:           _buildQuickStatCardWithTooltip(
            icon: Icons.phone,
            title: 'Active Lines',
            value: '${provider.activeLinesCount}',
            color: Colors.green,
            tooltip: 'Number of currently active phone lines (GSM/SIP)',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCardWithTooltip(
            icon: Icons.call,
            title: 'Active Calls',
            value: '${provider.activeCallsCount}',
            color: Colors.orange,
            tooltip: 'Number of calls currently in progress',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCardWithTooltip(
            icon: Icons.account_balance_wallet,
            title: 'Total Balance',
            value: '\$${provider.totalBalance.toStringAsFixed(2)}',
            color: Colors.blue,
            tooltip: 'Total available balance across all phone lines',
          ),
        ),
          ],
        );
      },
    );
  }

  Widget _buildQuickStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
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
            style: AppTextStyles.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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

  Widget _buildQuickStatCardWithTooltip({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
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
              style: AppTextStyles.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildActiveCalls() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingCalls) {
          return _buildLoadingCard();
        }

        if (provider.activeCalls.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.call_end,
                  size: 48,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 16),
                Text(
                  'No Active Calls',
                  style: AppTextStyles.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All lines are available for incoming calls',
                  style: AppTextStyles.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Calls',
              style: AppTextStyles.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...provider.activeCalls.map((call) => ActiveCallCard(call: call)),
          ],
        );
      },
    );
  }

  Widget _buildLinesSection() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingLines) {
          return _buildLoadingCard();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Phone Lines',
                  style: AppTextStyles.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${provider.activeLinesCount}/${provider.totalLinesCount}',
                  style: AppTextStyles.poppins(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...provider.lines.map((line) => LineCard(line: line)),
          ],
        );
      },
    );
  }

  Widget _buildSipStatus() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingSip) {
          return _buildLoadingCard();
        }

        if (provider.sipConnection == null) {
          return Container();
        }

        return SipStatusCard(connection: provider.sipConnection!);
      },
    );
  }

  Widget _buildConnectionStats() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingStats) {
          return _buildLoadingCard();
        }

        if (provider.connectionStats == null) {
          return Container();
        }

        return StatsCard(stats: provider.connectionStats!);
      },
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return FloatingActionButton.extended(
          onPressed: () {
            // Show call dialer or quick actions
            _showQuickActions(context);
          },
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_call),
          label: Text(
            'Quick Call',
            style: AppTextStyles.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isSelected: true,
            onTap: () {},
          ),
          _buildBottomNavItem(
            icon: Icons.analytics,
            label: 'Analytics',
            isSelected: false,
            onTap: () => Navigator.pushNamed(context, '/analytics'),
          ),
          _buildBottomNavItem(
            icon: Icons.phone,
            label: 'Lines',
            isSelected: false,
            onTap: () => Navigator.pushNamed(context, '/lines'),
          ),
          _buildBottomNavItem(
            icon: Icons.sim_card,
            label: 'SIMs',
            isSelected: false,
            onTap: () => Navigator.pushNamed(context, '/sims'),
          ),
          _buildBottomNavItem(
            icon: Icons.cell_tower,
            label: 'BS',
            isSelected: false,
            onTap: () => Navigator.pushNamed(context, '/base-stations'),
          ),
          _buildBottomNavItem(
            icon: Icons.audiotrack,
            label: 'Codecs',
            isSelected: false,
            onTap: () => Navigator.pushNamed(context, '/codecs'),
          ),
          _buildBottomNavItem(
            icon: Icons.sms,
            label: 'SMS',
            isSelected: false,
            onTap: () => Navigator.pushNamed(context, '/sms'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue[400] : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.poppins(
              fontSize: 12,
              color: isSelected ? Colors.blue[400] : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: AppTextStyles.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.call,
                    label: 'Make Call',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement call dialer
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.refresh,
                    label: 'Refresh',
                    onTap: () {
                      Navigator.pop(context);
                      final provider = Provider.of<DashboardProvider>(context, listen: false);
                      provider.refresh();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.analytics,
                    label: 'Analytics',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to analytics
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[700]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.blue[400],
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.poppins(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 