/// Model representing a verified customer review
class ReviewItem {
  final String id;
  final String customerName;
  final double rating;
  final String comment;
  final String serviceType;
  final String location;
  final String date;
  final bool isVerified;

  const ReviewItem({
    required this.id,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.serviceType,
    required this.location,
    required this.date,
    this.isVerified = true,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'] as String,
      customerName: json['customer_name'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      serviceType: json['service_type'] as String,
      location: json['location'] as String,
      date: json['date'] as String,
      isVerified: json['is_verified'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'rating': rating,
      'comment': comment,
      'service_type': serviceType,
      'location': location,
      'date': date,
      'is_verified': isVerified,
    };
  }
}
