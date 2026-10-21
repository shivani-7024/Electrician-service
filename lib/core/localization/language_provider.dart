import 'package:flutter/material.dart';

enum AppLanguage { english, hindi }

/// Manages active application language (English or Hindi)
/// allowing real-time instant bilingual UI switching.
class LanguageProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english; // Default to English

  AppLanguage get language => _language;

  bool get isHindi => _language == AppLanguage.hindi;
  bool get isEnglish => _language == AppLanguage.english;

  void setLanguage(AppLanguage lang) {
    if (_language != lang) {
      _language = lang;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _language = (_language == AppLanguage.english) ? AppLanguage.hindi : AppLanguage.english;
    notifyListeners();
  }

  /// Convenience string picker: returns English or Hindi based on active language
  String tr(String en, String hi) {
    return isHindi ? hi : en;
  }

  // Pre-translated common UI terms
  String get appTitle => isHindi ? 'ज़ेम्ट्रो इलेक्ट्रीशियन' : 'Zemtro Electrician';
  String get verified => isHindi ? 'सत्यापित' : 'VERIFIED';
  String get defaultCity => isHindi ? 'मुख्य शहर व औद्योगिक क्षेत्र' : 'Main City & Industrial Zone';
  
  // Navigation tabs
  String get tabHome => isHindi ? 'होम' : 'Home';
  String get tabServices => isHindi ? 'सेवाएं' : 'Services';
  String get tabPlanner => isHindi ? 'कार्य योजना' : 'Planner';
  String get tabBookings => isHindi ? 'बुकिंग्स' : 'Bookings';
  String get tabSettings => isHindi ? 'सेटिंग्स' : 'Settings';

  // Navigation aliases
  String get navHome => tabHome;
  String get navServices => tabServices;
  String get navEstimator => tabPlanner;
  String get navBookings => tabBookings;
  String get navSettings => tabSettings;

  // Actions
  String get callElectrician => isHindi ? 'मिस्त्री को कॉल करें' : 'Call Electrician';
  String get callNow => isHindi ? 'कॉल करें' : 'Call Now';
  String get chatWhatsApp => isHindi ? 'व्हाट्सएप' : 'WhatsApp';
  String get bookVisit => isHindi ? 'मुफ्त विजिट बुक करें' : 'Book Free Visit';
  String get bookInspection => isHindi ? 'मुफ्त साइट जांच बुक करें' : 'Book Free Inspection';
  String get getQuote => isHindi ? 'कोटेशन प्राप्त करें' : 'Get Free Quote';
  String get viewAll => isHindi ? 'सभी देखें' : 'View All';
  String get emergencyTitle => isHindi ? '24/7 आपातकालीन रिपेयर' : '24/7 Emergency Repairs';
  String get emergencySubtitle => isHindi ? 'शॉर्ट सर्किट, स्पार्किंग या ब्लैकआउट? 30 मिनट में पहुंचें' : 'Short circuit, sparking or blackout? We reach in 30 mins';
}
