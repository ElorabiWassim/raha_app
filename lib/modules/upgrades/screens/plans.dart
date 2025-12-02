import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  String selectedPlan = 'Pro';

  List<Map<String, dynamic>> _getPlans(AppLocalizations localizations) {
    return [
      {
        'name': localizations.plansFree,
        'price': localizations.plansFreePriceValue,
        'period': '',
        'features': [
          localizations.plansFreeFeature1,
          localizations.plansFreeFeature2,
          localizations.plansFreeFeature3,
          localizations.plansFreeFeature4,
        ],
        'isRecommended': false,
      },
      {
        'name': localizations.plansPro,
        'price': localizations.plansProPriceValue,
        'period': localizations.plansProPeriodValue,
        'features': [
          localizations.plansProFeature1,
          localizations.plansProFeature2,
          localizations.plansProFeature3,
          localizations.plansProFeature4,
          localizations.plansProFeature5,
        ],
        'isRecommended': true,
      },
      {
        'name': localizations.plansElite,
        'price': localizations.plansElitePriceValue,
        'period': localizations.plansElitePeriodValue,
        'features': [
          localizations.plansEliteFeature1,
          localizations.plansEliteFeature2,
          localizations.plansEliteFeature3,
          localizations.plansEliteFeature4,
          localizations.plansEliteFeature5,
          localizations.plansEliteFeature6,
          localizations.plansEliteFeature7,
          localizations.plansEliteFeature8,
        ],
        'isRecommended': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final plans = _getPlans(localizations);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9)),
              child: Row(
                children: [
                  const Icon(
                    Icons.credit_card,
                    color: Color(0xFF4CAF50),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    localizations.plansTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                ],
              ),
            ),

            // Plans List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return PlanCard(
                    name: plan['name'],
                    price: plan['price'],
                    period: plan['period'],
                    features: List<String>.from(plan['features']),
                    isRecommended: plan['isRecommended'],
                    isSelected: selectedPlan == plan['name'],
                    onTap: () {
                      setState(() {
                        selectedPlan = plan['name'];
                      });
                    },
                  );
                },
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
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          localizations.plansSelectedPlan(selectedPlan),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    localizations.plansUpgradeNow,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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

  const PlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.isRecommended,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                      localizations.plansRecommended,
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4CAF50),
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
