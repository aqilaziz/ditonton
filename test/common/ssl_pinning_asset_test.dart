import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundles SSL pinning certificate asset', () async {
    final certificate = await rootBundle.load(
      'assets/certificates/themoviedb_org.pem',
    );

    expect(certificate.lengthInBytes, greaterThan(0));
  });
}
