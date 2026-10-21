import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../providers/service_provider.dart';
import '../../widgets/language_selector_pill.dart';
import '../home/widgets/service_card.dart';

class ServiceListScreen extends StatefulWidget {
  final String? initialCategoryId;

  const ServiceListScreen({super.key, this.initialCategoryId});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialCategoryId != null) {
        Provider.of<ServiceProvider>(context, listen: false)
            .selectCategory(widget.initialCategoryId!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final categories = serviceProvider.categories;
    final filteredServices = serviceProvider.filteredServices;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.tr('Electrical Services', 'इलेक्ट्रिकल सेवाएं')),
        actions: const [
          LanguageSelectorPill(),
          SizedBox(width: 8),
        ],
      ),
      body: ResponsiveWrapper(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => serviceProvider.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: lang.tr(
                    'Search wiring, AC repair, motor starter...',
                    'वायरिंग, AC सर्विस, मोटर स्टार्टर खोजें...',
                  ),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            serviceProvider.clearSearch();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),

            // Horizontal Category Filter Chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = serviceProvider.selectedCategoryId == cat.id;
                  final title = lang.isHindi && cat.titleHindi.isNotEmpty
                      ? cat.titleHindi
                      : cat.title;

                  return ChoiceChip(
                    label: Text(title),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 13,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? primaryColor
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    onSelected: (_) {
                      serviceProvider.selectCategory(cat.id);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Services Count Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${filteredServices.length} ${lang.tr("Services Available", "सेवाएं उपलब्ध")}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  if (serviceProvider.selectedCategoryId != 'all')
                    GestureDetector(
                      onTap: () => serviceProvider.selectCategory('all'),
                      child: Text(
                        lang.tr('Reset Filter', 'सभी देखें'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Services List
            Expanded(
              child: filteredServices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lang.tr('No electrical services found', 'कोई सेवा नहीं मिली'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.tr('Try searching with another keyword', 'अन्य शब्द लिखकर खोजें'),
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: filteredServices.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        return ServiceCard(service: filteredServices[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
