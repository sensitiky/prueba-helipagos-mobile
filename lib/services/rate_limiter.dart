// rate_limiter.dart
import 'dart:async';

class RateLimiter {
  final int maxRequests;
  final Duration period;
  int _requestCount = 0;
  Timer? _timer;

  RateLimiter({required this.maxRequests, required this.period});

  Future<void> acquire() async {
    _timer = Timer(period, () {
      _requestCount = 0;
      _timer?.cancel();
      _timer = null;
    });

    if (_requestCount >= maxRequests) {
      final completer = Completer<void>();
      _timer = Timer(period, () {
        _requestCount = 0;
        _timer?.cancel();
        _timer = null;
        completer.complete();
      });
      await completer.future;
    }

    _requestCount++;
  }
}
