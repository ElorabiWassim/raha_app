import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../../../services/api_service.dart';
import '../../../utils/plan_localizer.dart';
class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  // Store the actual Plan ID from the backend
  String? _selectedPlanId;
  List<dynamic> _plans = [];
  bool _isLoading = true;
  bool _isUpgrading = false;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final plansData = await ApiService().getSubscriptionPlans();
      
      if (!mounted) return;
      setState(() {
        _plans = plansData;
        _isLoading = false;
        
        // Optional: Set default selected plan (e.g., the first one or the user's current plan)
        if (_plans.isNotEmpty && _selectedPlanId == null) {
          _selectedPlanId = _plans[0]['id']?.toString(); 
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _handleUpgrade(AppLocalizations l10n) async {
    if (_selectedPlanId == null) return;

    setState(() => _isUpgrading = true);

    try {
      await ApiService().subscribeToPlan(_selectedPlanId!);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.subscriptionSuccess),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
      // Optional: Refresh provider data or navigate back
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isUpgrading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9)),
              child: Row(
                children: [
                  const Icon(Icons.credit_card, color: Color(0xFF4CAF50), size: 28),
                  const SizedBox(width: 12),
                  Text(
                    l10n.plansTitle, // Localized Title
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                ],
              ),
            ),

           
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadPlans,
                color: const Color(0xFF4CAF50),
                child: _plans.isEmpty 
                  ? Center(child: Text(l10n.failedToLoadPlans))
                  : ListView.builder(
  itemCount: _plans.length,
  itemBuilder: (context, index) {
    final plan = _plans[index];
    final String planId = plan['id']?.toString() ?? '';
    
    // Initialize helper
    final localizer = PlanLocalizer(l10n);

    // Get Localized Data based on ID
    final String localizedName = localizer.getName(planId);
    final List<String> localizedFeatures = localizer.getFeatures(planId);
    
    // Fallback: If arb is empty, use backend text (optional)
    final featuresToShow = localizedFeatures.isNotEmpty 
        ? localizedFeatures 
        : List<String>.from(plan['features'] ?? []);

    return PlanCard(
      name: localizedName, // Use localized name
      price: '${plan['price'] ?? 0} DA', 
      period: plan['period'] ?? '',
      features: featuresToShow, // Use localized features
      isRecommended: plan['is_recommended'] ?? false,
      isSelected: _selectedPlanId == planId,
      l10n: l10n,
      onTap: () {
         setState(() => _selectedPlanId = planId);
      },
    );
  },
)
              ),
            ),

            // Upgrade Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isUpgrading || _selectedPlanId == null) 
                      ? null 
                      : () => _handleUpgrade(l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: _isUpgrading
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : Text(
                          l10n.upgradeNow, // Localized Button
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool isRecommended;
  final bool isSelected;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.isRecommended,
    required this.isSelected,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.1 : 0.05),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Name and Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                if (isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      l10n.recommended, // Localized "Recommended"
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Price Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4CAF50),
                          fontFamily: 'Roboto', // Ensure font consistency
                        ),
                      ),
                      TextSpan(
                        text: l10n.perMonth, // Localized "/month"
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (period.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      period,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Features List
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}