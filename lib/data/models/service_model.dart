/// Model representing a high-level service category (e.g. Makan Wiring, AC, Industrial)
class ServiceCategory {
  final String id;
  final String title;
  final String titleHindi;
  final String icon;
  final String description;

  const ServiceCategory({
    required this.id,
    required this.title,
    required this.titleHindi,
    required this.icon,
    required this.description,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      titleHindi: json['title_hindi'] as String? ?? '',
      icon: json['icon'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_hindi': titleHindi,
      'icon': icon,
      'description': description,
    };
  }
}

/// Model representing a specific electrical service with pricing, warranty, and inclusions
class ServiceItem {
  final String id;
  final String categoryId;
  final String title;
  final String titleHindi;
  final String description;
  final double startingPrice;
  final String priceUnit; // e.g. "per point", "per visit", "per unit", "fixed"
  final String estimatedTime; // e.g. "2 - 4 hours", "1 day"
  final double rating;
  final int reviewsCount;
  final List<String> inclusions;
  final List<String> exclusions;
  final bool isPopular;
  final bool isEmergency;
  final String warrantyPeriod; // e.g. "30 Days Guarantee"
  final String icon;

  const ServiceItem({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.titleHindi,
    required this.description,
    required this.startingPrice,
    required this.priceUnit,
    required this.estimatedTime,
    this.rating = 4.8,
    this.reviewsCount = 45,
    required this.inclusions,
    required this.exclusions,
    this.isPopular = false,
    this.isEmergency = false,
    this.warrantyPeriod = '30 Days Warranty',
    required this.icon,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      titleHindi: json['title_hindi'] as String? ?? '',
      description: json['description'] as String,
      startingPrice: (json['starting_price'] as num).toDouble(),
      priceUnit: json['price_unit'] as String,
      estimatedTime: json['estimated_time'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      inclusions: List<String>.from(json['inclusions'] as List? ?? []),
      exclusions: List<String>.from(json['exclusions'] as List? ?? []),
      isPopular: json['is_popular'] as bool? ?? false,
      isEmergency: json['is_emergency'] as bool? ?? false,
      warrantyPeriod: json['warranty_period'] as String? ?? '30 Days Warranty',
      icon: json['icon'] as String? ?? 'flash_on',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'title_hindi': titleHindi,
      'description': description,
      'starting_price': startingPrice,
      'price_unit': priceUnit,
      'estimated_time': estimatedTime,
      'rating': rating,
      'reviews_count': reviewsCount,
      'inclusions': inclusions,
      'exclusions': exclusions,
      'is_popular': isPopular,
      'is_emergency': isEmergency,
      'warranty_period': warrantyPeriod,
      'icon': icon,
    };
  }
}
