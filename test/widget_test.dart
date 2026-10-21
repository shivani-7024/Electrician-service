import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ck_electrical_service/main.dart';

void main() {
  testWidgets('All tabs, language toggle, and 5 color themes render completely', (WidgetTester tester) async {
    // Set a phone screen size
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CkElectricalApp());
    await tester.pumpAndSettle();

    // 1. Home Tab verification in default English
    expect(find.text('Zemtro Electrician'), findsOneWidget);
    expect(find.text('Our Core Services'), findsOneWidget);
    expect(find.text('Why Choose Us'), findsOneWidget);

    // 2. Test Language Toggle via LanguageSelectorPill to Hindi
    expect(find.text('हिन्दी'), findsOneWidget);
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();

    // Now verify UI translated to clean Hindi
    expect(find.text('हमारी मुख्य सेवाएं'), findsOneWidget);
    expect(find.text('हमें क्यों चुनें'), findsOneWidget);

    // Toggle back to English
    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();
    expect(find.text('Our Core Services'), findsOneWidget);

    // 3. Services Tab verification
    await tester.tap(find.byIcon(Icons.bolt_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Electrical Services'), findsOneWidget);
    expect(find.textContaining('Services Available'), findsOneWidget);

    // 4. Work Scope Planner Tab verification (no ₹ prices)
    await tester.tap(find.byIcon(Icons.assignment_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Work Scope Planner'), findsOneWidget);
    expect(find.text('Book Free On-Site Inspection'), findsOneWidget);

    // 5. Bookings Tab verification
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();
    expect(find.text('My Service Bookings'), findsOneWidget);
    expect(find.textContaining('Active'), findsOneWidget);

    // 6. Settings Tab verification
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings & Preferences'), findsOneWidget);
    expect(find.textContaining('Theme Color Palette'), findsOneWidget);

    // 7. Test Color Theme Switching (5 colors available)
    expect(find.text('Amber'), findsOneWidget);
    await tester.tap(find.text('Amber'));
    await tester.pumpAndSettle();

    expect(find.text('Green'), findsOneWidget);
    await tester.tap(find.text('Green'));
    await tester.pumpAndSettle();

    // 8. Test Display Mode Switching in Settings
    expect(find.text('Light Mode'), findsOneWidget);
    await tester.tap(find.text('Light Mode'));
    await tester.pumpAndSettle();

    // 9. Quick Contact Sheet verification
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chhotu Khan'), findsOneWidget);
    expect(find.text('Call Master Electrician'), findsOneWidget);
    expect(find.text('Chat on WhatsApp'), findsOneWidget);

    // Dismiss sheet
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    // 10. Back to Home
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Zemtro Electrician'), findsOneWidget);
  });
}
