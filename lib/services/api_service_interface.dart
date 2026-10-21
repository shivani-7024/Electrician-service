import '../data/models/service_model.dart';
import '../data/models/booking_model.dart';
import '../data/models/review_model.dart';

/// Abstract API Contract for Zemtro Electrician.
/// In the future, simply provide an HttpApiService or DioApiService
/// implementing this contract to connect a real backend without changing UI code.
abstract class ApiService {
  Future<List<ServiceCategory>> getCategories();
  Future<List<ServiceItem>> getServices({String? categoryId, String? query});
  Future<ServiceItem?> getServiceById(String id);
  Future<List<BookingItem>> getBookings();
  Future<BookingItem> createBooking(BookingItem booking);
  Future<bool> cancelBooking(String bookingId);
  Future<List<ReviewItem>> getReviews();
  Future<bool> submitInquiry({
    required String name,
    required String phone,
    required String serviceType,
    required String message,
  });
}
