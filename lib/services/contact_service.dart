import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_constants.dart';

/// ContactService handles direct customer interactions:
/// - 1-tap phone dialing
/// - 1-tap WhatsApp chat initiation
/// - Direct SMS and Email
class ContactService {
  ContactService._();

  /// Launches the phone dialer with Zemtro Electrician's contact number
  static Future<bool> callElectrician({String? phone}) async {
    final targetPhone = phone ?? AppConstants.contactPhone;
    // Clean raw digits and leading '+'
    final cleanNumber = targetPhone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        // Fallback for web or desktop
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching phone dialer: $e');
      return false;
    }
  }

  /// Opens WhatsApp directly with a prefilled inquiry message
  static Future<bool> openWhatsApp({
    String? message,
    String? phone,
  }) async {
    final targetPhone = phone ?? AppConstants.whatsappNumber;
    final msg = message ?? AppConstants.defaultWhatsAppMessage;
    final encodedMsg = Uri.encodeComponent(msg);

    // Primary web/mobile URL for WhatsApp
    final url = 'https://wa.me/$targetPhone?text=$encodedMsg';
    final uri = Uri.parse(url);

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
      return false;
    }
  }

  /// Opens WhatsApp specifically with an Emergency breakdown alert
  static Future<bool> openEmergencyWhatsApp() async {
    return openWhatsApp(
      message: AppConstants.emergencyWhatsAppMessage,
    );
  }

  /// Launches email composer
  static Future<bool> sendEmail({String? subject, String? body}) async {
    final sub = Uri.encodeComponent(subject ?? 'Zemtro Electrician Inquiry');
    final content = Uri.encodeComponent(body ?? 'Hello Zemtro Electrician team,');
    final uri = Uri.parse('mailto:${AppConstants.primaryEmail}?subject=$sub&body=$content');

    try {
      return await launchUrl(uri);
    } catch (e) {
      debugPrint('Error launching email: $e');
      return false;
    }
  }
}
