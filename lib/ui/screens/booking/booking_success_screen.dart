import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/booking_model.dart';
import '../../../services/contact_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/status_badge.dart';
import '../main_navigation.dart';

class BookingSuccessScreen extends StatelessWidget {
  final BookingItem booking;

  const BookingSuccessScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveWrapper(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // Glowing Success Circle
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.safetyGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.safetyGreen, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.safetyGreen.withOpacity(0.25),
                        blurRadius: 18,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.safetyGreen,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  lang.tr('Booking Confirmed!', 'बुकिंग कन्फर्म हो गई!'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  booking.isEmergency
                      ? lang.tr('Emergency request sent! Electrician arriving in 30-45 mins.', 'इमरजेंसी अनुरोध प्राप्त! इलेक्ट्रीशियन 30-45 मिनट में पहुंच रहे हैं।')
                      : lang.tr('Your visit with Zemtro Electrician has been scheduled.', 'ज़ेम्ट्रो इलेक्ट्रीशियन सर्विस के साथ आपकी विजिट तय हो चुकी है।'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 18),

                // Booking ID Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${lang.tr("Booking ID", "बुकिंग आईडी")}: ',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        booking.id,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Booking Summary Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        label: lang.tr('Service', 'सेवा'),
                        value: booking.serviceTitle,
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        label: lang.tr('Status', 'स्थिति'),
                        widgetValue: StatusBadge(status: booking.status),
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        label: lang.tr('Schedule Slot', 'समय स्लॉट'),
                        value: booking.timeSlot,
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        label: lang.tr('Service Date', 'विजिट तारीख'),
                        value: DateFormat('d MMM yyyy').format(booking.bookingDate),
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        label: lang.tr('Inspection Quote', 'मुआयना'),
                        value: lang.tr('Free On-Site Quote (Pay after work)', 'मुफ्त ऑन-साइट कोटेशन (काम के बाद भुगतान)'),
                        isDark: isDark,
                        primaryColor: primaryColor,
                        isHighlight: true,
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        label: lang.tr('Destination', 'पता'),
                        value: booking.address,
                        isDark: isDark,
                        primaryColor: primaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Assigned Master Electrician Card with Call Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: primaryColor.withOpacity(0.18),
                        child: Icon(Icons.engineering_rounded, color: primaryColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.electricianName ?? 'Chhotu Khan',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              lang.tr('Master Electrician • 12+ Yrs Exp', 'मास्टर इलेक्ट्रीशियन • 12+ वर्ष अनुभव'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filled(
                        icon: const Icon(Icons.phone_rounded, color: Colors.white, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.safetyGreen,
                        ),
                        tooltip: lang.callNow,
                        onPressed: () => ContactService.callElectrician(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // Actions
                CustomButton(
                  text: lang.tr('View My Bookings', 'मेरी बुकिंग्स देखें'),
                  icon: Icons.list_alt_rounded,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen(initialTabIndex: 3),
                      ),
                      (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen(initialTabIndex: 0),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(lang.tr('Return to Home', 'होम पेज पर जाएं')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    String? value,
    Widget? widgetValue,
    required bool isDark,
    required Color primaryColor,
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(width: 16),
        if (widgetValue != null)
          widgetValue
        else
          Flexible(
            child: Text(
              value ?? '',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isHighlight ? FontWeight.w900 : FontWeight.w700,
                color: isHighlight
                    ? AppColors.safetyGreen
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
          ),
      ],
    );
  }
}
