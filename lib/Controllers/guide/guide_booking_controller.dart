import 'package:supabase_flutter/supabase_flutter.dart';

class GuideBookingController {
  final _supabase = Supabase.instance.client;

  /// Creates a guide booking request with status 'pending_payment'
  /// Returns the booking ID
  Future<String> createBooking({
    required String guideName,
    required int price,
    required String imageUrl,
    required String duration,
    required String customerName,
    required String phoneNumber,
    required String address,
    String? notes,
    String? idImageUrl,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final basePrice = price * int.parse(duration.split(' ')[0]);
    final taxAmount = basePrice * 0.15;
    final totalAmount = basePrice + taxAmount;

    final response = await _supabase
        .from('booking')
        .insert({
          'guide_name': guideName,
          'guide_image': imageUrl,
          'customer_name': customerName,
          'phone_number': phoneNumber,
          'address': address,
          'notes': notes,
          'duration': duration,
          'base_price': basePrice,
          'tax_amount': taxAmount,
          'total_amount': totalAmount,
          'id_image_url': idImageUrl,
          'status': 'pending_payment',
          'created_at': DateTime.now().toIso8601String(),
          'user_id': user.id,
        })
        .select('id');

    if (response.isEmpty) {
      throw Exception("Failed to create booking: no ID returned");
    }

    return response[0]['id'] as String;
  }

  /// Fetches all bookings for the current user with payment info
  Future<List<Map<String, dynamic>>> getUserBookings() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final response = await _supabase
        .from('booking')
        .select('*, payments(*)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response;
  }

  /// Cancels a booking if it belongs to the current user
  Future<void> cancelBooking(String bookingId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _supabase
        .from('booking')
        .update({'status': 'cancelled'})
        .eq('id', bookingId)
        .eq('user_id', user.id);
  }

  /// Updates booking status (for admin/operator use)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _supabase
        .from('booking')
        .update({'status': status})
        .eq('id', bookingId);
  }
}