part of selene;

/// An exception thrown when the user is being ratelimited.
class RatelimitedException implements Exception {
  final transport.Request request;

  const RatelimitedException(this.request);

  String toString() =>
      'RatelimitedException: Ratelimited trying to access ${request.method} ${request.uri.toString()}';
}
