import 'package:flutter_test/flutter_test.dart';
import 'package:tm_classifier/services/classifier.dart';

void main() {
  test('parses a normal labels file', () {
    expect(parseLabels('0 Apple\n1 Banana\n'), ['Apple', 'Banana']);
  });

  test('handles Windows line endings, blank lines and spaces in labels', () {
    expect(parseLabels('0 Apple\r\n1 Banana\r\n2 Dragon fruit\r\n\r\n'), [
      'Apple',
      'Banana',
      'Dragon fruit',
    ]);
  });
}
