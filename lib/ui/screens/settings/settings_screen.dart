import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/contact_service.dart';
import '../../auth/login_screen.dart';
import '../contact/contact_us_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('Settings & Preferences', 'सेटिंग्स व प्राथमिकताएं')),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: primaryColor.withOpacity(0.18),
                      child: Icon(
                        Icons.person_rounded,
                        color: primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? lang.tr('Valued Customer', 'सम्मानित ग्राहक'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.phone.isNotEmpty == true
                                ? user!.phone
                                : lang.tr('Guest User', 'अतिथि ग्राहक'),
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: Text(lang.tr('Edit', 'बदलें'), style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 1. LANGUAGE SELECTION SECTION
              Text(
                lang.tr('App Language', 'ऐप की भाषा चुनें'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lang.tr('Select your preferred display language.', 'अपनी पसंदीदा भाषा का चयन करें।'),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildLanguageOption(
                    context: context,
                    title: 'हिन्दी (Hindi)',
                    isSelected: lang.isHindi,
                    onTap: () => lang.setLanguage(AppLanguage.hindi),
                    isDark: isDark,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(width: 10),
                  _buildLanguageOption(
                    context: context,
                    title: 'English',
                    isSelected: lang.isEnglish,
                    onTap: () => lang.setLanguage(AppLanguage.english),
                    isDark: isDark,
                    primaryColor: primaryColor,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 2. COLOR PALETTE SELECTION (5 Colors!)
              Text(
                lang.tr('Theme Color Palette (5 Colors)', 'थीम कलर चुनें (5 विकल्प)'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lang.tr('Choose an accent color to personalize your app look.', 'ऐप का मुख्य रंग बदलने के लिए नीचे से कोई रंग चुनें।'),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // 5 Color Swatches Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColorSwatch(
                      colorTheme: AppColorTheme.amber,
                      color: const Color(0xFFF59E0B),
                      name: lang.tr('Amber', 'गोल्ड'),
                      isSelected: themeProvider.colorTheme == AppColorTheme.amber,
                      onTap: () => themeProvider.setColorTheme(AppColorTheme.amber),
                    ),
                    _buildColorSwatch(
                      colorTheme: AppColorTheme.blue,
                      color: const Color(0xFF2563EB),
                      name: lang.tr('Blue', 'नीला'),
                      isSelected: themeProvider.colorTheme == AppColorTheme.blue,
                      onTap: () => themeProvider.setColorTheme(AppColorTheme.blue),
                    ),
                    _buildColorSwatch(
                      colorTheme: AppColorTheme.green,
                      color: const Color(0xFF10B981),
                      name: lang.tr('Green', 'हरा'),
                      isSelected: themeProvider.colorTheme == AppColorTheme.green,
                      onTap: () => themeProvider.setColorTheme(AppColorTheme.green),
                    ),
                    _buildColorSwatch(
                      colorTheme: AppColorTheme.red,
                      color: const Color(0xFFEF4444),
                      name: lang.tr('Red', 'लाल'),
                      isSelected: themeProvider.colorTheme == AppColorTheme.red,
                      onTap: () => themeProvider.setColorTheme(AppColorTheme.red),
                    ),
                    _buildColorSwatch(
                      colorTheme: AppColorTheme.purple,
                      color: const Color(0xFF8B5CF6),
                      name: lang.tr('Purple', 'बैंगनी'),
                      isSelected: themeProvider.colorTheme == AppColorTheme.purple,
                      onTap: () => themeProvider.setColorTheme(AppColorTheme.purple),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // 3. DARK / LIGHT MODE
              Text(
                lang.tr('Display Mode', 'डिस्प्ले मोड'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildThemeOptionCard(
                    context: context,
                    title: lang.tr('Dark Mode', 'डार्क मोड'),
                    subtitle: 'AMOLED',
                    icon: Icons.dark_mode_rounded,
                    mode: ThemeMode.dark,
                    currentMode: themeProvider.themeMode,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                    isDark: isDark,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(width: 10),
                  _buildThemeOptionCard(
                    context: context,
                    title: lang.tr('Light Mode', 'लाइट मोड'),
                    subtitle: 'Clean',
                    icon: Icons.light_mode_rounded,
                    mode: ThemeMode.light,
                    currentMode: themeProvider.themeMode,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                    isDark: isDark,
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(width: 10),
                  _buildThemeOptionCard(
                    context: context,
                    title: lang.tr('System', 'सिस्टम'),
                    subtitle: 'Auto',
                    icon: Icons.brightness_auto_rounded,
                    mode: ThemeMode.system,
                    currentMode: themeProvider.themeMode,
                    onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                    isDark: isDark,
                    primaryColor: primaryColor,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 4. Quick Actions / Support
              Text(
                lang.tr('Support & Company', 'सहायता व संपर्क'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),

              Material(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.chat_rounded,
                      iconColor: const Color(0xFF25D366),
                      title: lang.tr('Direct WhatsApp Support', 'व्हाट्सएप पर संपर्क करें'),
                      subtitle: lang.tr('Chat with our electrician team instantly', 'इलेक्ट्रीशियन टीम से सीधे चैट करें'),
                      onTap: () => ContactService.openWhatsApp(),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.phone_in_talk_rounded,
                      iconColor: primaryColor,
                      title: lang.tr('Master Electrician Hotline', 'मास्टर इलेक्ट्रीशियन हेल्पलाइन'),
                      subtitle: AppConstants.emergencyPhone,
                      onTap: () => ContactService.callElectrician(),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.shield_outlined,
                      iconColor: AppColors.safetyGreen,
                      title: lang.tr('30-Day Service Guarantee', '30 दिन की सर्विस गारंटी'),
                      subtitle: lang.tr('Free labor revisits if any problem recurs', 'समस्या आने पर फ्री दोबारा सेवा'),
                      onTap: () => _showWarrantyInfo(context, lang),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.email_outlined,
                      iconColor: AppColors.electricCyan,
                      title: lang.tr('Official Email Support', 'ईमेल सहायता'),
                      subtitle: '${AppConstants.primaryEmail} • ${AppConstants.infoEmail}',
                      onTap: () => ContactService.sendEmail(),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.contact_support_outlined,
                      iconColor: AppColors.electricCyan,
                      title: lang.tr('Contact Us & Send Inquiry', 'संपर्क करें और संदेश भेजें'),
                      subtitle: lang.tr('Workshop address & message form', 'वर्कशॉप का पता व पूछताछ फॉर्म'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ContactUsScreen()),
                        );
                      },
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: primaryColor,
                      title: lang.tr('About Zemtro Electrician', 'ज़ेम्ट्रो इलेक्ट्रीशियन के बारे में'),
                      subtitle: lang.tr('Verified electricians since 2012', 'विश्वसनीय इलेक्ट्रीशियन सेवा'),
                      onTap: () => _showAboutDialog(context, lang),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout / Switch Account
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    authProvider.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: AppColors.emergencyRed),
                  label: Text(
                    lang.tr('Logout / Switch Account', 'लॉगआउट / खाता बदलें'),
                    style: const TextStyle(
                      color: AppColors.emergencyRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Zemtro Electrician v1.0.0',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color primaryColor,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withOpacity(0.12)
                : (isDark ? AppColors.darkCard : AppColors.lightCard),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 18,
                color: isSelected ? primaryColor : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? primaryColor : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSwatch({
    required AppColorTheme colorTheme,
    required Color color,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? color : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onTap,
    required bool isDark,
    required Color primaryColor,
  }) {
    final isSelected = mode == currentMode;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withOpacity(0.12)
                : (isDark ? AppColors.darkCard : AppColors.lightCard),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? primaryColor
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? primaryColor
                      : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11.5,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
      onTap: onTap,
    );
  }

  void _showWarrantyInfo(BuildContext context, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.tr('30-Day Service Guarantee', '30 दिन की सर्विस गारंटी')),
        content: Text(
          lang.tr(
            'At Zemtro Electrician, our goal is 100% customer satisfaction. If any fault returns within 30 days of repair, our technician will visit and resolve it free of charge!',
            'ज़ेम्ट्रो इलेक्ट्रीशियन में आपकी संतुष्टि हमारी प्राथमिकता है। कार्य के 30 दिन के अंदर यदि दोबारा वही समस्या आती है, तो हमारे कारीगर बिना किसी लेबर चार्ज के इसे ठीक करेंगे!',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(lang.tr('Understood', 'ठीक है')),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo_256.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.bolt_rounded, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                AppConstants.appName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo_256.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              lang.tr(
                'Zemtro Electrician is a premier electrical solutions company providing expert Residential Makan Wiring, Commercial AC maintenance, and Heavy Industrial 3-phase machinery electricals.\n\nContact: ${AppConstants.contactPhone}\nEmail: ${AppConstants.primaryEmail}\nInfo: ${AppConstants.infoEmail}',
                'ज़ेम्ट्रो इलेक्ट्रीशियन एक प्रमुख इलेक्ट्रिकल सेवा प्रदाता है। हम घरेलू मकान वायरिंग, एसी मेंटेनेंस, और इंडस्ट्रियल 3-फेज मोटर पैनल आदि का गुणवत्तापूर्ण कार्य करते हैं।\n\nसंपर्क: ${AppConstants.contactPhone}\nईमेल: ${AppConstants.primaryEmail}\nजानकारी: ${AppConstants.infoEmail}',
              ),
              style: const TextStyle(fontSize: 12.5, height: 1.4),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(lang.tr('Close', 'बंद करें')),
          ),
        ],
      ),
    );
  }
}
