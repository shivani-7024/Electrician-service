import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_helper.dart';
import '../../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final phone = _phoneController.text.trim();
      final success = await authProvider.sendOtp(phone);
      if (success && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              phone: phone,
              name: _nameController.text.trim(),
              address: _addressController.text.trim(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Registration'),
      ),
      body: SafeArea(
        child: ResponsiveWrapper(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Register once to book certified electricians and track service status anytime.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name / पूरा नाम',
                    hint: 'e.g. Ramesh Patel',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _phoneController,
                    label: 'Mobile Number / मोबाइल नंबर',
                    hint: '10-digit mobile number',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_android_rounded,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter mobile number';
                      if (v.replaceAll(RegExp(r'\D'), '').length < 10) {
                        return 'Enter valid 10-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _addressController,
                    label: 'Service Address / पता (Makan / Flat / Shop)',
                    hint: 'House/Flat No, Landmark, Area',
                    maxLines: 2,
                    prefixIcon: Icons.location_on_outlined,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter your address' : null,
                  ),
                  const SizedBox(height: 30),

                  CustomButton(
                    text: 'Register & Send OTP',
                    icon: Icons.arrow_forward_rounded,
                    isLoading: authProvider.isLoading,
                    onPressed: _onRegister,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
