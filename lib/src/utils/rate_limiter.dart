class RateLimiter<KEY> {
  final Map<KEY, int> timestamps = {};

  bool shouldFetch(KEY key, timeout) {
    final lastFetched = timestamps[key];
    final now = DateTime.now().millisecondsSinceEpoch;

    if (lastFetched == null) {
      timestamps[key] = now;
      return true;
    }

    if (now - lastFetched > timeout) {
      timestamps[key] = now;
      return true;
    }

    return false;
  }

  void reset(KEY key) {
    timestamps.remove(key);
  }
}
