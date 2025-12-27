import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../services/api_service.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  int selectedTab = 0;
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> activeRequests = [];
  List<Map<String, dynamic>> historyRequests = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (selectedTab == 0) {
        // Load active bookings (pending)
        final response = await _apiService.getMyBookings();
        final bookingsList = response['bookings'] as List? ?? [];

        if (!mounted) return;

        setState(() {
          activeRequests = bookingsList
              .where(
                (b) => b['status'] == 'pending' || b['status'] == 'accepted',
              )
              .map((b) => b as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        // Load booking history
        final response = await _apiService.getBookingHistory();
        final bookingsList = response['bookings'] as List? ?? [];

        if (!mounted) return;

        setState(() {
          historyRequests = bookingsList
              .map((b) => b as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to load bookings: $e';
        isLoading = false;
      });
      print('Error loading bookings: $e');
    }
  }

  Future<void> _acceptBooking(String bookingId) async {
    try {
      await _apiService.acceptBooking(bookingId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking accepted successfully'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      _loadBookings(); // Reload data
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to accept booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _declineBooking(String bookingId) async {
    try {
      await _apiService.declineBooking(bookingId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking declined'),
          backgroundColor: Colors.orange,
        ),
      );
      _loadBookings(); // Reload data
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to decline booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _completeBooking(String bookingId) async {
    try {
      await _apiService.completeBooking(bookingId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking marked as completed'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      _loadBookings(); // Reload data
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to complete booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                  const Icon(
                    Icons.description,
                    color: Color(0xFF4CAF50),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    localizations.requestsTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildTab(localizations.requestsTabRequests, 0),
                  const SizedBox(width: 8),
                  _buildTab(localizations.requestsTabHistory, 1),
                ],
              ),
            ),

            // Content
            Expanded(
              child: RefreshIndicator(
                color: Color(0xFF4CAF50),
                onRefresh: _loadBookings,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4CAF50),
                        ),
                      )
                    : errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red[700]),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadBookings,
                              child: Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildRequestsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
    final requests = selectedTab == 0 ? activeRequests : historyRequests;

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selectedTab == 0 ? Icons.inbox_outlined : Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              selectedTab == 0 ? 'No pending requests' : 'No booking history',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
  final booking = requests[index];
  
  // DEBUG PRINT
  print('Attempting action on Booking ID: ${booking['booking_id']}'); 
  
  return RequestCard(
    booking: booking,
    onAccept: () => _acceptBooking(booking['booking_id'].toString()), // Ensure toString()
    onDecline: () => _declineBooking(booking['booking_id'].toString()),
    onComplete: () => _completeBooking(booking['booking_id'].toString()),
  );
},
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
          _loadBookings();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE5E7EB),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onComplete;

  const RequestCard({
    super.key,
    required this.booking,
    required this.onAccept,
    required this.onDecline,
    required this.onComplete,
  });

  Color get statusColor {
    switch (booking['status']) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'accepted':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'rejected':
      case 'cancelled':
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  String getLocalizedStatus(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (booking['status']) {
      case 'pending':
        return localizations.requestsStatusPending;
      case 'accepted':
        return localizations.requestsStatusConfirmed;
      case 'completed':
        return localizations.requestsStatusCompleted;
      case 'rejected':
        return 'Declined';
      case 'cancelled':
        return 'Cancelled';
      default:
        return booking['status'];
    }
  }

  IconData get serviceIcon {
    final categoryName =
        booking['service']?['service_categories']?['name'] ?? '';

    if (categoryName.toLowerCase().contains('plumb')) {
      return Icons.plumbing;
    } else if (categoryName.toLowerCase().contains('electric')) {
      return Icons.electrical_services;
    } else if (categoryName.toLowerCase().contains('hvac') ||
        categoryName.toLowerCase().contains('air')) {
      return Icons.ac_unit;
    } else if (categoryName.toLowerCase().contains('clean')) {
      return Icons.cleaning_services;
    } else if (categoryName.toLowerCase().contains('paint')) {
      return Icons.format_paint;
    } else if (categoryName.toLowerCase().contains('garden')) {
      return Icons.grass;
    } else {
      return Icons.home_repair_service;
    }
  }

  void _showBookingDetails(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final homeownerData = booking['homeowners'];
    final userData = homeownerData?['users'];
    final homeownerName = userData?['full_name'] ?? 'Unknown';
    final homeownerEmail = userData?['email'] ?? '';
    final homeownerPhone = userData?['phone_number'] ?? '';
    final serviceData = booking['services'];
    final serviceName = serviceData?['name'] ?? 'Service';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Service: $serviceName',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Customer: $homeownerName'),
              if (homeownerEmail.isNotEmpty) Text('Email: $homeownerEmail'),
              if (homeownerPhone.isNotEmpty) Text('Phone: $homeownerPhone'),
              SizedBox(height: 8),
              Text('Location: ${booking['location'] ?? 'Not specified'}'),
              Text('Date: ${booking['date'] ?? ''}'),
              Text('Time: ${booking['time'] ?? ''}'),
              SizedBox(height: 8),
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(booking['description'] ?? 'No description'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Access nested homeowner data correctly
    final homeownerData = booking['homeowners'];
    final userData = homeownerData?['users'];
    final homeownerName = userData?['full_name'] ?? 'Unknown';

    // Access service data
    final serviceData = booking['services'];
    final serviceName = serviceData?['name'] ?? 'Service';

    final location = booking['location'] ?? 'Location not specified';
    final date = booking['date'] ?? '';
    final time = booking['time'] ?? '';
    final status = booking['status'] ?? 'unknown';
    final description = booking['description'] ?? '';
    final images = booking['booking_images'] as List? ?? [];

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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  serviceIcon,
                  color: const Color(0xFF4CAF50),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            homeownerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            getLocalizedStatus(context),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$date${time.isNotEmpty ? ' - $time' : ''}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Images
          if (images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imageUrl = images[index]['image_url'];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: Icon(Icons.image, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Action Buttons
          if (status == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFF44336),
                      side: const BorderSide(color: Color(0xFFFFEBEE)),
                      backgroundColor: const Color(0xFFFFEBEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      localizations.requestsDecline,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
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
                      localizations.requestsAccept,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Complete Button for Accepted Bookings
          if (status == 'accepted') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onComplete,
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
                  'Mark as Completed',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],

          // View Details Button
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _showBookingDetails(context);
            },
            child: Text(
              localizations.requestsViewDetails,
              style: const TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
