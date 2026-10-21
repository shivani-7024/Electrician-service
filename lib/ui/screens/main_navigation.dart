import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/language_provider.dart';
import '../../providers/booking_provider.dart';
import '../../services/contact_service.dart';
import 'home/home_screen.dart';
import 'services/service_list_screen.dart';
import 'estimator/cost_calculator_screen.dart';
import 'booking/my_bookings_screen.dart';
import 'settings/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialTabIndex;

  const MainNavigationScreen({super.key, this.initialTabIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    ServiceListScreen(),
    CostCalculatorScreen(),
    MyBookingsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
  }

  void _showQuickContactSheet(BuildContext context, LanguageProvider lang, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  lang.tr('Direct Electrician Contact', 'इलेक्ट्रीशियन से सीधे संपर्क करें'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lang.tr(
                    'Talk directly to Master Electrician Chhotu Khan',
                    'मास्टर कारीगर छोटू खान से सीधे बात करें',
                  ),
                  style: const TextStyle(fontSize: 12.5),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.phone_in_talk_rounded, color: primaryColor),
                  ),
                  title: Text(
                    lang.tr('Call Master Electrician', 'इलेक्ट्रीशियन को कॉल करें'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${AppConstants.emergencyPhone} (Direct Call)'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ContactService.callElectrician();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_rounded, color: Color(0xFF25D366)),
                  ),
                  title: Text(
                    lang.tr('Chat on WhatsApp', 'व्हाट्सएप पर चैट करें'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(lang.tr('Instant inquiry & photo sharing', 'तुरंत पूछताछ व फोटो भेजें')),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ContactService.openWhatsApp();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.emergencyRed.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt_rounded, color: AppColors.emergencyRed),
                  ),
                  title: Text(
                    lang.tr('24/7 Emergency Breakdown', '24/7 आपातकालीन खराबी'),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emergencyRed),
                  ),
                  subtitle: Text(lang.tr('Rapid dispatch for short circuits', 'शॉर्ट सर्किट व बिजली फॉल्ट पर तुरंत सहायता')),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ContactService.openEmergencyWhatsApp();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bookingProvider = Provider.of<BookingProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final activeCount = bookingProvider.activeBookingsCount;

    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickContactSheet(context, lang, primaryColor),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        tooltip: lang.tr('Contact Electrician', 'इलेक्ट्रीशियन संपर्क'),
        child: const Icon(Icons.phone_in_talk_rounded, size: 26),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: lang.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bolt_outlined),
            activeIcon: const Icon(Icons.bolt_rounded),
            label: lang.navServices,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment_rounded),
            label: lang.navEstimator,
          ),
          BottomNavigationBarItem(
            icon: activeCount > 0
                ? Badge(
                    label: Text('$activeCount'),
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.calendar_today_outlined),
                  )
                : const Icon(Icons.calendar_today_outlined),
            activeIcon: activeCount > 0
                ? Badge(
                    label: Text('$activeCount'),
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.calendar_today_rounded),
                  )
                : const Icon(Icons.calendar_today_rounded),
            label: lang.navBookings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings_rounded),
            label: lang.navSettings,
          ),
        ],
      ),
    );
  }
}
