import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class DemandsPage extends StatefulWidget {
  const DemandsPage({super.key});

  @override
  State<DemandsPage> createState() => _DemandsPageState();
}

class _DemandsPageState extends State<DemandsPage> {
  String? selectedCategory;
  String? selectedWilaya;

  // Hardcoded job data (not localized – dynamic content)
  final List<Map<String, String>> jobs = [
    {
      'title': 'Leaky Kitchen Faucet Repair',
      'description': 'The faucet has been dripping. Needs fixing or replacement.',
      'location': 'Algiers',
      'time': '2h ago',
      'category': 'Plumbing',
    },
    {
      'title': 'Garden Weeding and Cleanup',
      'description': 'Looking for help with general garden maintenance.',
      'location': 'Oran',
      'time': '5h ago',
      'category': 'Gardening',
    },
    {
      'title': 'Fix Broken Light Switch',
      'description': 'Light switch not working. Need certified electrician.',
      'location': 'Constantine',
      'time': '1d ago',
      'category': 'Electrical',
    },
  ];

  // Static filter options – we’ll localize their display names
  final List<String> categories = ['Plumbing', 'Electrical', 'Gardening', 'Cleaning'];
  final List<String> wilayas = ['Algiers', 'Oran', 'Constantine', 'Annaba'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Filter jobs (optional: you can add real filtering later)
    final filteredJobs = jobs; // TODO: apply selectedCategory & selectedWilaya

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9)),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.work, color: Color(0xFF4CAF50), size: 28),
                      const SizedBox(width: 12),
                      Text(
                        l10n.openJobs, // ← LOCALIZED
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF388E3C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchJobs, // ← LOCALIZED
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF6B7280),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filters
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(l10n.category), // ← LOCALIZED
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(_getLocalizedCategory(category, l10n)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: DropdownButton<String>(
                            value: selectedWilaya,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(l10n.wilaya), // ← LOCALIZED
                            items: wilayas.map((wilaya) {
                              return DropdownMenuItem(
                                value: wilaya,
                                child: Text(wilaya), // Wilaya names stay as-is (proper nouns)
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedWilaya = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Jobs List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index];
                  return JobCard(
                    title: job['title']!,
                    description: job['description']!,
                    location: job['location']!,
                    time: job['time']!,
                    l10n: l10n,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 
  String _getLocalizedCategory(String category, AppLocalizations l10n) {
    switch (category) {
      case 'Plumbing': return l10n.plumbing;
      case 'Electrical': return l10n.electrical;
      case 'Gardening': return l10n.gardening;
      case 'Cleaning': return l10n.cleaning;
      default: return category;
    }
  }
}

class JobCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String time;
  final AppLocalizations l10n;

  const JobCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            softWrap: true,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(
                '${l10n.posted} $time', // ← LOCALIZED prefix
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.offerSent)), // ← LOCALIZED
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                l10n.sendOffer, // ← LOCALIZED
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}