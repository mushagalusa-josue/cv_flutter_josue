import 'dart:convert';

import 'package:cv_flutter_josue/api.dart';
import 'package:cv_flutter_josue/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('Le serveur valide la connexion avant d’ouvrir le CV',
      (tester) async {
    final requests = <String>[];
    final api = Api(client: MockClient((request) async {
      requests.add('${request.method} ${request.url.pathSegments.last}');
      if (request.url.path.endsWith('/accounts/login')) {
        final credentials = jsonDecode(request.body) as Map<String, dynamic>;
        expect(credentials['email'], 'demo@example.com');
        if (credentials['password'] != 'correct123') {
          return http.Response(
              '{"success":false,"message":"Accès refusé"}', 401,
              headers: {'content-type': 'application/json; charset=utf-8'});
        }
        return http.Response('{"success":true,"data":{"id":1}}', 200);
      }
      return http.Response('{"success":true,"data":[]}', 200);
    }));

    await tester.pumpWidget(CvApp(api: api));
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(requests, isEmpty);
    await tester.enterText(
        find.byType(TextFormField).first, 'demo@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'wrong123');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(find.text('Accès refusé'), findsOneWidget);
    expect(find.text('Famille'), findsNothing);
    expect(requests, ['POST login']);

    await tester.enterText(find.byType(TextFormField).last, 'correct123');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(requests, ['POST login', 'POST login', 'GET famille-membres']);

    await tester.tap(find.text('Famille'));
    await tester.pumpAndSettle();
    expect(find.text('Aucun membre enregistré.'), findsOneWidget);
    await tester.tap(find.byTooltip('Se déconnecter'));
    await tester.pumpAndSettle();
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
