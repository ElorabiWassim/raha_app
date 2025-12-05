import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../data/models/booking_model.dart';
import '../themes/app_text_style.dart';
import 'rate_report_provider_screen.dart';

class MyBookingsTab extends StatelessWidget {
  const MyBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bookings = _getBookings();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(context, bookings[index], l10n);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: .2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 2),
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
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(booking.providerImage.trim()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.providerName,
                        style: AppTextStyles.heading5.copyWith(
                          color: AppColors.textDark,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.serviceName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildStatusBadge(booking.status, l10n),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              height: 1,
              color: AppColors.backgroundLight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.dateTime,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.price,
                      style: AppTextStyles.heading5.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      if (booking.status == BookingStatus.completed) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                RateReportProviderScreen(booking: booking),
                          ),
                        );
                      } else {
                        // TODO: Navigate to booking details
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: booking.status == BookingStatus.completed
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: .3),
                      foregroundColor: booking.status == BookingStatus.completed
                          ? Colors.white
                          : AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: FittedBox(
                      child: Text(
                        booking.status == BookingStatus.completed
                            ? l10n.rate
                            : l10n.details,
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
    );
  }

  Widget _buildStatusBadge(BookingStatus status, AppLocalizations l10n) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case BookingStatus.upcoming:
        backgroundColor = AppColors.statusUpcomingBg;
        textColor = AppColors.statusUpcoming;
        label = l10n.upcoming;
        break;
      case BookingStatus.completed:
        backgroundColor = AppColors.statusCompletedBg;
        textColor = AppColors.statusCompleted;
        label = l10n.completed;
        break;
      case BookingStatus.cancelled:
        backgroundColor = AppColors.statusCancelledBg;
        textColor = AppColors.statusCancelled;
        label = l10n.cancelled;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(color: textColor),
      ),
    );
  }

  List<Booking> _getBookings() {
    return [
      Booking(
        providerName: 'Karim Benzema',
        providerImage: 'https://i.pravatar.cc/150?img=12',
        serviceName: 'Plumbing Repair',
        dateTime: '25 Oct, 10:00 AM',
        price: '5,000 DZD',
        status: BookingStatus.upcoming,
      ),
      Booking(
        providerName: 'Nadia Belkacem',
        providerImage: 'https://i.pravatar.cc/150?img=47',
        serviceName: 'House Cleaning',
        dateTime: '22 Oct, 02:00 PM',
        price: '3,500 DZD',
        status: BookingStatus.completed,
      ),
      Booking(
        providerName: 'Ahmed Djebbour',
        providerImage: 'https://i.pravatar.cc/150?img=33',
        serviceName: 'AC Maintenance',
        dateTime: '15 Oct, 09:30 AM',
        price: '6,000 DZD',
        status: BookingStatus.cancelled,
      ),
    ];
  }
}