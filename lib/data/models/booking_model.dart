import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum BookingStatus {
  pending,
  confirmed,
  assigned,
  inProgress,
  completed,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Request Received';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.assigned:
        return 'Electrician Assigned';
      case BookingStatus.inProgress:
        return 'Work In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (this) {
      case BookingStatus.pending:
        return AppColors.urgentOrange;
      case BookingStatus.confirmed:
        return AppColors.electricCyan;
      case BookingStatus.assigned:
        return AppColors.primaryAmber;
      case BookingStatus.inProgress:
        return AppColors.electricBlue;
      case BookingStatus.completed:
        return AppColors.safetyGreen;
      case BookingStatus.cancelled:
        return AppColors.emergencyRed;
    }
  }

  IconData get icon {
    switch (this) {
      case BookingStatus.pending:
        return Icons.hourglass_top_rounded;
      case BookingStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case BookingStatus.assigned:
        return Icons.badge_outlined;
      case BookingStatus.inProgress:
        return Icons.build_circle_outlined;
      case BookingStatus.completed:
        return Icons.verified_rounded;
      case BookingStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}

/// Model representing a customer's service booking request
class BookingItem {
  final String id;
  final String serviceId;
  final String serviceTitle;
  final String categoryId;
  final String customerName;
  final String phone;
  final String address;
  final DateTime bookingDate;
  final String timeSlot;
  final bool isEmergency;
  final String? notes;
  BookingStatus status;
  final double totalAmount;
  final String? electricianName;
  final String? electricianPhone;
  final DateTime createdAt;

  BookingItem({
    required this.id,
    required this.serviceId,
    required this.serviceTitle,
    required this.categoryId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.bookingDate,
    required this.timeSlot,
    this.isEmergency = false,
    this.notes,
    this.status = BookingStatus.confirmed,
    required this.totalAmount,
    this.electricianName = 'Chhotu Khan (Master Electrician)',
    this.electricianPhone = '+91 98765 43210',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  BookingItem copyWith({
    BookingStatus? status,
    String? electricianName,
    String? electricianPhone,
  }) {
    return BookingItem(
      id: id,
      serviceId: serviceId,
      serviceTitle: serviceTitle,
      categoryId: categoryId,
      customerName: customerName,
      phone: phone,
      address: address,
      bookingDate: bookingDate,
      timeSlot: timeSlot,
      isEmergency: isEmergency,
      notes: notes,
      status: status ?? this.status,
      totalAmount: totalAmount,
      electricianName: electricianName ?? this.electricianName,
      electricianPhone: electricianPhone ?? this.electricianPhone,
      createdAt: createdAt,
    );
  }

  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      serviceTitle: json['service_title'] as String,
      categoryId: json['category_id'] as String? ?? 'general',
      customerName: json['customer_name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      timeSlot: json['time_slot'] as String,
      isEmergency: json['is_emergency'] as bool? ?? false,
      notes: json['notes'] as String?,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.confirmed,
      ),
      totalAmount: (json['total_amount'] as num).toDouble(),
      electricianName: json['electrician_name'] as String?,
      electricianPhone: json['electrician_phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'service_title': serviceTitle,
      'category_id': categoryId,
      'customer_name': customerName,
      'phone': phone,
      'address': address,
      'booking_date': bookingDate.toIso8601String(),
      'time_slot': timeSlot,
      'is_emergency': isEmergency,
      'notes': notes,
      'status': status.name,
      'total_amount': totalAmount,
      'electrician_name': electricianName,
      'electrician_phone': electricianPhone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
