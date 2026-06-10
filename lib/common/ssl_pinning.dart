import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinnedHttpClient {
  const SslPinnedHttpClient._();

  static Future<http.Client> create() async {
    try {
      final certificate = await rootBundle.load(
        'assets/certificates/themoviedb_org.pem',
      );
      final securityContext = SecurityContext(withTrustedRoots: false)
        ..setTrustedCertificatesBytes(certificate.buffer.asUint8List());

      return IOClient(HttpClient(context: securityContext));
    } catch (_) {
      return http.Client();
    }
  }
}
