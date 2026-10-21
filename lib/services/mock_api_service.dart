import 'dart:async';
import '../data/models/service_model.dart';
import '../data/models/booking_model.dart';
import '../data/models/review_model.dart';
import '../data/mock/mock_services.dart';
import '../data/mock/mock_bookings.dart';
import '../data/mock/mock_reviews.dart';
import 'api_service_interface.dart';

/// Mock implementation of ApiService.
/// Simulates realistic network delays (200-400ms) and operates on in-memory mock data.
class MockApiService implements ApiService {
  final List<BookingItem> _inMemoryBookings = List.from(initialMockBookings);

  @override
  Future<List<ServiceCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(mockCategories);
  }

  @override
  Future<List<ServiceItem>> getServices({String? categoryId, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var results = List<ServiceItem>.from(mockServices);

    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
      results = results.where((s) => s.categoryId == categoryId).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      results = results.where((s) {
        return s.title.toLowerCase().contains(q) ||
            s.titleHindi.toLowerCase().contains(q) ||
            s.description.toLowerCase().contains(q);
      }).toList();
    }

    return results;
  }

  @override
  Future<ServiceItem?> getServiceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return mockServices.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<BookingItem>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Sort with newest on top
    _inMemoryBookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(_inMemoryBookings);
  }

  @override
  Future<BookingItem> createBooking(BookingItem booking) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _inMemoryBookings.insert(0, booking);
    return booking;
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _inMemoryBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final existing = _inMemoryBookings[index];
      _inMemoryBookings[index] = existing.copyWith(status: BookingStatus.cancelled);
      return true;
    }
    return false;
  }

  @override
  Future<List<ReviewItem>> getReviews() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(mockReviews);
  }

  @override
  Future<bool> submitInquiry({
    required String name,
    required String phone,
    required String serviceType,
    required String message,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
