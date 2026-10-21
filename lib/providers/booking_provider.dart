import 'package:flutter/material.dart';
import '../data/mock/mock_bookings.dart';
import '../data/models/booking_model.dart';
import '../services/api_service_interface.dart';
import '../services/mock_api_service.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService _apiService;

  BookingProvider({ApiService? apiService})
      : _apiService = apiService ?? MockApiService() {
    loadBookings();
  }

  List<BookingItem> _bookings = List.from(initialMockBookings);
  bool _isLoading = false;
  String? _errorMessage;

  List<BookingItem> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<BookingItem> get activeBookings => _bookings.where((b) =>
      b.status == BookingStatus.pending ||
      b.status == BookingStatus.confirmed ||
      b.status == BookingStatus.assigned ||
      b.status == BookingStatus.inProgress).toList();

  List<BookingItem> get completedBookings => _bookings.where((b) =>
      b.status == BookingStatus.completed).toList();

  List<BookingItem> get cancelledBookings => _bookings.where((b) =>
      b.status == BookingStatus.cancelled).toList();

  int get activeBookingsCount => activeBookings.length;

  Future<void> loadBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final list = await _apiService.getBookings();
      _bookings = List.from(list);
    } catch (e) {
      _errorMessage = 'Failed to load bookings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<BookingItem?> addBooking({
    required String serviceId,
    required String serviceTitle,
    required String categoryId,
    required String customerName,
    required String phone,
    required String address,
    required DateTime bookingDate,
    required String timeSlot,
    required double totalAmount,
    bool isEmergency = false,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    final newBooking = BookingItem(
      id: 'CK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      serviceId: serviceId,
      serviceTitle: serviceTitle,
      categoryId: categoryId,
      customerName: customerName,
      phone: phone,
      address: address,
      bookingDate: bookingDate,
      timeSlot: timeSlot,
      totalAmount: totalAmount,
      isEmergency: isEmergency,
      notes: notes,
      status: isEmergency ? BookingStatus.assigned : BookingStatus.confirmed,
      electricianName: 'Chhotu Khan (Master Electrician)',
      electricianPhone: '+91 98765 43210',
      createdAt: DateTime.now(),
    );

    try {
      final saved = await _apiService.createBooking(newBooking);
      _bookings.insert(0, saved);
      return saved;
    } catch (e) {
      _errorMessage = 'Booking creation failed: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      final success = await _apiService.cancelBooking(bookingId);
      if (success) {
        final index = _bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          _bookings[index] = _bookings[index].copyWith(status: BookingStatus.cancelled);
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to cancel booking: $e';
      return false;
    }
  }
}
