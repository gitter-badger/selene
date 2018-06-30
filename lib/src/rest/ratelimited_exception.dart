part of selene;

/// An exception thrown when the user is being ratelimited.
class RatelimitedException implements Exception {
  final RequestBucket requestBucket;
  final String method;

  final DateTime resetTime;

  const RatelimitedException(this.requestBucket, this.method, this.resetTime);

  String toString() =>
      'RatelimitedException: Ratelimited trying to access ${method} ${requestBucket.endpoint.toString()}';
}
