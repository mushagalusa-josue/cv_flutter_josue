import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
}

class Api {
  const Api({this.client});

  final http.Client? client;
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost/api-test/public',
  );

  Future<dynamic> request(String method, String path,
      [Map<String, String>? body]) async {
    final connection = client ?? http.Client();
    try {
      final base = baseUrl.replaceFirst(RegExp(r'/+$'), '');
      final request = http.Request(method, Uri.parse('$base/$path'));
      request.headers['Accept'] = 'application/json';
      if (body != null) {
        request.headers['Content-Type'] = 'application/json; charset=utf-8';
        request.body = jsonEncode(body);
      }
      final response = await connection
          .send(request)
          .then(http.Response.fromStream)
          .timeout(const Duration(seconds: 15));
      final result = jsonDecode(utf8.decode(response.bodyBytes));
      if (result is! Map<String, dynamic>) {
        throw const FormatException();
      }
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          result['success'] != true) {
        final errors = result['errors'];
        throw ApiException(errors is Map && errors.isNotEmpty
            ? errors.values.join('\n')
            : result['message']?.toString() ?? 'La requête a échoué.');
      }
      return result['data'];
    } on TimeoutException {
      throw const ApiException('Le serveur met trop de temps à répondre.');
    } on http.ClientException {
      throw const ApiException('Impossible de joindre le serveur.');
    } on FormatException {
      throw const ApiException('Réponse du serveur illisible.');
    } finally {
      if (client == null) connection.close();
    }
  }
}
