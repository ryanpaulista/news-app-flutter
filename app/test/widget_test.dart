// Basic smoke tests for the navigation shell.

import 'package:flutter_test/flutter_test.dart';

import 'package:app/app/main.dart';

void main() {
  testWidgets('App opens on the shell with the three bottom-nav tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // The Início feed header is visible…
    expect(find.text('NewsHub'), findsOneWidget);
    // …and all three tabs are present in the BottomNavigationBar.
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });

  testWidgets('Switching to the Favoritos tab shows the empty state', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Favoritos'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhuma notícia salva ainda'), findsOneWidget);
  });
}
