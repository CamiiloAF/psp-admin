class RateLimiter<KEY> {
  final Map<KEY, int> timestamps = {};

  static final RateLimiter _instance = RateLimiter._internal();

  factory RateLimiter() {
    return _instance;
  }

  RateLimiter._internal();

  bool shouldFetch(KEY key, Duration timeout) {
    final lastFetched = timestamps[key];
    final now = DateTime.now().millisecondsSinceEpoch;

    if (lastFetched == null) {
      timestamps[key] = now;
      return true;
    }

    if (now - lastFetched > timeout.inMilliseconds) {
      timestamps[key] = now;
      return true;
    }

    return false;
  }

  void reset(KEY key) {
    timestamps.remove(key);
  }
}
