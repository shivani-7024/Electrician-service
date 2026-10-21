import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/booking_model.dart';
import '../../../providers/booking_provider.dart';
import '../../../services/contact_service.dart';
import '../../widgets/status_badge.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCancelDialog(BuildContext context, BookingItem booking, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.tr('Cancel Booking?', 'बुकिंग रद्द करें?')),
        content: Text(
          lang.tr(
            'Are you sure you want to cancel the service for "${booking.serviceTitle}"?',
            'क्या आप "${booking.serviceTitle}" की बुकिंग रद्द करना चाहते हैं?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(lang.tr('No, Keep', 'नहीं, रखें')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
            onPressed: () {
              Provider.of<BookingProvider>(context, listen: false)
                  .cancelBooking(booking.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(lang.tr('Booking cancelled successfully', 'बुकिंग सफलतापूर्वक रद्द हो गई'))),
              );
            },
            child: Text(lang.tr('Yes, Cancel', 'हाँ, रद्द करें'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bookingProvider = Provider.of<BookingProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('My Service Bookings', 'मेरी सर्विस बुकिंग्स')),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelColor: primaryColor,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: '${lang.tr("Active", "सक्रिय")} (${bookingProvider.activeBookings.length})'),
            Tab(text: '${lang.tr("Completed", "पूर्ण")} (${bookingProvider.completedBookings.length})'),
            Tab(text: '${lang.tr("Cancelled", "रद्द")} (${bookingProvider.cancelledBookings.length})'),
          ],
        ),
      ),
      body: ResponsiveWrapper(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBookingList(bookingProvider.activeBookings, isDark, primaryColor, lang, isActive: true),
            _buildBookingList(bookingProvider.completedBookings, isDark, primaryColor, lang),
            _buildBookingList(bookingProvider.cancelledBookings, isDark, primaryColor, lang),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(
    List<BookingItem> list,
    bool isDark,
    Color primaryColor,
    LanguageProvider lang, {
    bool isActive = false,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              lang.tr('No bookings here', 'यहाँ कोई बुकिंग नहीं है'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              lang.tr('Need electrical work? Book our master electrician anytime.', 'बिजली का काम चाहिए? कभी भी विजिट बुक करें।'),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final booking = list[index];
        return _buildBookingCard(booking, isDark, primaryColor, lang, isActive: isActive);
      },
    );
  }

  Widget _buildBookingCard(
    BookingItem booking,
    bool isDark,
    Color primaryColor,
    LanguageProvider lang, {
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: booking.isEmergency
              ? AppColors.emergencyRed.withOpacity(0.4)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: booking.isEmergency ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ID + Status + Emergency Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          booking.id,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      if (booking.isEmergency) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.emergencyRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'EMERGENCY',
                            style: TextStyle(
                              color: AppColors.emergencyRed,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: booking.status),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),

          // Body: Title & Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.serviceTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  icon: Icons.calendar_today_rounded,
                  text: '${DateFormat('EEE, d MMM').format(booking.bookingDate)} • ${booking.timeSlot}',
                  isDark: isDark,
                ),
                const SizedBox(height: 6),
                _buildDetailRow(
                  icon: Icons.location_on_outlined,
                  text: booking.address,
                  isDark: isDark,
                ),
                if (booking.notes != null) ...[
                  const SizedBox(height: 6),
                  _buildDetailRow(
                    icon: Icons.chat_bubble_outline_rounded,
                    text: '${lang.tr("Scope", "विवरण")}: ${booking.notes}',
                    isDark: isDark,
                  ),
                ],

                // Live Tracking Timeline for Active Bookings
                if (isActive && booking.status != BookingStatus.cancelled) ...[
                  const SizedBox(height: 16),
                  _buildStatusTimeline(booking.status, isDark, primaryColor, lang),
                ],

                const SizedBox(height: 14),

                // Free Inspection Note & Actions Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.tr('Quote Status', 'कोटेशन'),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          Text(
                            lang.tr('Free On-Site Quote', 'मुफ्त साइट मुआयना'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.safetyGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (isActive)
                      Row(
                        children: [
                          IconButton.filledTonal(
                            icon: const Icon(Icons.phone_rounded, size: 18),
                            tooltip: lang.callNow,
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.safetyGreen.withOpacity(0.2),
                              foregroundColor: AppColors.safetyGreen,
                            ),
                            onPressed: () => ContactService.callElectrician(),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.emergencyRed,
                              side: const BorderSide(color: AppColors.emergencyRed),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: () => _showCancelDialog(context, booking, lang),
                            child: Text(lang.tr('Cancel', 'रद्द करें'), style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      )
                    else if (booking.status == BookingStatus.completed)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.star_outline_rounded, size: 16),
                        label: Text(lang.tr('Rate Service', 'रेटिंग दें')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(lang.tr('Thank you for choosing Zemtro Electrician!', 'ज़ेम्ट्रो इलेक्ट्रीशियन सेवा चुनने के लिए धन्यवाद!'))),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 15,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTimeline(BookingStatus status, bool isDark, Color primaryColor, LanguageProvider lang) {
    int currentStep = 0;
    if (status == BookingStatus.confirmed) currentStep = 1;
    if (status == BookingStatus.assigned) currentStep = 2;
    if (status == BookingStatus.inProgress) currentStep = 3;
    if (status == BookingStatus.completed) currentStep = 4;

    final steps = [
      lang.tr('Confirmed', 'कन्फर्म'),
      lang.tr('Assigned', 'नियुक्त'),
      lang.tr('On Way', 'रास्ते में'),
      lang.tr('Done', 'पूर्ण'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0E1626) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (idx) {
          final isDone = idx <= currentStep;
          final isCurrent = idx == currentStep;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (idx > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isDone ? AppColors.safetyGreen : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.safetyGreen : (isDark ? AppColors.darkCard : Colors.white),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone ? AppColors.safetyGreen : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: 2,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check, size: 11, color: Colors.white)
                          : null,
                    ),
                    if (idx < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: (idx < currentStep) ? AppColors.safetyGreen : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  steps[idx],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                    color: isCurrent
                        ? primaryColor
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
