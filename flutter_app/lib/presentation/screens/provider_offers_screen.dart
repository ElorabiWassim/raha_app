import 'package:flutter/material.dart';
import '../themes/app_text_style.dart';
import '../../data/models/provider_offers_model.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProviderOffersScreen extends StatefulWidget {
  final String demandId;
  final String demandTitle;
  final String demandCategory;
  final String demandDescription;
  final String demandLocation;
  final String postedDate;
  final IconData demandIcon;

  const ProviderOffersScreen({
    super.key,
    required this.demandId,
    required this.demandTitle,
    required this.demandCategory,
    required this.demandDescription,
    required this.demandLocation,
    required this.postedDate,
    required this.demandIcon,
  });

  @override
  State<ProviderOffersScreen> createState() => _ProviderOffersScreenState();
}

class _ProviderOffersScreenState extends State<ProviderOffersScreen> {
  String? acceptedProviderId;
  List<ProviderOffer> offers = [];
  List<String> rejectedOfferIds = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final url = Uri.parse(
        'http://10.0.2.2:5000/homeowner/getDemandOffers?demand_id=${widget.demandId}',
      );
      final response = await http.get(url);

      if (response.statusCode != 200) {
        setState(() {
          _error = 'Failed to load offers';
          _isLoading = false;
        });
        return;
      }

      final decoded = jsonDecode(response.body);
      final list = decoded is List ? decoded : <dynamic>[];
      final mapped = list.map((raw) {
        final map = (raw as Map).cast<String, dynamic>();
        final spId = (map['sp_id'] ?? '').toString();
        final name = (map['sp_name'] ?? '—').toString();
        final price = map['proposed_price'];
        final message = (map['message'] ?? '').toString();

        return ProviderOffer(
          id: spId,
          providerName: name,
          providerImage: '',
          rating: 0,
          price: int.tryParse(price?.toString() ?? '') ?? 0,
          description: message,
        );
      }).toList();

      setState(() {
        offers = mapped;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _error = 'Failed to load offers';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleOffers = offers
        .where((offer) => !rejectedOfferIds.contains(offer.id))
        .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F6E0), Color(0xFFFFFFFF), Color(0xFFF9FFF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (_error != null)
                    ? Center(child: Text(_error!))
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        children: [
                          _buildDemandSummaryCard(),
                          const SizedBox(height: 24),
                          Text(
                            'Provider Offers (${visibleOffers.length})',
                            style: AppTextStyles.custom(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              letterSpacing: -0.015,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (visibleOffers.isEmpty)
                            _buildNoOffersState()
                          else
                            ...visibleOffers.map(
                              (offer) => _buildOfferCard(offer),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7E6).withValues(alpha: .8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: Text(
              'Service Provider Offers',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading4.copyWith(color: AppColors.textDark),
            ),
          ),
          const SizedBox(width: 48, height: 48),
        ],
      ),
    );
  }

  Widget _buildDemandSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: .2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.demandIcon, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.demandTitle,
                  style: AppTextStyles.heading5.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Posted on: ${widget.postedDate}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.demandDescription,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.demandLocation,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(ProviderOffer offer) {
    final isAccepted = acceptedProviderId == offer.id;
    final isDisabled = acceptedProviderId != null && !isAccepted;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDisabled
            ? AppColors.backgroundLight
            : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAccepted
              ? AppColors.primary
              : isDisabled
              ? AppColors.border
              : AppColors.primary.withValues(alpha: .2),
          width: isAccepted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isAccepted ? 0.08 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: isDisabled ? 0.5 : 1.0,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(offer.providerImage),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Opacity(
                    opacity: isDisabled ? 0.5 : 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.providerName,
                          style: AppTextStyles.heading5.copyWith(
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              offer.rating.toString(),
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFBBF24),
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Opacity(
                  opacity: isDisabled ? 0.5 : 1.0,
                  child: Text(
                    '${offer.price} DZD',
                    style: AppTextStyles.custom(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Opacity(
              opacity: isDisabled ? 0.5 : 1.0,
              child: Text(
                offer.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ),

            if (isAccepted) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Accepted',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (!isAccepted) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: isDisabled
                            ? null
                            : () => _showConfirmationDialog(offer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDisabled
                              ? AppColors.border
                              : AppColors.primary,
                          foregroundColor: isDisabled
                              ? AppColors.textLight
                              : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: AppColors.border,
                          disabledForegroundColor: AppColors.textLight,
                        ),
                        child: Text(
                          'Accept',
                          style: AppTextStyles.buttonMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: isDisabled
                            ? null
                            : () => _showRejectDialog(offer),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDisabled
                              ? AppColors.textLight
                              : AppColors.error,
                          side: BorderSide(
                            color: isDisabled
                                ? AppColors.border
                                : AppColors.error,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledForegroundColor: AppColors.textLight,
                        ),
                        child: Text(
                          'Reject',
                          style: AppTextStyles.buttonMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(ProviderOffer offer) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: .3),
      pageBuilder: (context, _, __) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Confirm provider selection?',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.custom(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMedium,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'Are you sure you want to accept the offer from ',
                          ),
                          TextSpan(
                            text: offer.providerName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const TextSpan(text: '?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.backgroundLight,
                                foregroundColor: AppColors.textDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: AppTextStyles.buttonMedium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final url = Uri.parse(
                                    'http://10.0.2.2:5000/homeowner/acceptDemand',
                                  );
                                  final response = await http.post(
                                    url,
                                    headers: {
                                      'Content-Type': 'application/json',
                                    },
                                    body: jsonEncode({
                                      'demand_id': widget.demandId,
                                      'sp_id': offer.id,
                                    }),
                                  );

                                  if (response.statusCode >= 200 &&
                                      response.statusCode < 300) {
                                    if (!mounted) return;
                                    setState(() {
                                      acceptedProviderId = offer.id;
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Failed to accept offer'),
                                      ),
                                    );
                                  }
                                } catch (_) {
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to accept offer'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Confirm',
                                style: AppTextStyles.buttonMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRejectDialog(ProviderOffer offer) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: .3),
      pageBuilder: (context, _, __) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: .1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.error,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Reject this offer?',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.custom(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMedium,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'Are you sure you want to reject the offer from ',
                          ),
                          TextSpan(
                            text: offer.providerName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const TextSpan(
                            text: '? This action cannot be undone.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.backgroundLight,
                                foregroundColor: AppColors.textDark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: AppTextStyles.buttonMedium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  rejectedOfferIds.add(offer.id);
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Offer from ${offer.providerName} rejected',
                                    ),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Reject',
                                style: AppTextStyles.buttonMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoOffersState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Offers Available',
              style: AppTextStyles.custom(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All provider offers have been reviewed.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
