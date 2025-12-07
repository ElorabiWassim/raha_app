import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../themes/app_text_style.dart';
import '../../data/models/provider_offers_model.dart';
import 'dart:ui';

class ProviderOffersScreen extends StatefulWidget {
  final String demandTitle;
  final String demandCategory;
  final String demandDescription;
  final String demandLocation;
  final String postedDate;
  final IconData demandIcon;

  const ProviderOffersScreen({
    super.key,
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

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    offers = _getProviderOffers();
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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    _buildDemandSummaryCard(),
                    const SizedBox(height: 24),
                    Text(
                      l10n.providerOffersCount(visibleOffers.length),
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
                      ...visibleOffers.map((offer) => _buildOfferCard(offer)),
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
              l10n.providerOffersTitle,
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
                  l10n.providerOffersPostedOn(widget.postedDate),
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
                        l10n.providerOffersAccepted,
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
                          l10n.providerOffersAccept,
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
                          l10n.providerOffersReject,
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
                      l10n.providerOffersConfirmTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.custom(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.providerOffersConfirmBody(offer.providerName),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMedium,
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
                                l10n.providerOffersCancel,
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
                                  acceptedProviderId = offer.id;
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                l10n.providerOffersConfirm,
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
                      l10n.providerOffersRejectTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.custom(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.providerOffersRejectBody(offer.providerName),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMedium,
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
                                l10n.providerOffersCancel,
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
                                      l10n.providerOffersRejectToast(
                                        offer.providerName,
                                      ),
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
                                l10n.providerOffersReject,
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
              l10n.providerOffersNoOffersTitle,
              style: AppTextStyles.custom(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.providerOffersNoOffersSubtitle,
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

  List<ProviderOffer> _getProviderOffers() {
    return [
      ProviderOffer(
        id: '1',
        providerName: 'Ahmed Benali',
        providerImage: 'https://i.pravatar.cc/150?img=12',
        rating: 4.5,
        price: 1500,
        description: 'Experienced plumber, ready to start immediately.',
      ),
      ProviderOffer(
        id: '2',
        providerName: 'Yacine Djebbar',
        providerImage: 'https://i.pravatar.cc/150?img=33',
        rating: 4.8,
        price: 1800,
        description: 'Quick and reliable service. 5 years of experience.',
      ),
      ProviderOffer(
        id: '3',
        providerName: 'Fatima Zohra',
        providerImage: 'https://i.pravatar.cc/150?img=47',
        rating: 4.2,
        price: 1400,
        description: 'Affordable and clean work guaranteed.',
      ),
      ProviderOffer(
        id: '4',
        providerName: 'Karim Messaoudi',
        providerImage: 'https://i.pravatar.cc/150?img=15',
        rating: 4.7,
        price: 1650,
        description: 'Professional service with quality materials included.',
      ),
      ProviderOffer(
        id: '5',
        providerName: 'Amina Bouaziz',
        providerImage: 'https://i.pravatar.cc/150?img=45',
        rating: 4.9,
        price: 1900,
        description: 'Top-rated provider with 10+ years experience.',
      ),
      ProviderOffer(
        id: '6',
        providerName: 'Riad Hamdi',
        providerImage: 'https://i.pravatar.cc/150?img=68',
        rating: 4.3,
        price: 1350,
        description: 'Budget-friendly option with guaranteed satisfaction.',
      ),
    ];
  }
}
