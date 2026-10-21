import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../data/models/service_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'booking_success_screen.dart';

class BookingFormScreen extends StatefulWidget {
  final ServiceItem service;
  final double? estimatedPriceOverride;
  final String? initialNotes;

  const BookingFormScreen({
    super.key,
    required this.service,
    this.estimatedPriceOverride,
    this.initialNotes,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  DateTime _selectedDate = DateTime.now();
  String _selectedTimeSlot = 'Morning (09:00 AM - 12:00 PM)';
  bool _isUrgent = false;

  final List<String> _timeSlots = [
    'Morning (09:00 AM - 12:00 PM)',
    'Afternoon (12:00 PM - 03:00 PM)',
    'Evening (03:00 PM - 07:00 PM)',
    'Night Emergency (07:00 PM - 10:00 PM)',
  ];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: auth.currentUser?.name ?? '');
    _phoneController = TextEditingController(text: auth.currentUser?.phone ?? '');
    _addressController = TextEditingController(text: auth.currentUser?.defaultAddress ?? '');
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    _isUrgent = widget.service.isEmergency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    surface: AppColors.darkCard,
                    onSurface: AppColors.darkTextPrimary,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColors.lightTextPrimary,
                  ),
                ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitBooking() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    final result = await bookingProvider.addBooking(
      serviceId: widget.service.id,
      serviceTitle: widget.service.title,
      categoryId: widget.service.categoryId,
      customerName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      bookingDate: _selectedDate,
      timeSlot: _isUrgent ? 'Emergency Instant (Within 30-45 mins)' : _selectedTimeSlot,
      totalAmount: 0.0, // Zero upfront cost / Free inspection
      isEmergency: _isUrgent,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    if (result != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(booking: result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bookingProvider = Provider.of<BookingProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    final title = lang.isHindi && widget.service.titleHindi.isNotEmpty
        ? widget.service.titleHindi
        : widget.service.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('Book Electrician Visit', 'इलेक्ट्रीशियन विजिट बुक करें')),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
        ),
        child: SafeArea(
          child: CustomButton(
            text: _isUrgent
                ? lang.tr('Dispatch Emergency Electrician', 'इमरजेंसी इलेक्ट्रीशियन भेजें')
                : lang.tr('Confirm Free Inspection Visit', 'मुफ्त साइट जांच बुक करें'),
            icon: Icons.check_circle_rounded,
            isLoading: bookingProvider.isLoading,
            onPressed: _submitBooking,
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Summary Pill
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.electrical_services_rounded,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lang.tr('Free On-Site Inspection & Quote', 'मुफ्त साइट निरीक्षण व सही कोटेशन'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.safetyGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Urgent / Emergency Switch
                Material(
                  color: _isUrgent
                      ? AppColors.emergencyRed.withOpacity(0.1)
                      : (isDark ? AppColors.darkCard : AppColors.lightCard),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: _isUrgent
                          ? AppColors.emergencyRed
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Icon(
                            Icons.flash_on_rounded,
                            color: _isUrgent ? AppColors.emergencyRed : primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            lang.tr('Urgent Emergency Visit', 'आपातकालीन तुरंत विजिट'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _isUrgent ? AppColors.emergencyRed : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        lang.tr(
                          'Electrician dispatched immediately within 30-45 mins',
                          '30-45 मिनट के भीतर इलेक्ट्रीशियन मौके पर पहुंचेगा',
                        ),
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: _isUrgent,
                      activeColor: AppColors.emergencyRed,
                      onChanged: (val) {
                        setState(() => _isUrgent = val);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Customer Contact Information
                Text(
                  lang.tr('Contact Details', 'संपर्क जानकारी'),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _nameController,
                  label: lang.tr('Your Name', 'आपका नाम'),
                  hint: lang.tr('Enter full name', 'पूरा नाम दर्ज करें'),
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => v == null || v.trim().isEmpty ? lang.tr('Please enter name', 'कृपया नाम लिखें') : null,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _phoneController,
                  label: lang.tr('Mobile Number', 'मोबाइल नंबर'),
                  hint: lang.tr('10-digit mobile number', '10 अंकों का मोबाइल नंबर'),
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_android_rounded,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return lang.tr('Enter mobile number', 'मोबाइल नंबर लिखें');
                    if (v.replaceAll(RegExp(r'\D'), '').length < 10) {
                      return lang.tr('Enter valid 10-digit number', 'वैध 10 अंकों का नंबर दर्ज करें');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _addressController,
                  label: lang.tr('Complete Address (House / Shop / Site)', 'पूरा पता (मकान / दुकान / साइट)'),
                  hint: lang.tr('House/Flat no., Landmark, Colony', 'मकान नंबर, गली, लैंडमार्क, कॉलोनी'),
                  maxLines: 2,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (v) => v == null || v.trim().isEmpty ? lang.tr('Please enter address', 'कृपया पता लिखें') : null,
                ),

                const SizedBox(height: 20),

                // Date & Time Selection (only if not emergency instant)
                if (!_isUrgent) ...[
                  Text(
                    lang.tr('Preferred Schedule', 'पसंदीदा समय व तारीख'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Date Picker Button
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: primaryColor, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.tr('Visit Date', 'तारीख'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                                Text(
                                  DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Time Slot Chips
                  Text(
                    lang.tr('Preferred Time Slot', 'समय स्लॉट'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _timeSlots.map((slot) {
                      final isSelected = _selectedTimeSlot == slot;
                      return ChoiceChip(
                        label: Text(slot),
                        selected: isSelected,
                        selectedColor: primaryColor,
                        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? primaryColor
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        onSelected: (_) {
                          setState(() => _selectedTimeSlot = slot);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                ],

                // Problem notes / details
                CustomTextField(
                  controller: _notesController,
                  label: lang.tr('Describe Problem / Scope (Optional)', 'काम या समस्या का विवरण (ऐच्छिक)'),
                  hint: lang.tr('e.g. Switchboard sparking, AC cooling issue, wiring...', 'उदा. स्विचबोर्ड में स्पार्क, AC की कूलिंग, नई वायरिंग...'),
                  maxLines: 2,
                  prefixIcon: Icons.notes_rounded,
                ),

                const SizedBox(height: 20),

                // Guarantee Note
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.safetyGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.safetyGreen.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: AppColors.safetyGreen, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          lang.tr(
                            'Free on-site inspection. Pay only after work completion and satisfaction. 30-day warranty.',
                            'मुफ्त ऑन-साइट मुआयना। काम पूरा और संतुष्ट होने के बाद ही भुगतान करें। 30 दिन की गारंटी।',
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.safetyGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
