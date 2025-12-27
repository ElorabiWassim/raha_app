import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import 'package:ra7a/services/api_service.dart';

class DemandsPage extends StatefulWidget {
  const DemandsPage({super.key});

  @override
  State<DemandsPage> createState() => _DemandsPageState();
}

class _DemandsPageState extends State<DemandsPage> {
  String? selectedCategory;
  String? selectedWilaya;
  String? _searchQuery;
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> jobs = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  
  final List<Map<String, String>> categories = [
    {'id': 'a75af59d-3e61-402d-9bd2-54a5e64fc950', 'name': 'Plumbing'},
    {'id': '069dc664-5fd9-435c-a688-cc002e46243b', 'name': 'Electrical'},
    {'id': '3e53048d-1367-4e9f-ac4e-e39e5936dc0e', 'name': 'Gardening'},
    {'id': '6ca0c6a3-efa3-481e-b40a-a173bbcdb283', 'name': 'Cleaning'},
  ];

  final List<String> wilayas = [
    'Algiers',
    'Oran',
    'Constantine',
    'Annaba',
    'Blida',
    'Batna',
    'Sétif',
    'Sidi Bel Abbès',
  ];

  @override
  void initState() {
    super.initState();
    _loadDemands();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDemands() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> response;
       if (_searchController.text.isNotEmpty) {
        response = await _apiService.searchDemands(
          query: _searchController.text,
        );
      }
      // Load based on selected filters
      else if (selectedWilaya != null) {
        response = await _apiService.getDemandsByWilaya(
          wilaya: selectedWilaya!,
        );
      } else if (selectedCategory != null) {
        response = await _apiService.getDemandsByCategory(
          categoryId: selectedCategory!,
        );
      } else {
        response = await _apiService.getDemands();
      }

      // Convert backend data to your format
      final demands = response['demands'] as List;
      setState(() {
        jobs = demands.map((d) {
          return {
            'demand_id': d['demand_id'],
            'title': d['title'] ?? 'Untitled',
            'description': d['description'] ?? 'No description',
            'location': d['location'] ?? 'Unknown',
            'time': _formatTime(d['created_at']),
            'category': d['service_categories']?['name'] ?? 'Unknown',
            'homeowner_name':
                d['homeowners']?['users']?['full_name'] ?? 'Anonymous',
            'home_address': d['homeowners']?['home_address'] ?? 'Not specified',
            'images': d['demand_images'] ?? [],
            'created_at': d['created_at'],
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading demands: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load demands: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null) return 'Unknown';

    try {
      final created = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(created);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${(difference.inDays / 7).floor()}w ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getLocalizedCategory(String category, AppLocalizations l10n) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return l10n.plumbing;
      case 'electrical':
        return l10n.electrical;
      case 'gardening':
        return l10n.gardening;
      case 'cleaning':
        return l10n.cleaning;
      default:
        return category;
    }
  }

  Future<void> _onRefresh() async {
    await _loadDemands();
  }

  void _clearFilters() {
    setState(() {
      selectedCategory = null;
      selectedWilaya = null;
      _searchQuery = null;
    });
    _loadDemands();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.work,
                            color: Color(0xFF4CAF50),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.openJobs,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388E3C),
                            ),
                          ),
                        ],
                      ),
                      if (selectedCategory != null || selectedWilaya != null)
                        TextButton.icon(
                          onPressed: _clearFilters,
                          icon: const Icon(
                            Icons.clear,
                            size: 18,
                            color: Color(0xFF4CAF50),
                          ),
                          label: const Text(
                            'Clear',
                            style: TextStyle(color: Color(0xFF4CAF50)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchJobs,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF6B7280),
                      ),
                      
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = null;
                                });
                                _loadDemands(); // Reload all
                              },
                            )
                          : null,
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
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _searchQuery = value;
                        });
                        _loadDemands(); // Trigger search
                      } else {
                         // If empty, reload normal list
                         setState(() {
                          _searchQuery = null;
                        });
                        _loadDemands();
                      }
                    },
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
                            hint: Text(l10n.category),
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category['id'],
                                child: Text(
                                  _getLocalizedCategory(
                                    category['name']!,
                                    l10n,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                                selectedWilaya = null; // Clear wilaya filter
                              });
                              _loadDemands();
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
                            hint: Text(l10n.wilaya),
                            items: wilayas.map((wilaya) {
                              return DropdownMenuItem(
                                value: wilaya,
                                child: Text(wilaya),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedWilaya = value;
                                selectedCategory =
                                    null; // Clear category filter
                              });
                              _loadDemands();
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
              child: RefreshIndicator(
                color: const Color(0xFF4CAF50),
                onRefresh: _onRefresh,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      )
                    : jobs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.work_off_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No demands available',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job = jobs[index];
                          return JobCard(
                            demandId: job['demand_id']!,
                            title: job['title']!,
                            description: job['description']!,
                            location: job['location']!,
                            time: job['time']!,
                            category: job['category']!,
                            homeownerName: job['homeowner_name']!,
                            images: job['images'] as List,
                            l10n: l10n,
                            onOfferSent:
                                _loadDemands, // Refresh after sending offer
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  final String demandId;
  final String title;
  final String description;
  final String location;
  final String time;
  final String category;
  final String homeownerName;
  final List images;
  final AppLocalizations l10n;
  final VoidCallback onOfferSent;

  const JobCard({
    super.key,
    required this.demandId,
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.category,
    required this.homeownerName,
    required this.images,
    required this.l10n,
    required this.onOfferSent,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool _isSendingOffer = false;
  final ApiService _apiService = ApiService();

  void _showDemandDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DemandDetailsSheet(
        demandId: widget.demandId,
        title: widget.title,
        description: widget.description,
        location: widget.location,
        time: widget.time,
        category: widget.category,
        homeownerName: widget.homeownerName,
        images: widget.images,
        l10n: widget.l10n,
      ),
    );
  }

  Future<void> _sendOffer() async {
    // Show offer dialog
    final TextEditingController priceController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Send Offer',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF388E3C),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Your Price (DA)',
                hintText: 'e.g., 2500',
                prefixIcon: const Icon(
                  Icons.payments,
                  color: Color(0xFF4CAF50),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4CAF50),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Message (optional)',
                hintText: 'Describe your offer...',
                prefixIcon: const Icon(Icons.message, color: Color(0xFF4CAF50)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4CAF50),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a price'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Send Offer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (result == true && priceController.text.isNotEmpty) {
      setState(() {
        _isSendingOffer = true;
      });

      try {
        // Call the send offer API
        // Use current date + 1 day as default proposed date
        final proposedDate = DateTime.now()
            .add(Duration(days: 1))
            .toIso8601String()
            .split('T')[0];

        await _apiService.sendOffer(
          demandId: widget.demandId,
          message: messageController.text,
          proposedPrice: double.parse(priceController.text),
          proposedDate: proposedDate,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(widget.l10n.offerSent),
                ],
              ),
              backgroundColor: const Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          widget.onOfferSent(); // Refresh the list
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send offer: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSendingOffer = false;
          });
        }
      }
    }

    priceController.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: .1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.category,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            widget.description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Location and Time
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.location,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(
                '${widget.l10n.posted} ${widget.time}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showDemandDetails,
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4CAF50),
                    side: const BorderSide(color: Color(0xFF4CAF50)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isSendingOffer ? null : _sendOffer,
                  icon: _isSendingOffer
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, size: 18),
                  label: Text(widget.l10n.sendOffer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Demand Details Bottom Sheet
class DemandDetailsSheet extends StatelessWidget {
  final String demandId;
  final String title;
  final String description;
  final String location;
  final String time;
  final String category;
  final String homeownerName;
  final List images;
  final AppLocalizations l10n;

  const DemandDetailsSheet({
    super.key,
    required this.demandId,
    required this.title,
    required this.description,
    required this.location,
    required this.time,
    required this.category,
    required this.homeownerName,
    required this.images,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Category Badge
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Homeowner Info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F8F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF4CAF50),
                            child: Text(
                              homeownerName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Posted by',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                Text(
                                  homeownerName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF4CAF50),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Time
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFF4CAF50),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${l10n.posted} $time',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),

                    // Images
                    if (images.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Images',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            final imageUrl = images[index]['image_url'];
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
