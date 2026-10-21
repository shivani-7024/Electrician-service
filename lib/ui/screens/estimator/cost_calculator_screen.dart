import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../providers/service_provider.dart';
import '../booking/booking_form_screen.dart';
import '../../widgets/custom_button.dart';

class CostCalculatorScreen extends StatefulWidget {
  const CostCalculatorScreen({super.key});

  @override
  State<CostCalculatorScreen> createState() => _CostCalculatorScreenState();
}

class _CostCalculatorScreenState extends State<CostCalculatorScreen> {
  // Service Type: 0: Makan Wiring, 1: AC Servicing, 2: Switchboards & Fixtures
  int _selectedCategoryIndex = 0;

  // 1. House Wiring States
  String _homeSize = '2 BHK';
  final List<String> _homeSizes = [
    '1 BHK',
    '2 BHK',
    '3 BHK',
    '4 BHK / Villa',
    'Commercial / Shop',
  ];
  bool _includeEarthing = true;
  bool _includeDbBox = true;
  bool _includeInverter = true;

  // 2. AC Service States
  int _splitAcCount = 1;
  int _windowAcCount = 0;
  bool _needGasRefill = false;

  // 3. Fixtures States
  int _fanCount = 2;
  int _switchboardCount = 4;
  int _lightPointCount = 6;

  String _buildScopeSummary(LanguageProvider lang) {
    if (_selectedCategoryIndex == 0) {
      final items = <String>[_homeSize];
      if (_includeEarthing) items.add(lang.tr('Earthing Pit', 'अर्थिंग पिट'));
      if (_includeDbBox) items.add(lang.tr('Main MCB Box', 'मेन MCB बॉक्स'));
      if (_includeInverter) items.add(lang.tr('Inverter Wiring', 'इन्वर्टर वायरिंग'));
      return items.join(' • ');
    } else if (_selectedCategoryIndex == 1) {
      final items = <String>[];
      if (_splitAcCount > 0) items.add('Split AC: $_splitAcCount');
      if (_windowAcCount > 0) items.add('Window AC: $_windowAcCount');
      if (_needGasRefill) items.add(lang.tr('Gas Check/Refill', 'गैस चेक/रिफिल'));
      return items.isEmpty ? lang.tr('No AC selected', 'कोई AC नहीं चुना') : items.join(' • ');
    } else {
      final items = <String>[];
      if (_fanCount > 0) items.add('${lang.tr("Fans", "पंखा")}: $_fanCount');
      if (_switchboardCount > 0) items.add('${lang.tr("Switchboards", "स्विचबोर्ड")}: $_switchboardCount');
      if (_lightPointCount > 0) items.add('${lang.tr("Lights", "लाइट्स")}: $_lightPointCount');
      return items.isEmpty ? lang.tr('No fixtures selected', 'कोई फिक्सचर नहीं चुना') : items.join(' • ');
    }
  }

