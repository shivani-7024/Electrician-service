import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../services/contact_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _msgController = TextEditingController();
  String _selectedService = 'Makan Wiring (House Wiring)';
  bool _isSubmitting = false;

  final List<String> _servicesList = [
    'Makan Wiring (House Wiring)',
    'AC Maintenance & Gas Refill',
    'Industrial 3-Phase Work',
    'Inverter / UPS Setup',
    '24/7 Emergency Fault Repair',
    'Other Fitting & Wiring',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _submitInquiry(LanguageProvider lang) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() => _isSubmitting = false);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.safetyGreen),
              const SizedBox(width: 8),
              Text(lang.tr('Inquiry Received!', 'संदेश प्राप्त हुआ!')),
            ],
          ),
          content: Text(
            lang.tr(
              'Thank you! Master Electrician Chhotu Khan will call you shortly to discuss your requirement.',
              'धन्यवाद! मास्टर इलेक्ट्रीशियन छोटू खान जल्द ही आपके नंबर पर संपर्क करेंगे।',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _msgController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('Contact Us', 'संपर्क करें')),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Business Badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          colors: [primaryColor.withOpacity(0.18), const Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [primaryColor.withOpacity(0.12), Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/logo_256.png',
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.engineering_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      lang.tr('Chhotu Khan • Certified Master Electrician', 'छोटू खान • अनुभवी मास्टर इलेक्ट्रीशियन'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lang.tr(
                        'Specialist in House Wiring, AC Service, & Industrial 3-Phase Panels',
                        'घरेलू मकान वायरिंग, एसी मेंटेनेंस व 3-फेज मोटर पैनल के विशेषज्ञ',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Direct Action Cards (Call & WhatsApp)
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => ContactService.callElectrician(),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              lang.tr('Call Directly', 'सीधे कॉल करें'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              AppConstants.emergencyPhone,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InkWell(
                      onTap: () => ContactService.openWhatsApp(),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF25D366).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 28),
                            const SizedBox(height: 8),
                            Text(
                              lang.tr('WhatsApp Chat', 'व्हाट्सएप चैट'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lang.tr('Instant Message', 'तुरंत संदेश'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Working Hours & Emergency Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoLine(
                      icon: Icons.access_time_filled_rounded,
                      title: lang.tr('Working Hours', 'कार्य समय'),
                      subtitle: AppConstants.workingHours,
                      isDark: isDark,
                      primaryColor: primaryColor,
                    ),
                    const Divider(height: 20),
                    _buildInfoLine(
                      icon: Icons.location_on_rounded,
                      title: lang.tr('Shop / Workshop Address', 'दुकान व कार्यशाला का पता'),
                      subtitle: AppConstants.officeAddress,
                      isDark: isDark,
                      primaryColor: primaryColor,
                    ),
                    const Divider(height: 20),
                    _buildInfoLine(
                      icon: Icons.email_rounded,
                      title: lang.tr('Official Email', 'आधिकारिक ईमेल'),
                      subtitle: '${AppConstants.primaryEmail}\n${AppConstants.infoEmail}',
                      isDark: isDark,
                      primaryColor: primaryColor,
                    ),
                    const Divider(height: 20),
                    _buildInfoLine(
                      icon: Icons.shield_rounded,
                      title: lang.tr('Service Guarantee', 'सर्विस गारंटी'),
                      subtitle: lang.tr(
                        '30-Day Service Guarantee with free labor revisits',
                        '30 दिन की सर्विस गारंटी व फ्री दोबारा सेवा',
                      ),
                      isDark: isDark,
                      primaryColor: primaryColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Direct Message / Inquiry Form
              Text(
                lang.tr('Send Direct Inquiry', 'पूछताछ संदेश भेजें'),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lang.tr(
                  'Fill in your details and we will call you back with a quote.',
                  'अपना विवरण भरें, हम आपको कॉल करके पूरी जानकारी देंगे।',
                ),
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 14),

              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        label: lang.tr('Your Name', 'आपका नाम'),
                        hint: lang.tr('Enter your name', 'नाम दर्ज करें'),
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (v) => v == null || v.trim().isEmpty ? lang.tr('Enter your name', 'नाम दर्ज करें') : null,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: _phoneController,
                        label: lang.tr('Mobile Number', 'मोबाइल नंबर'),
                        hint: lang.tr('10-digit mobile number', '10 अंकों का मोबाइल नंबर'),
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_android_rounded,
                        validator: (v) => v == null || v.trim().isEmpty ? lang.tr('Enter mobile number', 'मोबाइल नंबर दर्ज करें') : null,
                      ),
                      const SizedBox(height: 14),

                      Text(
                        lang.tr('Service Required', 'आवश्यक कार्य'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedService,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? const Color(0xFF0E1626) : const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: _servicesList.map((s) {
                          return DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13.5)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedService = val);
                        },
                      ),

                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: _msgController,
                        label: lang.tr('Message / Location Details', 'संदेश / स्थान का विवरण'),
                        hint: lang.tr('Briefly explain your location and requirement...', 'स्थान व कार्य का संक्षिप्त विवरण लिखें...'),
                        maxLines: 3,
                        prefixIcon: Icons.edit_note_rounded,
                      ),
                      const SizedBox(height: 18),

                      CustomButton(
                        text: lang.tr('Send Message to Electrician', 'इलेक्ट्रीशियन को संदेश भेजें'),
                        icon: Icons.send_rounded,
                        isLoading: _isSubmitting,
                        onPressed: () => _submitInquiry(lang),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoLine({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required Color primaryColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
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
