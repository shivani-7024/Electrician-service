import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../providers/service_provider.dart';
import '../../services/service_list_screen.dart';

class CategoryGridSection extends StatelessWidget {
  const CategoryGridSection({super.key});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'home_repair_service_rounded':
        return Icons.home_repair_service_rounded;
      case 'ac_unit_rounded':
        return Icons.ac_unit_rounded;
      case 'factory_rounded':
        return Icons.factory_rounded;
      case 'bolt_rounded':
        return Icons.bolt_rounded;
      case 'battery_charging_full_rounded':
        return Icons.battery_charging_full_rounded;
      case 'lightbulb_circle_rounded':
        return Icons.lightbulb_rounded;
      default:
        return Icons.electrical_services_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Provider.of<LanguageProvider>(context);
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final categories = serviceProvider.categories.where((c) => c.id != 'all').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                lang.tr('Our Core Services', 'हमारी मुख्य सेवाएं'),
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.98,
          ),
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isEmergency = cat.id == 'emergency';
            final title = lang.isHindi && cat.titleHindi.isNotEmpty
                ? cat.titleHindi
                : cat.title;

            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ServiceListScreen(initialCategoryId: cat.id),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isEmergency
                        ? AppColors.emergencyRed.withOpacity(0.4)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isEmergency ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isEmergency
                            ? AppColors.emergencyRed.withOpacity(0.15)
                            : primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIcon(cat.icon),
                        color: isEmergency
                            ? AppColors.emergencyRed
                            : primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
