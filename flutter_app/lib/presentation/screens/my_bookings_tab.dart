import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/bookings/bookings_cubit.dart';
import '../../l10n_amine/app_localizations.dart';
import '../../data/models/booking_model.dart';
import '../themes/app_text_style.dart';
import 'rate_report_provider_screen.dart';

class MyBookingsTab extends StatelessWidget {
  const MyBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingsCubit, BookingsState>(
      builder: (context, state) {
        if (state is BookingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: state.bookings.length,
            itemBuilder: (context, index) {
              return _buildBookingCard(context, state.bookings[index]);
            },
          );
        } else if (state is BookingsError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
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
                  backgroundImage: NetworkImage(booking.providerImage),
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
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.serviceName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildStatusBadge(context, booking.status),
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
                Container(
                  height: 36,
                  constraints: const BoxConstraints(minWidth: 84),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Rate screen if booking is completed
                      if (booking.status == BookingStatus.completed) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                RateReportProviderScreen(booking: booking),
                          ),
                        );
                      } else {
                        // Navigate to details screen for other statuses
                        // TODO: Implement details screen navigation
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      booking.status == BookingStatus.completed
                          ? AppLocalizations.of(context)?.actionRate ?? 'Rate'
                          : AppLocalizations.of(context)?.actionDetails ??
                                'Details',
                      style: AppTextStyles.buttonMedium,
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

  Widget _buildStatusBadge(BuildContext context, BookingStatus status) {
    final l10n = AppLocalizations.of(context);
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case BookingStatus.upcoming:
        backgroundColor = AppColors.statusUpcomingBg;
        textColor = AppColors.statusUpcoming;
        label = l10n?.statusUpcoming ?? 'Upcoming';
        break;
      case BookingStatus.completed:
        backgroundColor = AppColors.statusCompletedBg;
        textColor = AppColors.statusCompleted;
        label = l10n?.statusCompleted ?? 'Completed';
        break;
      case BookingStatus.cancelled:
        backgroundColor = AppColors.statusCancelledBg;
        textColor = AppColors.statusCancelled;
        label = l10n?.statusCancelled ?? 'Cancelled';
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
        style: AppTextStyles.caption.copyWith(color: textColor),
      ),
    );
  }
}
