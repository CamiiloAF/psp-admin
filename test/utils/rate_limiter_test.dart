import 'package:flutter_test/flutter_test.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';

void main() {

  group('Verify functionality of RateLimiter class', () {
    final rateLimiter = RateLimiter();
    final testKey = 'testKey';
    final timeout = Duration(seconds: 3);

    test('Verify method shouldFetch calling it first time', () {
      final shouldFetch = rateLimiter.shouldFetch(testKey, timeout);
      expect(shouldFetch, true);
    });

    test('Verify method shouldFetch calling it twice in a row', () {
      rateLimiter.shouldFetch(testKey, timeout);
      final shouldFetch = rateLimiter.shouldFetch(testKey, timeout);

      expect(shouldFetch, false);
    });

    test(
        'Verify method shouldFetch calling two time with 2 seconds of delay between each call',
        () async {
      rateLimiter.shouldFetch(testKey, timeout);
      await Future.delayed(Duration(seconds: 2));
      final shouldFetch = rateLimiter.shouldFetch(testKey, timeout);

      expect(shouldFetch, false);
    });

    test(
        'Verify method shouldFetch calling two time with 3 seconds of delay between each call',
        () async {
      rateLimiter.shouldFetch(testKey, timeout);
      await Future.delayed(Duration(seconds: 3));
      final shouldFetch = rateLimiter.shouldFetch(testKey, timeout);

      expect(shouldFetch, true);
    });

    test(
        'Verify method shouldFetch calling two time with 5 seconds of delay between each call',
        () async {
      rateLimiter.shouldFetch(testKey, timeout);
      await Future.delayed(Duration(seconds: 5));
      final shouldFetch = rateLimiter.shouldFetch(testKey, timeout);

      expect(shouldFetch, true);
    });

    test(
        'Verify method shouldFetch calling two time with 2 seconds'
        ' of delay between each call and a call to RateLimiter.reset() with correct key',
        () async {
      rateLimiter.shouldFetch(testKey, timeout);
      await Future.delayed(Duration(seconds: 2));
      rateLimiter.reset(testKey);
      final shouldFetch = rateLimiter.shouldFetch(testKey, timeout);

      expect(shouldFetch, true);
    });

    test(
        'Verify method shouldFetch calling two time with 2 seconds'
        ' of delay between each call and '
        'a call to RateLimiter.reset() with incorrect key', () async {
      rateLimiter.shouldFetch(testKey, timeout);
      await Future.delayed(Duration(seconds: 2));
      rateLimiter.reset('test');
      final shouldFetch = rateLimiter.shouldFetch(testKey, timeout);

      expect(shouldFetch, false);
    });

    test(
        'Verify method shouldFetch calling two time with 2 seconds'
        ' of delay between each call and '
        'a call to RateLimiter.clear()', () async {
      rateLimiter.shouldFetch(testKey, timeout);
      await Future.delayed(Duration(seconds: 2));
      rateLimiter.clear();
      final shouldFetch = rateLimiter.shouldFetch(testKey, timeout);

      expect(shouldFetch, true);
    });
  });
}
