import 'package:cv_flutter_josue/main.dart';
import 'package:cv_flutter_josue/profile.dart' as profile;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Josué est le cinquième des neuf enfants', () {
    expect(profile.siblings, hasLength(9));
    expect(profile.siblings[4].name, profile.name);
    expect(profile.parents, hasLength(2));
  });

  testWidgets('Accès direct, navigation et déconnexion', (tester) async {
    await tester.pumpWidget(const CvApp());
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Se connecter'), findsOneWidget);

    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(find.text(profile.name), findsOneWidget);

    await tester.tap(find.text('Famille'));
    await tester.pumpAndSettle();
    expect(find.text('Ma famille'), findsOneWidget);
    expect(find.text('Sifa Bashige Yvette'), findsOneWidget);

    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    expect(find.text('Me contacter'), findsOneWidget);

    await tester.tap(find.byTooltip('Se déconnecter'));
    await tester.pumpAndSettle();
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
