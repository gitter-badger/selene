part of selene;

/// A bucketing utility to handle ratelimits.
///
/// Based off of https://github.com/abalabahaha/eris/blob/master/lib/util/SequentialBucket.js
///
/// and https://github.com/CharlotteDunois/Yasmin/blob/master/src/HTTP/RatelimitBucket.php
class RequestBucket {
  /// A store of all currently active [RequestBucket]s.
  static List<RequestBucket> _buckets = [];

  /// The URI to access for this endpoint.
  Uri endpoint;

  /// The Epoch time (seconds since 00:00:00 UTC on January 1st, 1970) at which the ratelimit resets.
  DateTime resetTime = null;

  /// Whether this bucket's current status is on a global endpoint.
  bool isGlobalBucket = false;

  /// The amount of available requests remaining.
  int remaining = null;

  /// The total limit of requests.
  int limit = null;

  /// The REST API to execute requests with.
  RestApiBase restClient;

  /// Creates a new [RequestBucket].
  RequestBucket(
    this.endpoint,
    this.restClient,
  ) {
    _buckets.add(this);
  }

  /// Gets, or creates a new [RequestBucket] for the specified endpoint.
  factory RequestBucket.getOrCreate(Uri endpoint, RestApiBase restClient) {
    return _buckets.firstWhere((bucket) => bucket.endpoint == endpoint,
        orElse: () {
      return new RequestBucket(endpoint, restClient);
    });
  }

  /// Executes a JSON request using this bucket.
  Future<transport.Response> executeRequest(
      transport.JsonRequest request, String method) async {
    transport.Response response;

    if (remaining == null) {
      response = await request.send(method);
    } else {
      if (remaining <= 0) {
        // I don't know how remaining could somehow be lower, but I'm keeping it here for safety.
        throw new RatelimitedException(request as transport.Request);
      }
      response = await request.send(method);
    }

    parseRatelimitHeaders(response);
    return response;
  }

  /// Parses the ratelimit headers from a response.
  void parseRatelimitHeaders(transport.Response response) {
    if (response.headers['X-RateLimit-Remaining'] != null) {
      remaining = int.parse(response.headers['X-RateLimit-Remaining']);
    }

    if (response.headers['X-RateLimit-Limit'] != null) {
      limit = int.parse(response.headers['X-RateLimit-Limit']);
    }

    if (response.headers['X-RateLimit-Reset'] != null) {
      resetTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(response.headers['X-RateLimit-Reset']) ~/
              60, // Convert seconds (from Discord) to milliseconds
          isUtc: true);
    }

    if (response.headers['X-RateLimit-Global'] != null) {
      isGlobalBucket = true;
    } else
      isGlobalBucket = false;
  }
}
