import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../data/models/service_model.dart';
import '../../services/service_detail_screen.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final bool isHorizontal;

  const ServiceCard({
    super.key,
    required this.service,
    this.isHorizontal = false,
  });

  IconData _resolveIcon(String iconName) {
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
      case 'cable_rounded':
        return Icons.cable_rounded;
      case 'electrical_services_rounded':
        return Icons.electrical_services_rounded;
      case 'handyman_rounded':
        return Icons.handyman_rounded;
      case 'speed_rounded':
        return Icons.speed_rounded;
      case 'developer_board_rounded':
        return Icons.developer_board_rounded;
      case 'power_off_rounded':
        return Icons.power_off_rounded;
      case 'toys_rounded':
        return Icons.toys_rounded;
      case 'water_drop_rounded':
        return Icons.water_drop_rounded;
      default:
        return Icons.electrical_services_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lang = Provider.of<LanguageProvider>(context);

    final title = lang.isHindi && service.titleHindi.isNotEmpty
        ? service.titleHindi
        : service.title;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(service: service),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: service.isEmergency
                ? AppColors.emergencyRed.withOpacity(0.4)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: service.isEmergency ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: service.isEmergency
                        ? AppColors.emergencyRed.withOpacity(0.15)
                        : primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _resolveIcon(service.icon),
                    color: service.isEmergency
                        ? AppColors.emergencyRed
                        : primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (service.isEmergency)
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.emergencyRed.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                lang.tr('24/7 EMERGENCY', '24/7 आपातकालीन'),
                                style: const TextStyle(
                                  color: AppColors.emergencyRed,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                          else if (service.isPopular)
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                lang.tr('POPULAR', 'लोकप्रिय'),
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: Color(0xFFEAB308)),
                              const SizedBox(width: 3),
                              Text(
                                '${service.rating}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              service.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.safetyGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_outlined, size: 13, color: AppColors.safetyGreen),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            lang.tr('Free On-Site Quote', 'मुफ्त साइट निरीक्षण'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.safetyGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang.tr('Book Visit', 'जांच बुक करें'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