  void _proceedToBooking(LanguageProvider lang) {
    final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

    String serviceId;
    String notes;

    if (_selectedCategoryIndex == 0) {
      serviceId = 'mw-01';
      notes = 'Work Scope: $_homeSize, Earthing: $_includeEarthing, DB Box: $_includeDbBox, Inverter: $_includeInverter';
    } else if (_selectedCategoryIndex == 1) {
      serviceId = 'ac-01';
      notes = 'Work Scope: Split AC: $_splitAcCount, Window AC: $_windowAcCount, Gas Refill: $_needGasRefill';
    } else {
      serviceId = 'fit-01';
      notes = 'Work Scope: Fans: $_fanCount, Switchboards: $_switchboardCount, Lights: $_lightPointCount';
    }

    final matchedService = serviceProvider.services.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => serviceProvider.services.first,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingFormScreen(
          service: matchedService,
          initialNotes: notes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('Work Scope Planner', 'कार्य योजना व मुआयना')),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header description
              Text(
                lang.tr('Plan Your Electrical Work', 'अपने काम की योजना बनाएं'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lang.tr(
                  'Select your requirements below. Our master electrician will visit your site and provide a free exact quote.',
                  'नीचे अपनी आवश्यकताएं चुनें। हमारे मास्टर इलेक्ट्रीशियन साइट पर आकर मुफ्त सही कोटेशन देंगे।',
                ),
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Category Switcher Segment
              Row(
                children: [
                  _buildCategoryTab(0, lang.tr('Makan Wiring', 'मकान वायरिंग'), Icons.home_rounded, isDark, primaryColor),
                  const SizedBox(width: 8),
                  _buildCategoryTab(1, lang.tr('AC Service', 'AC सर्विस'), Icons.ac_unit_rounded, isDark, primaryColor),
                  const SizedBox(width: 8),
                  _buildCategoryTab(2, lang.tr('Fixtures', 'स्विच / फिटिंग'), Icons.lightbulb_rounded, isDark, primaryColor),
                ],
              ),
              const SizedBox(height: 20),

              // Dynamic Calculator Body
              if (_selectedCategoryIndex == 0) _buildHouseWiringSection(isDark, primaryColor, lang),
              if (_selectedCategoryIndex == 1) _buildAcServiceSection(isDark, primaryColor, lang),
              if (_selectedCategoryIndex == 2) _buildFixturesSection(isDark, primaryColor, lang),

              const SizedBox(height: 22),

              // Requirement Summary & Free Inspection CTA Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(
                          colors: [primaryColor.withOpacity(0.15), const Color(0xFF0F172A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [primaryColor.withOpacity(0.1), Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lang.tr('Selected Work Scope', 'चुनी गई कार्य योजना'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.safetyGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            lang.tr('FREE ON-SITE VISIT', 'मुफ्त साइट मुआयना'),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AppColors.safetyGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _buildScopeSummary(lang),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang.tr(
                        'Master electrician Chhotu Khan will inspect the premises, assess load requirements, and give a transparent final quotation with zero obligation.',
                        'मास्टर इलेक्ट्रीशियन साइट देखकर लोड और सामग्री का सही मुआयना करेंगे और बिना किसी शुल्क के पारदर्शी कोटेशन देंगे।',
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: lang.tr('Book Free On-Site Inspection', 'मुफ्त साइट मुआयना बुक करें'),
                      icon: Icons.calendar_today_rounded,
                      width: double.infinity,
                      onPressed: () => _proceedToBooking(lang),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Guarantee Note Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user_rounded, color: AppColors.safetyGreen, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lang.tr('Zemtro Electrician Promise', 'ज़ेम्ट्रो इलेक्ट्रीशियन का वादा'),
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang.tr(
                        '• Free on-site survey and guidance for electrical safety\n• Clear estimate before starting any installation or repair\n• 30-day warranty on all electrical work',
                        '• बिजली सुरक्षा और फिटिंग का मुफ्त ऑन-साइट सर्वे\n• काम शुरू करने से पहले पक्का व सही कोटेशन\n• सभी कार्यों पर 30 दिन की सर्विस गारंटी',
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(int index, String title, IconData icon, bool isDark, Color primaryColor) {
    final isSelected = _selectedCategoryIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedCategoryIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor
                : (isDark ? AppColors.darkCard : AppColors.lightCard),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. House Wiring Section
  Widget _buildHouseWiringSection(bool isDark, Color primaryColor, LanguageProvider lang) {
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.tr('Select Property Size', 'मकान या दुकान का आकार'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _homeSize,
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? const Color(0xFF0E1626) : const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              items: _homeSizes.map((size) {
                return DropdownMenuItem(value: size, child: Text(size, style: const TextStyle(fontSize: 13.5)));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _homeSize = val);
              },
            ),
            const SizedBox(height: 14),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                lang.tr('Chemical Earthing Pit Setup', 'केमिकल अर्थिंग पिट फिटिंग'),
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                lang.tr('Protects appliances from lightning & surge', 'उपकरणों को आकाशीय बिजली व करंट से सुरक्षा'),
                style: const TextStyle(fontSize: 11.5),
              ),
              value: _includeEarthing,
              activeColor: primaryColor,
              onChanged: (val) => setState(() => _includeEarthing = val ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                lang.tr('Main Distribution Box & MCB', 'मेन डिस्ट्रीब्यूशन बॉक्स व MCB'),
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                lang.tr('Circuit breaker protection for home safety', 'घर की सुरक्षा के लिए शॉर्ट सर्किट ब्रेकर सेटअप'),
                style: const TextStyle(fontSize: 11.5),
              ),
              value: _includeDbBox,
              activeColor: primaryColor,
              onChanged: (val) => setState(() => _includeDbBox = val ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                lang.tr('Inverter / UPS Line Wiring', 'इन्वर्टर / UPS अलग लाइन वायरिंग'),
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                lang.tr('Dedicated backup line to rooms & fans', 'कमरों व पंखों के लिए अलग बैकअप लाइन'),
                style: const TextStyle(fontSize: 11.5),
              ),
              value: _includeInverter,
              activeColor: primaryColor,
              onChanged: (val) => setState(() => _includeInverter = val ?? false),
            ),
          ],
        ),
      ),
    );
  }

  // 2. AC Service Section
  Widget _buildAcServiceSection(bool isDark, Color primaryColor, LanguageProvider lang) {
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildCounterRow(lang.tr('Split AC Units', 'स्प्लिट AC यूनिट्स'), _splitAcCount, (val) {
              setState(() => _splitAcCount = val);
            }, isDark, primaryColor),
            const Divider(height: 24),
            _buildCounterRow(lang.tr('Window AC Units', 'विंडो AC यूनिट्स'), _windowAcCount, (val) {
              setState(() => _windowAcCount = val);
            }, isDark, primaryColor),
            const Divider(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                lang.tr('Include Refrigerant Gas Check / Refill', 'गैस लीकेज चेक व रिफिल शामिल करें'),
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                lang.tr('Pressure test and cooling coil inspection', 'प्रेशर टेस्टिंग और कूलिंग कॉइल की जांच'),
                style: const TextStyle(fontSize: 11.5),
              ),
              value: _needGasRefill,
              activeColor: primaryColor,
              onChanged: (val) => setState(() => _needGasRefill = val),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Fixtures Section
  Widget _buildFixturesSection(bool isDark, Color primaryColor, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          _buildCounterRow(lang.tr('Ceiling Fans Fitting', 'सीलिंग पंखे फिटिंग'), _fanCount, (val) {
            setState(() => _fanCount = val);
          }, isDark, primaryColor),
          const Divider(height: 24),
          _buildCounterRow(lang.tr('Modular Switchboards', 'मॉड्यूलर स्विचबोर्ड्स'), _switchboardCount, (val) {
            setState(() => _switchboardCount = val);
          }, isDark, primaryColor),
          const Divider(height: 24),
          _buildCounterRow(lang.tr('Concealed / LED Lights', 'कंसील्ड / LED लाइट्स'), _lightPointCount, (val) {
            setState(() => _lightPointCount = val);
          }, isDark, primaryColor),
        ],
      ),
    );
  }

  Widget _buildCounterRow(String label, int value, ValueChanged<int> onChanged, bool isDark, Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                '$value',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}
