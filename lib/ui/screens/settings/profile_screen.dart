import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  final _newAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _addressController = TextEditingController(text: user?.defaultAddress ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _newAddressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      defaultAddress: _addressController.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void _addNewAddressDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Service Address'),
        content: CustomTextField(
          controller: _newAddressController,
          label: 'Address (Makan / Site / Shop)',
          hint: 'House No, Colony, City',
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_newAddressController.text.trim().isNotEmpty) {
                Provider.of<AuthProvider>(context, listen: false)
                    .addAddress(_newAddressController.text.trim());
                _newAddressController.clear();
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Profile'),
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
            text: 'Save Changes',
            icon: Icons.check_circle_rounded,
            onPressed: _saveProfile,
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: AppColors.primaryAmber.withOpacity(0.2),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 52,
                        color: AppColors.primaryAmberDark,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryAmber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Phone Number (Verified)',
                hint: user?.phone ?? '',
                readOnly: true,
                prefixIcon: Icons.phone_android_rounded,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _emailController,
                label: 'Email Address (Optional)',
                hint: 'e.g. name@domain.com',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _addressController,
                label: 'Default Service Address',
                hint: 'Where should electricians visit?',
                maxLines: 2,
                prefixIcon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Addresses (${user?.addresses.length ?? 0})',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addNewAddressDialog,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add New'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (user != null && user.addresses.isNotEmpty)
                ...user.addresses.map((addr) {
                  final isDefault = addr == user.defaultAddress;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDefault
                            ? AppColors.primaryAmber
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isDefault ? Icons.radio_button_checked : Icons.location_on_outlined,
                          color: isDefault ? AppColors.primaryAmber : AppColors.darkTextSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            addr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isDefault ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (!isDefault)
                          TextButton(
                            onPressed: () {
                              auth.updateProfile(defaultAddress: addr);
                              _addressController.text = addr;
                            },
                            child: const Text('Set Default', style: TextStyle(fontSize: 11)),
                          ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
