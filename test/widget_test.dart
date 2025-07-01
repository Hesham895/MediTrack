import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/main.dart';

void main() {
  testWidgets('App loads and shows AuthScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    expect(find.text('الدخول / التسجيل'), findsOneWidget); // عنوان AppBar فريد
    expect(find.text('البريد الإلكتروني'), findsOneWidget); // label فريد
    expect(find.text('الدور'), findsOneWidget); // label فريد
  });
}
