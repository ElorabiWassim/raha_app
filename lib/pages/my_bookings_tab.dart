import 'package:flutter/material.dart';
import '/models/booking_model.dart';
import '/constants/app_text_style.dart';
import 'rate_report_provider_screen.dart';

class MyBookingsTab extends StatelessWidget {
  const MyBookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = _getBookings();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(context, bookings[index]);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                _buildStatusBadge(booking.status),
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
                          : AppColors.primary.withOpacity(0.3),
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
                          ? 'Rate'
                          : 'Details',
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

  Widget _buildStatusBadge(BookingStatus status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case BookingStatus.upcoming:
        backgroundColor = AppColors.statusUpcomingBg;
        textColor = AppColors.statusUpcoming;
        label = 'Upcoming';
        break;
      case BookingStatus.completed:
        backgroundColor = AppColors.statusCompletedBg;
        textColor = AppColors.statusCompleted;
        label = 'Completed';
        break;
      case BookingStatus.cancelled:
        backgroundColor = AppColors.statusCancelledBg;
        textColor = AppColors.statusCancelled;
        label = 'Cancelled';
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
