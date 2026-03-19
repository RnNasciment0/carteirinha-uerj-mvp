// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:carteirinha_uerj_mvp/main.dart';

void main() {
  testWidgets('App starts and shows splash screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MeuAppUerj());

    // Como seu app começa pela SplashScreen ou LoginScreen, o teste original
    // do contador (que vem no template do Flutter) vai falhar porque 
    // seu app não tem um botão de "+" nem um contador de "0".
    
    // Este teste básico apenas verifica se o app consegue carregar o widget principal.
    expect(find.byType(MeuAppUerj), findsOneWidget);
  });
}
