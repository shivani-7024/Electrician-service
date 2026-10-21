import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/service_provider.dart';
import '../../../services/contact_service.dart';
import '../../widgets/language_selector_pill.dart';
import '../estimator/cost_calculator_screen.dart';
import '../services/service_list_screen.dart';
import 'widgets/category_chips.dart';
import 'widgets/promo_banner_slider.dart';
import 'widgets/reviews_section.dart';
import 'widgets/service_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final user = authProvider.currentUser;
    final popularServices = serviceProvider.popularServices;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: Image.asset(
              'assets/images/logo_256.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.bolt_rounded, color: primaryColor),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    AppConstants.appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.safetyGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'VERIFIED',
                    style: TextStyle(
                      color: AppColors.safetyGreen,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 12,
                  color: primaryColor,
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    user?.defaultAddress.isNotEmpty == true
                        ? user!.defaultAddress
                        : lang.tr('Main City & Industrial Zone', 'शहर और इंडस्ट्रियल एरिया'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          LanguageSelectorPill(),
          SizedBox(width: 8),
        ],
      ),
      body: ResponsiveWrapper(
        child: RefreshIndicator(
          onRefresh: () => serviceProvider.loadCatalog(),
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Call & WhatsApp Action Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.support_agent_rounded, color: primaryColor, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.tr('Direct Electrician Support', 'सीधे इलेक्ट्रीशियन से बात करें'),
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              AppConstants.emergencyPhone,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: lang.callNow,
                        style: IconButton.styleFrom(
                          backgroundColor: primaryColor.withOpacity(0.15),
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(36, 36),
                        ),
                        icon: Icon(Icons.phone_in_talk_rounded, color: primaryColor, size: 18),
                        onPressed: () => ContactService.callElectrician(),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        tooltip: lang.chatWhatsApp,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366).withOpacity(0.15),
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(36, 36),
                        ),
                        icon: const Icon(Icons.chat_rounded, color: Color(0xFF25D366), size: 18),
                        onPressed: () => ContactService.openWhatsApp(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Promotional Slider (Summer AC, Makan Wiring Offers)
                const PromoBannerSlider(),

                const SizedBox(height: 20),

                // Core Services Grid (Makan Wiring, AC, Industrial, Emergency, Inverter, Fixtures)
                const CategoryGridSection(),

                const SizedBox(height: 20),

                // Work Scope Planner Teaser Card (No ₹ prices)
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CostCalculatorScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [primaryColor.withOpacity(0.2), const Color(0xFF0F172A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [primaryColor.withOpacity(0.1), Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.assignment_turned_in_rounded,
                            color: primaryColor,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.tr('Work Scope Planner', 'कार्य योजना व मुआयना'),
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lang.tr(
                                  'Select rooms, AC & wiring needs for a free site estimate',
                                  'कमरे, वायरिंग व AC चुनकर फ्री साइट मुआयना बुक करें',
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Popular Services Header & List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lang.tr('Popular Services', 'लोकप्रिय सेवाएं'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ServiceListScreen(),
                          ),
                        );
                      },
                      child: Text(
                        lang.viewAll,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Popular Service Cards
                ...popularServices.take(3).map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ServiceCard(service: s),
                      ),
                    ),

                const SizedBox(height: 16),

                // Why Choose Zemtro Electrician (Trust Factors)
                Text(
                  lang.tr('Why Choose Us', 'हमें क्यों चुनें'),
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTrustRow(
                        icon: Icons.shield_rounded,
                        color: AppColors.safetyGreen,
                        title: lang.tr('30-Day Service Guarantee', '30 दिन की सर्विस गारंटी'),
                        desc: lang.tr('Free labor revisits if any problem recurs', 'काम में कोई दिक्कत आने पर फ्री दोबारा सेवा'),
                        isDark: isDark,
                      ),
                      const Divider(height: 20),
                      _buildTrustRow(
                        icon: Icons.engineering_rounded,
                        color: primaryColor,
                        title: lang.tr('12+ Years Master Electrician', '12+ वर्षों का अनुभवी इलेक्ट्रीशियन'),
                        desc: lang.tr('Expert Chhotu Khan with deep residential & industrial expertise', 'मास्टर छोटू खान - घरेलू व इंडस्ट्रियल वायरिंग में माहिर'),
                        isDark: isDark,
                      ),
                      const Divider(height: 20),
                      _buildTrustRow(
                        icon: Icons.electric_bolt_rounded,
                        color: AppColors.emergencyRed,
                        title: lang.tr('Fast Emergency Response', 'त्वरित इमरजेंसी सेवा'),
                        desc: lang.tr('Prompt doorstep reach for short circuits & power cut', 'शॉर्ट सर्किट व बिजली खराबी पर तुरंत सहायता'),
                        isDark: isDark,
                      ),
                      const Divider(height: 20),
                      _buildTrustRow(
                        icon: Icons.assignment_turned_in_rounded,
                        color: AppColors.electricCyan,
                        title: lang.tr('Free On-Site Inspection', 'मुफ्त साइट निरीक्षण व सलाह'),
                        desc: lang.tr('Honest evaluation with no hidden costs', 'बिना किसी छुपे खर्च के सही सलाह व कोटेशन'),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Customer Reviews Carousel
                const ReviewsSection(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrustRow({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
